"""
    get_user(::Forge[, name_or_id::Union{AbstractString, Integer}])

Get the currently authenticated user, or a user by name or ID.
"""
@endpoint get_user()
@endpoint get_user(name_or_id::Union{AbstractString, Integer})


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
@endpoint update_user(id::Integer)

"""
    create_user(::Forge; kwargs...)

Create a new user.
"""
@endpoint create_user()

"""
    delete_user(::Forge, id::Integer)

Delete a user by ID.
"""
@endpoint delete_user(id::Integer)

"""
    get_repos(::Forge[, name_or_id::Union{AbstractString, Integer}])

Get the currently authenticated user's repositories, or those of a user by name or ID.
"""
@endpoint get_repos()
@endpoint get_repos(name_or_id::Union{AbstractString, Integer})
