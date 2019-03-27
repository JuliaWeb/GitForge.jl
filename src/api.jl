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
    get_user_repos(::Forge[, name_or_id::Union{AbstractString, Integer}])

Get the currently authenticated user's repositories, or those of a user by name or ID.
"""
@endpoint get_user_repos()
@endpoint get_user_repos(name_or_id::Union{AbstractString, Integer})

"""
    get_pull_request(::Forge, owner::AbstractString, repo::AbstractString, number::Integer)
    get_pull_request(::Forge, project::Integer, number::Integer)

Get a specific pull request.
"""
@endpoint get_pull_request(owner::AbstractString, repo::AbstractString, number::Integer)
@endpoint get_pull_request(project::Integer, number::Integer)

"""
    get_pull_requests(::Forge, owner::AbstractString, repo::AbstractString)
    get_pull_requests(::Forge, project::Integer)

List a repository's pull requests.
"""
@endpoint get_pull_requests(owner::AbstractString, repo::AbstractString)
@endpoint get_pull_requests(repo::Integer)

"""
    create_pull_requests(::Forge, owner::AbstractString, repo::AbstractString; kwargs...)
    create_pull_requests(::Forge, project::Integer; kwargs...)

Create a pull request.
"""
@endpoint create_pull_request(owner::AbstractString, repo::AbstractString)
@endpoint create_pull_request(project::Integer)
