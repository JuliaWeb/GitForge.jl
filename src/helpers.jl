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
macro json(def::Expr)
    T = def.args[2]
    renames = Expr[]
    names = Symbol[]

    for field in def.args[3].args
        field isa Expr || continue
        if field.head === :(::)
            push!(names, field.args[1])
            # Make the field nullable.
            field.args[2] = :(Union{$(field.args[2]), Nothing})
        elseif field.head === :call && field.args[1] === :(=>)
            push!(names, field.args[2])
            # Convert from => to::F to to::F, and record the old name.
            from = QuoteNode(field.args[2])
            to, F = field.args[3].args
            field.head = :(::)
            field.args = [to, :(Union{$F, Nothing})]
            push!(renames, :($to => (; name=$from)))
        else
            @warn "Invalid field expression $field"
        end
    end

    # Add a field for unhandled keys.
    push!(def.args[3].args, :(_extras::NamedTuple))

    # Document the struct.
    def = :(Base.@__doc__ $def)

    # Create a keyword constructor.
    kws = map(name -> Expr(:kw, name, :nothing), names)
    cons = :($T(; $(kws...), kwargs...) = $T($(names...), (; kwargs...)))

    # Apply the kwargs format with any renames.
    fmt = :(JSON2.@format $T keywordargs)
    isempty(renames) || push!(fmt.args, Expr(:block, renames...))

    # Set the default parse options,
    dfkws = quote
        if isdefined(@__MODULE__, :JSON_OPTS)
            # This isn't how you're "supposed" to do this, but I'm not quite sure
            # how to pass these options as literal keywords to @format.
            JSON2.defaultkwargs(::Type{$T}) = JSON_OPTS
        end
    end

    esc(Expr(:block, def, cons, fmt, dfkws))
end
