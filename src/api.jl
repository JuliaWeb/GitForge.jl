const ID = Union{Integer, UUID}
const NameOrId = Union{AStr, ID}

"""
    get_user(::Forge[, name_or_id::Union{$AStr, Integer, UUID}])

Get the currently authenticated user, or a user by name or ID.
"""
@endpoint get_user()
@endpoint get_user(name_or_id::NameOrId)

"""
    get_users(::Forge)

Get all users.
"""
@endpoint get_users()

"""
    update_user(::Forge[, id::Union{Integer, UUID}]; kwargs...)

Update the currently authenticated user, or a user by ID.
"""
@endpoint update_user()
@endpoint update_user(id::ID)

"""
    create_user(::Forge; kwargs...)

Create a new user.
"""
@endpoint create_user()

"""
    delete_user(::Forge, id::Union{Integer, UUID})

Delete a user by ID.
"""
@endpoint delete_user(id::ID)

"""
    get_user_repos(::Forge[, name_or_id::Union{$AStr, Integer, UUID}])

Get the currently authenticated user's repositories, or those of a user by name or ID.
"""
@endpoint get_user_repos()
@endpoint get_user_repos(name_or_id::NameOrId)

"""
    get_repo(::Forge, owner_repo::$AStr)
    get_repo(::Forge, owner::$AStr, repo::$AStr)
    get_repo(::Forge, id::Integer)
    get_repo(::Forge, id::UUID)
    get_repo(::Forge, owner::$AStr, subgroup::$AStr, repo::$AStr)

Get a repository by owner and name or ID.
"""
@endpoint get_repo(owner_repo::AStr)
@endpoint get_repo(owner::AStr, repo::AStr)
@endpoint get_repo(id::Integer)
@endpoint get_repo(id::UUID)
@endpoint get_repo(owner::AStr, subgroup::AStr, repo::AStr)

"""
    create_repo(::Forge, owner::$AStr)
    create_repo(::Forge)
Create a repository.
If using GitHub and you want to create a repository in an organization, pass the organization name as argument.
"""
@endpoint create_repo(owner::AStr, repo::AStr)
@endpoint create_repo(owner::NameOrId)
@endpoint create_repo()

"""
    get_branch(::Forge, owner::AbstractString, repo::AbstractString, branch::AbstractString)

Get a branch from a repository.
"""
@endpoint get_branch(owner::AStr, repo::AStr, branch::AStr)

"""
    get_branches(::Forge, owner::AbstractString, repo::AbstractString)

Get all branches for a repository.
"""
@endpoint get_branches(owner::AStr, repo::AStr)

"""
    delete_branch(::Forge, owner::AbstractString, repo::AbstractString, branch::AbstractString)

Delete a branch from a repository.
"""
@endpoint delete_branch(owner::AStr, repo::AStr, branch::AStr)

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
    create_pull_request(::Forge, owner::$AStr, repo::$AStr; kwargs...)
    create_pull_request(::Forge, project::Integer; kwargs...)

Create a pull request.
"""
@endpoint create_pull_request(owner::AStr, repo::AStr)
@endpoint create_pull_request(project::Integer)

"""
    update_pull_request(::Forge, owner::$AStr, repo::$AStr, number::Integer; kwargs...)
    update_pull_request(::Forge, project::Integer, number::Integer; kwargs...)

Update a pull request.
"""
@endpoint update_pull_request(owner::AStr, repo::AStr, number::Integer)
@endpoint update_pull_request(project::Integer, number::Integer)


"""
    subscribe_to_pull_request(::Forge, project::Integer, pull_request_id::Integer)

Subscribe to notifications for the supplied project and pull request ID.
"""
@endpoint subscribe_to_pull_request(project::Integer, pull_request_id::Integer)

"""
    unsubscribe_from_pull_request(::Forge, project::Integer, pull_request_id::Integer)

