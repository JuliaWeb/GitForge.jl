"""
    get_user(::Forge[, name_or_id::Union{$AStr, Integer}])

Get the currently authenticated user, or a user by name or ID.
"""
@endpoint get_user()
@endpoint get_user(name_or_id::Union{AStr, Integer})

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
    get_user_repos(::Forge[, name_or_id::Union{$AStr, Integer}])

Get the currently authenticated user's repositories, or those of a user by name or ID.
"""
@endpoint get_user_repos()
@endpoint get_user_repos(name_or_id::Union{AStr, Integer})

"""
    get_repo(::Forge, owner::$AStr, repo::$AStr)
    get_repo(::Forge, id::Integer)

Get a repository by owner and name or ID.
"""
@endpoint get_repo(owner::AStr, repo::AStr)
@endpoint get_repo(id::Integer)

"""
    get_branch(::Forge, owner::AbstractString, repo::AbstractString, branch::AbstractString)

Get a branch from a repository.
"""
@endpoint get_branch(owner::AStr, repo::AStr, branch::AStr)

"""
    get_file_contents(
        ::Forge,
        owner::$AStr,
        repo::$AStr,
        path::$AStr,
    )
    get_file_contents(f::Forge, id::Integer, path::$AStr)

Get a file from a repository.
"""
@endpoint get_file_contents(owner::AStr, repo::AStr, path::AStr)
@endpoint get_file_contents(id::Integer, path::AStr)

"""
    get_pull_request(::Forge, owner::$AStr, repo::$AStr, number::Integer)
    get_pull_request(::Forge, project::Integer, number::Integer)

Get a specific pull request.
"""
@endpoint get_pull_request(owner::AStr, repo::AStr, number::Integer)
@endpoint get_pull_request(project::Integer, number::Integer)

"""
    get_pull_requests(::Forge, owner::$AStr, repo::$AStr)
    get_pull_requests(::Forge, project::Integer)

List a repository's pull requests.
"""
@endpoint get_pull_requests(owner::AStr, repo::AStr)
@endpoint get_pull_requests(repo::Integer)

"""
    create_pull_requests(::Forge, owner::$AStr, repo::$AStr; kwargs...)
    create_pull_requests(::Forge, project::Integer; kwargs...)

Create a pull request.
"""
@endpoint create_pull_request(owner::AStr, repo::AStr)
@endpoint create_pull_request(project::Integer)

"""
    get_commit(::Forge, owner::$AStr, repo::$AStr, ref::$AStr)
    get_commit(::Forge, project::Integer, ref::$AStr)

Get a commit from a repository.
"""
@endpoint get_commit(owner::AStr, repo::AStr, ref::AStr)
@endpoint get_commit(project::Integer, ref::AStr)

"""
    is_collaborator(
        ::Forge,
        owner::$AStr,
        repo::$AStr,
        name_or_id::Union{$AStr, Integer},
    )

Check whether or not a user is a collaborator on a repository.
"""
@endpoint is_collaborator(owner::AStr, repo::AStr, name_or_id::Union{AStr, Integer})

"""
    is_member(::Forge, org::$AStr, name_or_id::Union{$AStr, Integer})

Check whether or not a user is a member of an organization.
"""
@endpoint is_member(org::AStr, name_or_id::Union{AStr, Integer})
