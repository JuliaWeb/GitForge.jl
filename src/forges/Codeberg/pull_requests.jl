@json struct Label
    id::Int
    name::String
    exclusive::Bool
    is_archived::Bool
    color::String
    description::String
    url::String
end

@json struct Milestone
    id::Int
    title::String
    description::String
    state::String
    open_issues::Int
    closed_issues::Int
    created_at::DateTime
    updated_at::DateTime
    closed_at::DateTime
    due_on::DateTime
end

@json struct PRBranchInfo
    label::String
    ref::String
    sha::String
    repo_id::Int
    repo::Repo
end

@json struct PullRequest
    id::Int
    url::String
    number::Int
    user::User
    title::String
    body::String
    labels::Vector{Label}
    milestone::Milestone
    assignee::User
    assignees::Vector{User}
    requested_reviewers::Vector{User}
    state::String
    is_locked::Bool
    comments::Int
    html_url::String
    diff_url::String
    patch_url::String
    mergeable::Bool
    merged::Bool
    merged_at::DateTime
    merge_commit_sha::String
    merged_by::User
    allow_maintainer_edit::Bool
    base::PRBranchInfo
    head::PRBranchInfo
    merge_base::String
    due_date::DateTime
    created_at::DateTime
    updated_at::DateTime
    closed_at::DateTime
    pin_order::Int
end

endpoint(::CodebergAPI, ::typeof(get_pull_requests), owner::AStr, repo::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo/pulls")
@not_implemented(::CodebergAPI, ::typeof(get_pull_requests), ::Integer)
into(::CodebergAPI, ::typeof(get_pull_requests)) = Vector{PullRequest}

endpoint(::CodebergAPI, ::typeof(get_pull_request), owner::AStr, repo::AStr, number::Integer) =
    Endpoint(:GET, "/repos/$owner/$repo/pulls/$number")
@not_implemented(::CodebergAPI, ::typeof(get_pull_request), ::Integer, ::Integer)
into(::CodebergAPI, ::typeof(get_pull_request)) = PullRequest

endpoint(::CodebergAPI, ::typeof(create_pull_request), owner::AStr, repo::AStr) =
    Endpoint(:POST, "/repos/$owner/$repo/pulls")
@not_implemented(::CodebergAPI, ::typeof(create_pull_request), ::Integer)
into(::CodebergAPI, ::typeof(create_pull_request)) = PullRequest

endpoint(::CodebergAPI, ::typeof(update_pull_request), owner::AStr, repo::AStr, number::Integer) =
    Endpoint(:PATCH, "/repos/$owner/$repo/pulls/$number")
@not_implemented(::CodebergAPI, ::typeof(update_pull_request), ::Integer, ::Integer)
into(::CodebergAPI, ::typeof(update_pull_request)) = PullRequest

@not_implemented(::CodebergAPI, ::typeof(subscribe_to_pull_request), ::Integer, ::Integer)
@not_implemented(::CodebergAPI, ::typeof(unsubscribe_from_pull_request), ::Integer, ::Integer)
