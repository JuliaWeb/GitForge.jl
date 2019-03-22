macro endpoint(method::Symbol, fun::Expr)
    esc(make_endpoint(method, fun, :(())))
end

macro endpoint(method::Symbol, fun::Expr, epargs::Expr)
    esc(make_endpoint(method, fun, epargs))
end

function make_endpoint(method::Symbol, fun::Expr, epargs::Expr)
    fname = fun.args[1]
    fargs = fun.args[2:end]
    return quote
        export $fname
        Base.@__doc__ function $fname(f::Forge, $(fargs...); kwargs...)
            return request(
                f,
                $fname,
                endpoint(f, $fname, $(epargs)...),
                $(QuoteNode(method));
                kwargs...,
            )
        end
    end
end

"""
    get_user(::Forge)

Get the currently authenticated user.
"""
@endpoint GET get_user()

"""
    get_user(::Forge, name_or_id::Union{AbstractString, Integer})

Get a user by name or ID.
"""
@endpoint GET get_user(name_or_id::Union{AbstractString, Integer}) [name_or_id]


"""
    get_users(::Forge)

Get all users.
"""
@endpoint GET get_users()