Unsubscribe from notifications for the supplied project and pull request ID.
"""
@endpoint unsubscribe_from_pull_request(project::Integer, pull_request_id::Integer)

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
        name_or_id::Union{$AStr, Integer, UUID},
    )

Check whether or not a user is a collaborator on a repository.
"""
@endpoint is_collaborator(owner::AStr, repo::AStr)
@endpoint is_collaborator(owner::AStr, repo::AStr, name_or_id::NameOrId)

"""
    is_member(::Forge, org::$AStr, name_or_id::Union{$AStr, Integer, UUID})

Check whether or not a user is a member of an organization.
"""
@endpoint is_member(org::AStr, name_or_id::NameOrId)

"""
    groups(::Forge)
Search for groups in GitLab.
"""
@endpoint groups()

"""
    get_tags(::Forge, owner::$AStr, repo::$AStr)
    get_tags(::Forge, project::Integer)

Get a list of tags from a repository.
"""
@endpoint get_tags(owner::AStr, repo::AStr)
@endpoint get_tags(project::Integer)

"""
    list_pull_request_comments(
        ::Forge, owner::$AStr, repo::$AStr, pull_request_id::Integer;
        kwargs...
    )
    list_pull_request_comments(
        ::Forge, project::Integer, pull_request_id::Integer;
        kwargs...
    )

Get a list of comments for a given pull request.
"""
@endpoint list_pull_request_comments(owner::AStr, repo::AStr, pull_request_id::Integer)
@endpoint list_pull_request_comments(project::Integer, pull_request_id::Integer)

"""
    get_pull_request_comment(
        ::Forge, owner::$AStr, repo::$AStr, comment_id::Integer
    )
    get_pull_request_comment(
        ::Forge, project::Integer, pull_request_id::Integer, comment_id::Integer
    )

Get a single comment for a given pull request and comment ID.
"""
@endpoint get_pull_request_comment(owner::AStr, repo::AStr, comment_id::Integer)
@endpoint get_pull_request_comment(
    project::Integer, pull_request_id::Integer, comment_id::Integer
)

"""
    create_pull_request_comment(
        ::Forge, owner::$AStr, repo::$AStr, pull_request_id::Integer;
        kwargs...
    )
    create_pull_request_comment(
        ::Forge, project::Integer, pull_request_id::Integer;
        kwargs...
    )

Create a new comment for a given pull request.
"""
@endpoint create_pull_request_comment(owner::AStr, repo::AStr, pull_request_id::Integer)
@endpoint create_pull_request_comment(project::Integer, pull_request_id::Integer)

"""
    update_pull_request_comment(
        ::Forge, owner::$AStr, repo::$AStr, comment_id::Integer;
        kwargs...
    )
    update_pull_request_comment(
        ::Forge, project::Integer, pull_request_id::Integer, comment_id::Integer;
        kwargs...
    )

Update the body for a given pull request comment.
"""
@endpoint update_pull_request_comment(owner::AStr, repo::AStr, comment_id::Integer)
@endpoint update_pull_request_comment(
    project::Integer, pull_request_id::Integer, comment_id::Integer
)

"""
    delete_pull_request_comment(
        ::Forge, owner::$AStr, repo::$AStr, comment_id::Integer
    )
    delete_pull_request_comment(
        ::Forge, project::Integer, pull_request_id::Integer, comment_id::Integer
    )

Delete a given pull request comment.
"""
@endpoint delete_pull_request_comment(owner::AStr, repo::AStr, comment_id::Integer)
@endpoint delete_pull_request_comment(
    project::Integer, pull_request_id::Integer, comment_id::Integer
)

"""
    list_pipeline_schedules(::Forge, project::Integer; kwargs...)
    list_pipeline_schedules(::Forge, owner::$AStr, repo::$AStr; kwargs...)

List all existing pipeline schedules for a project.
"""
@endpoint list_pipeline_schedules(project::Integer)
@endpoint list_pipeline_schedules(owner::AStr, repo::AStr)

"""
    list_issues(::Forge, project::Integer; kwargs...)

List all issues for a project.
"""
@endpoint list_issues(project::Integer)
