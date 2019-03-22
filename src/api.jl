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
