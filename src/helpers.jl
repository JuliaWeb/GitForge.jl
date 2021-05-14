macro endpoint(fun::Expr, epargs=:auto)
    fname = esc(fun.args[1])
    fargs = fun.args[2:end]
    epargs === :auto && (epargs = Expr(:tuple, map(ex -> ex.args[1], fargs)...))

    quote
        export $fname
        Base.@__doc__ $fname(f::Forge, $(fargs...); kwargs...) =
            request(f, $fname, endpoint(f, $fname, $epargs...); kwargs...)
    end
end

"""
    @json struct T ... end

Create a type that can be parsed from JSON.
"""
macro json(def::Expr)
    T = esc(def.args[2])
    renames = Tuple{Symbol, Symbol}[]
    names = Symbol[]

    code = Expr[]

    for field in def.args[3].args
        field isa Expr || continue
        if field.head === :(::)
            push!(names, field.args[1])
            # Make the field nullable.
            field.args[2] = :(Union{$(esc(field.args[2])), Nothing})
        elseif field.head === :call && field.args[1] === :(=>)
            push!(names, field.args[2])
            # Convert from => to::F to to::F, and record the old name.
            from = field.args[2]
            to, F = field.args[3].args
            field.head = :(::)
            field.args = [to, :(Union{$(esc(F)), Nothing})]
            push!(renames, (to, from))
        else
            @warn "Invalid field expression $field"
        end
    end

    # Add a field for unhandled keys.
    push!(def.args[3].args, :(_extras::NamedTuple))

    # Document the struct.
    push!(code, :(Base.@__doc__ $def))

    # Create a keyword constructor.
    splat = esc(:kwargs)  # TODO: This seems... wrong. Hygiene is weird.
    kws = map(name -> Expr(:kw, name, :nothing), names)
    push!(code, :($T(; $(kws...), $splat...) = $T($(names...), (; $splat...))))

    # Register the type with StructTypes with any renames.
    push!(code, :(StructTypes.StructType(::Type{$T}) = UnorderedStruct()))
    push!(code, :(StructTypes.names(::Type{$T}) = $(tuple(renames...))))

    return Expr(:block, code...)
end
