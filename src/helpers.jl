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

    # Apply the noargs JSON2 format with any necessary renames.
    ex = Expr(:block, ex, :(JSON2.@format $T noargs))
    push!(ex.args[2].args, Expr(:block, renames...))

    esc(ex)
end

# TODO: Get rid of this (and Union{Date[Time], String}) when quinnj/JSON2.jl#23 is solved.
function parsedatetimes!(x::T) where T
    isimmutable(x) && return x
    M = parentmodule(T)
    parentmodule(M) === (@__MODULE__) || return x
    date = getfield(M, :DATE_FORMAT)
    datetime = getfield(M, :DATE_TIME_FORMAT)

    for (fn, ft) in zip(fieldnames(T), fieldtypes(T))
        val = getfield(x, fn)
        val isa String || continue
        if Date <: ft
            setfield!(x, fn, Date(val, date))
        elseif DateTime <: ft
            setfield!(x, fn, DateTime(val, datetime))
        end
    end

    return x
end
