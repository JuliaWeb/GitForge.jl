macro endpoint(fun::Expr, epargs=:auto)
    fname = fun.args[1]
    fargs = fun.args[2:end]
    epargs === :auto && (epargs = Expr(:tuple, map(ex -> ex.args[1], fargs)...))

    ex = quote
        export $fname
        Base.@__doc__ $fname(f::Forge, $(fargs...); kwargs...) =
            request(f, $fname, endpoint(f, $fname, $epargs...); kwargs...)
    end

    esc(ex)
end

"""
    @json struct T ... end

Create a type that can be parsed from JSON.
"""
macro json(ex::Expr)
    # Make the struct mutable.
    ex.args[1] = true

    # Make all fields nullable.
    foreach(ex.args[3].args) do ex
        ex isa Expr && (ex.args[2] = :(Union{$(ex.args[2]), Nothing}))
    end

    # Add a zero argument constructor.
    T = ex.args[2]
    nothings = repeat([nothing], count(ex -> ex isa Expr, ex.args[3].args))
    push!(ex.args[3].args, :($T() = new($(nothings...))))

    # Apply the noargs JSON2 format.
    ex = Expr(:block, ex, :(JSON2.@format $T noargs))

    esc(ex)
end
