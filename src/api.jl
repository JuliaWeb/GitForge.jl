"""
    get_user(::Forge[, name::$AStr])

Get the currently authenticated user, or a user by name.
"""
@endpoint get_user()
@endpoint get_user(name::AStr)

"""
    get_users(::Forge)

Get all users.
"""
@endpoint get_users()

"""
    get_user_repos(::Forge[, name::$AStr])

Get the currently authenticated user's repositories, or those of a user by name.
"""
@endpoint get_user_repos()
@endpoint get_user_repos(name::AStr)

"""
    get_repo(::Forge, owner::$AStr, repo::$AStr)

Get a repository by owner and name.
"""
@endpoint get_repo(owner::AStr, repo::AStr)

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

Get a file from a repository.
"""
@endpoint get_file_contents(owner::AStr, repo::AStr, path::AStr)

"""
    get_pull_request(::Forge, owner::$AStr, repo::$AStr, number::Integer)

Get a specific pull request.
"""
@endpoint get_pull_request(owner::AStr, repo::AStr, number::Integer)

"""
    get_pull_requests(::Forge, owner::$AStr, repo::$AStr)

List a repository's pull requests.
"""
@endpoint get_pull_requests(owner::AStr, repo::AStr)

"""
    create_pull_request(::Forge, owner::$AStr, repo::$AStr; kwargs...)

Create a pull request.
"""
@endpoint create_pull_request(owner::AStr, repo::AStr)

"""
    update_pull_request(
        ::Forge,
        owner::$AStr,
        repo::$AStr,
        number::Integer;
        kwargs...,
    )

Update a pull request.
"""
@endpoint update_pull_request(owner::AStr, repo::AStr, number::Integer)

"""
    get_commit(::Forge, owner::$AStr, repo::$AStr, ref::$AStr)

Get a commit from a repository.
"""
@endpoint get_commit(owner::AStr, repo::AStr, ref::AStr)

"""
    is_collaborator(
        ::Forge,
        owner::$AStr,
        repo::$AStr,
        name_or_id::Union{$AStr, Integer},
    )

Check whether or not a user is a collaborator on a repository.

- For [`GitHub.GitHubAPI`](@ref), use a username.
- For [`GitLab.GitLabAPI`](@ref), use a user ID.
"""
@endpoint is_collaborator(owner::AStr, repo::AStr, name_or_id::Union{AStr, Integer})

"""
    is_member(::Forge, org::$AStr, name_or_id::Union{$AStr, Integer})

Check whether or not a user is a member of an organization.

- For [`GitHub.GitHubAPI`](@ref), use a username.
- For [`GitLab.GitLabAPI`](@ref), use a user ID.
"""
@endpoint is_member(org::AStr, name_or_id::Union{AStr, Integer})

"""
    get_tags(::Forge, owner::$AStr, repo::$AStr)

Get a list of tags from a repository.
"""
@endpoint get_tags(owner::AStr, repo::AStr)
