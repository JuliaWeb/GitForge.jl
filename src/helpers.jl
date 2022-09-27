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
    @json FORGETYPE struct T ... end

Create a type that can be parsed from JSON.

Optionally accept a forge type for struct names that do not follow the ModuleAPI convention
"""
macro json(def::Expr)
    forge = try
        getfield(__module__, Symbol(string(nameof(__module__)) * "API"))
    catch
        throw("No forge struct named $forge. Make one or pass $(__module__)'s forge struct to @json $(def.args[2])")
    end
    json(forge, def)
end

macro json(forgesym::Symbol, def::Expr)
    forge = try
        getfield(__module__, forgesym)
    catch
        throw("No struct named $forgesym, pass a valid API to @json $(def.args[2])")
    end
    !(forge <: GitForge.ForgeType) && throw("$forge is not a ForgeType, pass a valid API to @json $(def.args[2])")
    json(forge, def)
end

function json(forge::Type, def::Expr)
    # TODO: This doesn't work for parametric types or types with supertypes.
    T = esc(def.args[2])
    renames = Tuple{Symbol, Symbol}[]
    names = Symbol[]

    for field in def.args[3].args
        field isa Expr || continue
        if field.head === :(::)
            push!(names, field.args[1])
            # Make the field nullable.
            field.args[2] = :(Union{$(esc(field.args[2])), Nothing})
        elseif field.head === :call && field.args[1] === :(=>)
            # Convert from => to::F to to::F, and record the old name.
            from = field.args[2]
            to, F = field.args[3].args
            field.head = :(::)
            field.args = [to, :(Union{$(esc(F)), Nothing})]
            push!(renames, (to, from))
            push!(names, to)
        else
            @warn "Invalid field expression $field"
        end
    end

    # Make the type a subtype of `ForgeType`.
    def.args[2] = :($T <: ForgeType)

    # Add a field for unhandled keys.
    push!(def.args[3].args, :(_extras::NamedTuple))

    # keywords for the keyword constructor.
    kws = map(name -> Expr(:kw, name, :nothing), names)
    extras = esc(:_extras)

    #pretty equality args
    a = esc(:a)
    b = esc(:b)
    eq = esc(:(Base.:(==)))

    quote
        Base.@__doc__ $def
    
        # sort extras so they can compare for equality
        $T(; $(kws...), $extras) =
            $T($(names...), (; sort!([pairs($extras)...], by = first)...))

        # equality
        function $eq($a::$T, $b::$T)
            $(foldr((x, y)-> :($x && $y), [:($a.$n == $b.$n) for n in [names..., :_extras]]))
        end

        # Set up field renames.
        StructTypes.names(::Type{$T}) = $(tuple(renames...))

        # define forgeof(TYPE) = ModuleAPI (or the given forge struct)
        GitForge.forgeof(::Type{$T}) = $forge
    end
end

"""
    @forge API-STRUCT-NAME

if you have defined DEFAULT_DATEFORMAT, put this after the API struct definition
to handle date parsing.

Other automatic parsing methods can be added here.
"""
macro forge(f)
    forge = esc(f)
    result = quote end
    code = result.args
    fmt = try
        getfield(__module__, :DEFAULT_DATEFORMAT)
    catch
    end
    fmt === nothing && return :()
    quote
        function GitForge.constructfield(::GitForge.FieldContext{$forge}, ::Type{Union{Date, Nothing}}, str::AbstractString)
            Date(str, $fmt)
        end
        function GitForge.constructfield(::GitForge.FieldContext{$forge}, ::Type{Union{DateTime, Nothing}}, str::AbstractString)
            DateTime(str, $fmt)
        end
        function GitForge.write(::FieldContext{$forge, T, F}, buf, pos, len, date::Date; kw...) where {T, F}
            JSON3.write(StringType(), buf, pos, len, Dates.format(date, $fmt))
        end
        function GitForge.write(::FieldContext{$forge, T, F}, buf, pos, len, date::DateTime; kw...) where {T, F}
            JSON3.write(StringType(), buf, pos, len, Dates.format(date, $fmt))
        end
    end
end

mungetime(v) =
    replace(replace(v, r"(\.[0-9]{3})([0-9]*)[+-]" => s"\1+"), r"(:[0-9]{2})([+-])" => s"\1.000\2")
