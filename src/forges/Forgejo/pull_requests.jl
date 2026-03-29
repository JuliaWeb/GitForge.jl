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
    requested_reviewers_teams::Vector{NamedTuple}
    state::String
    draft::Bool
    is_locked::Bool
    comments::Int
    review_comments::Int
    additions::Int
    deletions::Int
    changed_files::Int
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
    flow::Int
end

endpoint(::ForgejoAPI, ::typeof(get_pull_requests), owner::AStr, repo::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo/pulls")
@not_implemented(::ForgejoAPI, ::typeof(get_pull_requests), ::Int64)
into(::ForgejoAPI, ::typeof(get_pull_requests)) = Vector{PullRequest}

endpoint(::ForgejoAPI, ::typeof(get_pull_request), owner::AStr, repo::AStr, number::Integer) =
    Endpoint(:GET, "/repos/$owner/$repo/pulls/$number")
@not_implemented(::ForgejoAPI, ::typeof(get_pull_request), ::Int64, ::Int64)
into(::ForgejoAPI, ::typeof(get_pull_request)) = PullRequest

endpoint(::ForgejoAPI, ::typeof(create_pull_request), owner::AStr, repo::AStr) =
    Endpoint(:POST, "/repos/$owner/$repo/pulls")
@not_implemented(::ForgejoAPI, ::typeof(create_pull_request), ::Int64)
into(::ForgejoAPI, ::typeof(create_pull_request)) = PullRequest

endpoint(::ForgejoAPI, ::typeof(update_pull_request), owner::AStr, repo::AStr, number::Integer) =
    Endpoint(:PATCH, "/repos/$owner/$repo/pulls/$number")
@not_implemented(::ForgejoAPI, ::typeof(update_pull_request), ::Int64, ::Int64)
into(::ForgejoAPI, ::typeof(update_pull_request)) = PullRequest

## Pull Request (Issue) Comments

@json struct Attachment
    browser_download_url::String
    created_at::DateTime
    download_count::Int
    id::Int
    name::String
    size::Int
    type => _type::String
    uuid::String
end

@json struct Comment
    assets::Vector{Attachment}
    body::String
    created_at::DateTime
    html_url::String
    id::Int
    issue_url::String
    original_author::String
    original_author_id::Int
    pull_request_url::String
    updated_at::DateTime
    user::User
end

endpoint(::ForgejoAPI, ::typeof(list_pull_request_comments), owner::AStr, repo::AStr, pull_request_id::Integer) =
    Endpoint(:GET, "/repos/$owner/$repo/issues/$pull_request_id/comments")
@not_implemented(::ForgejoAPI, ::typeof(list_pull_request_comments), ::Int64, ::Int64)
into(::ForgejoAPI, ::typeof(list_pull_request_comments)) = Vector{Comment}

endpoint(::ForgejoAPI, ::typeof(get_pull_request_comment), owner::AStr, repo::AStr, comment_id::Integer) =
    Endpoint(:GET, "/repos/$owner/$repo/issues/comments/$comment_id")
@not_implemented(::ForgejoAPI, ::typeof(get_pull_request_comment), ::Int64, ::Int64, ::Int64)
into(::ForgejoAPI, ::typeof(get_pull_request_comment)) = Comment

endpoint(::ForgejoAPI, ::typeof(create_pull_request_comment), owner::AStr, repo::AStr, pull_request_id::Integer) =
    Endpoint(:POST, "/repos/$owner/$repo/issues/$pull_request_id/comments")
@not_implemented(::ForgejoAPI, ::typeof(create_pull_request_comment), ::Int64, ::Int64)
into(::ForgejoAPI, ::typeof(create_pull_request_comment)) = Comment

endpoint(::ForgejoAPI, ::typeof(update_pull_request_comment), owner::AStr, repo::AStr, comment_id::Integer) =
    Endpoint(:PATCH, "/repos/$owner/$repo/issues/comments/$comment_id")
@not_implemented(::ForgejoAPI, ::typeof(update_pull_request_comment), ::Int64, ::Int64, ::Int64)
into(::ForgejoAPI, ::typeof(update_pull_request_comment)) = Comment

endpoint(::ForgejoAPI, ::typeof(delete_pull_request_comment), owner::AStr, repo::AStr, comment_id::Integer) =
    Endpoint(:DELETE, "/repos/$owner/$repo/issues/comments/$comment_id")
@not_implemented(::ForgejoAPI, ::typeof(delete_pull_request_comment), ::Int64, ::Int64, ::Int64)
postprocessor(::ForgejoAPI, ::typeof(delete_pull_request_comment)) = DoNothing()

@not_implemented(::ForgejoAPI, ::typeof(subscribe_to_pull_request), ::Int64, ::Int64)
@not_implemented(::ForgejoAPI, ::typeof(unsubscribe_from_pull_request), ::Int64, ::Int64)
