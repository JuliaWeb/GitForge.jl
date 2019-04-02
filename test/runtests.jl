using GitForge
using HTTP
using JSON2
using Test

const GF = GitForge

function capture(f::Function)
    so = stdout
    r, w = redirect_stdout()
    out = @async read(r, String)
    result = f()
    redirect_stdout(so)
    close(w)
    return result, fetch(out)
end

struct TestPostProcessor <: GF.PostProcessor end
GF.postprocess(::TestPostProcessor, ::HTTP.Response, ::Type) = :foo

struct TestForge <: GF.Forge end
GF.base_url(::TestForge) = "https://httpbin.org"
GF.request_headers(::TestForge, ::Function) = ["Foo" => "Bar"]
GF.request_query(::TestForge, ::Function) = Dict("foo" => "bar")
GF.request_kwargs(::TestForge, ::Function) = Dict(:verbose => 1)
GF.postprocessor(::TestForge, ::Function) = TestPostProcessor()
GF.endpoint(::TestForge, ::typeof(get_user)) = GF.Endpoint(:GET, "/get")
GF.into(::TestForge, ::typeof(get_user)) = Symbol

@testset "GitForge.jl" begin
    f = TestForge()
    result, out = capture(() -> get_user(f))

    @testset "Basics" begin
        @test GF.value(result) === :foo
        @test GF.response(result) isa HTTP.Response
        @test GF.exception(result) === nothing
    end

    @testset "Request options" begin
        body = JSON2.read(IOBuffer(GF.response(result).body))
        @test startswith(get(body, :url, ""), "https://httpbin.org")
        @test get(get(body, :headers, Dict()), :Foo, "") == "Bar"
        @test get(get(body, :args, Dict()), :foo, "") == "bar"
        @test occursin("/get", get(body, :url, ""))
        @test !isempty(out)
    end

    @testset "Per-call request options" begin
        result, out = capture() do
            get_user(
                f;
                query=Dict("a" => "b"),
                headers=["A" => "B"],
                request_opts=(; verbose=0),
            )
        end

        @test GF.exception(result) === nothing
        @test isempty(out)

        body = JSON2.read(IOBuffer(GF.response(result).body))
        @test haskey(body.headers, :Foo)
        @test get(body.headers, :A, "") == "B"
        @test haskey(get(body, :args, Dict()), :foo)
        @test get(get(body, :args, Dict()), :a, "") == "b"
    end
end
