"""
    get_user(::Forge[, name_or_id::Union{AbstractString, Integer}])

Get the currently authenticated user, or a user by name or ID.
"""
@endpoint get_user()
@endpoint get_user(name_or_id::Union{AbstractString, Integer}) [name_or_id]


"""
    get_users(::Forge)

Get all users.
"""
@endpoint get_users()

"""
    update_user(::Forge[, id::Integer]; kwargs...)

Update the currently authenticated user, or a user by ID.
"""
@endpoint update_user()
@endpoint update_user(id::Integer) [id]
