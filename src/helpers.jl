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
    # - Make all fields nullable, and with a default value of `nothing`.
    # - Give the struct a keyword constructor.
    # - Figure out if we need to modify any field names.
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
        field.args = [copy(field), :nothing]
        field.head = :(=)
    end
    ex = :(Base.@kwdef $ex)

    # Apply the kwargs format with any renames, and set the default parse options.
    T = ex.args[3].args[2]
    ex = Expr(:block, ex, :(JSON2.@format $T keywordargs))
    push!(ex.args[end].args, Expr(:block, renames...))
    dfkws = quote
        if isdefined(@__MODULE__, :JSON_OPTS)
            # This isn't how you're "supposed" to do this, but I'm not quite sure
            # how to pass these options as literal keyword arguments to @format.
            JSON2.defaultkwargs(::Type{$T}) = JSON_OPTS
        end
    end
    push!(ex.args, dfkws)

    esc(ex)
end
