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

    # Make all fields nullable, and figure out if we need to modify any field names.
    renames = Expr[]
    for field in ex.args[3].args
        field isa Expr || continue
        if field.head === :(::)
            field.args[2] = :(Union{$(field.args[2]), Nothing})
        elseif field.head === :call && field.args[1] === :(=>)
            from = QuoteNode(field.args[2])
            to, T = field.args[3].args
            field.head = :(::)
            field.args = [to, :(Union{$T, Nothing})]
            push!(renames, :($to => (; name=$from)))
        else
            @warn "Invalid field expression $field"
        end
    end

    # Add a zero argument constructor.
    T = ex.args[2]
    nothings = repeat([nothing], count(ex -> ex isa Expr, ex.args[3].args))
    push!(ex.args[3].args, :($T() = new($(nothings...))))

    # Apply the noargs format with any renames, and set the default parse options.
    ex = Expr(:block, ex, :(JSON2.@format $T noargs))
    push!(ex.args[end].args, Expr(:block, renames...))
    defaultopts = quote
        if isdefined(@__MODULE__, :JSON_OPTS)
            JSON2.defaultopts(::Type{$T}) = getfield(@__MODULE__, :JSON_OPTS)
        end
    end
    push!(ex.args, defaultopts)

    esc(ex)
end
