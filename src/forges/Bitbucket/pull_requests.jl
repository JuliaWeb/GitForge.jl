@json struct PullRequestBranch
    default_merge_strategy::String
    merge_strategies::Vector{String}
    name::String
end

@json struct PullRequestCommit
    hash::String
end

@json struct PullRequestEndpoint
    branch::Branch
    commit::PullRequestCommit
    repository::Repo
end

"""
    RenderedPullRequestMarkup

title, description, and reason are Dicts like:
Dict("raw"=> "<string>", "markup"=> "<string>", "html"=> "<string>")
"""
@json struct RenderedPullRequestMarkup
    description::Dict{String, Any}
    reason::Dict{String, Any}
    title::Dict{String, Any}
end

@json struct PullRequest
    author::User
    close_source_branch::Bool
    closed_by::Union{User, Nothing}
    comment_count::Int
    created_on::DateTime
    description::String
    destination::PullRequestEndpoint
    id::Int
    links::NamedTuple
    merge_commit::PullRequestCommit
    participants::Vector{User}
    reason::String
    rendered::RenderedPullRequestMarkup
    reviewers::Vector{User}
    source::PullRequestEndpoint
    state::String
    summary::Dict{String, Any}
    task_count::Int
    title::String
    updated_on::DateTime
end

@not_implemented(::BitbucketAPI, ::typeof(get_pull_request), ::String, ::String, ::UUID)
@not_implemented(::BitbucketAPI, ::typeof(get_pull_request), ::UUID, ::UUID)

endpoint(::BitbucketAPI, ::typeof(get_pull_requests), workspace::String, repo::String) =
    Endpoint(:GET, "/repositories/$workspace/$repo/pullrequests")
@not_implemented(::BitbucketAPI, ::typeof(get_pull_requests), ::UUID)
into(::BitbucketAPI, ::typeof(get_pull_requests)) = PullRequest

endpoint(::BitbucketAPI, ::typeof(create_pull_request), workspace::String, repo::String) =
    Endpoint(:POST, "/repositories/$workspace/$repo/pullrequests")
@not_implemented(::BitbucketAPI, ::typeof(create_pull_request), ::UUID)
into(::BitbucketAPI, ::typeof(create_pull_request)) = PullRequest

endpoint(::BitbucketAPI, ::typeof(update_pull_request), workspace::String, repo::String, id::Int64) =
    Endpoint(:PUT, "/repositories/$workspace/$repo/pullrequests/$id")
@not_implemented(::BitbucketAPI, ::typeof(update_pull_request), ::UUID, ::Int64)
into(::BitbucketAPI, ::typeof(update_pull_request)) = PullRequest

@not_implemented(::BitbucketAPI, ::typeof(subscribe_to_pull_request), ::UUID, ::UUID)

@not_implemented(::BitbucketAPI, ::typeof(unsubscribe_from_pull_request), ::UUID, ::UUID)
