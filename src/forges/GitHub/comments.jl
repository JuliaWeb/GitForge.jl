@json struct Comment
    url::String
    pull_request_review_id::Int
    id::Int
    node_id::String
    diff_hunk::String
    path::String
    position::Int
    original_position::Int
    commit_id::String
    original_commit_id::String
    in_reply_to_id::Int
    user::User
    body::String
    created_at::DateTime
    updated_at::DateTime
    html_url::String
    pull_request_url::String
    author_association::String
    _links => links::Links
    start_line::Int
    original_start_line::Int
    start_side::String
    line::Int
    original_line::Int
    side::String
end

## Pull Request (Issue) Comments

# List All Pull Request (Issue) Comments
# https://docs.github.com/en/rest/reference/issues#list-issue-comments
function endpoint(
    ::GitHubAPI,
    ::typeof(list_pull_request_comments),
    owner::AStr,
    repo::AStr,
    pull_request_id::Integer,
)
    return Endpoint(:GET, "/repos/$owner/$repo/issues/$pull_request_id/comments")
end
@not_implemented(::GitHubAPI, ::typeof(list_pull_request_comments), ::Int64, ::Int64)
into(::GitHubAPI, ::typeof(list_pull_request_comments)) = Vector{Comment}

# Get Single Pull Request (Issue) Comment
# https://docs.github.com/en/rest/reference/issues#get-an-issue-comment
function endpoint(
    ::GitHubAPI,
    ::typeof(get_pull_request_comment),
    owner::AStr,
    repo::AStr,
    comment_id::Integer,
)
    return Endpoint(
        :GET, "/repos/$owner/$repo/issues/comments/$comment_id")
end
@not_implemented(::GitHubAPI, ::typeof(get_pull_request_comment), ::Int64, ::Int64, ::Int64)
info(::GitHubAPI, ::typeof(get_pull_request_comment)) = Comment

# Create Pull Request (Issue) Comment
# https://docs.github.com/en/rest/reference/issues#create-an-issue-comment
function endpoint(
    ::GitHubAPI,
    ::typeof(create_pull_request_comment),
    owner::AStr,
    repo::AStr,
    pull_request_id::Integer,
)
    return Endpoint(:POST, "/repos/$owner/$repo/issues/$pull_request_id/comments")
end
@not_implemented(::GitHubAPI, ::typeof(create_pull_request_comment), ::Int64, ::Int64)
into(::GitHubAPI, ::typeof(create_pull_request_comment)) = Comment

# Update Pull Request (Issue) Comment
# https://docs.github.com/en/rest/reference/issues#update-an-issue-comment
function endpoint(
    ::GitHubAPI,
    ::typeof(update_pull_request_comment),
    owner::AStr,
    repo::AStr,
    comment_id::Integer,
)
    return Endpoint(:PATCH, "/repos/$owner/$repo/issues/comments/$comment_id")
end
@not_implemented(::GitHubAPI, ::typeof(update_pull_request_comment), ::Int64, ::Int64, ::Int64)
into(::GitHubAPI, ::typeof(update_pull_request_comment)) = Comment

# Delete Pull Request (Issue) Comment
# https://docs.github.com/en/rest/reference/issues#delete-an-issue-comment
function endpoint(
    ::GitHubAPI,
    ::typeof(delete_pull_request_comment),
    owner::AStr,
    repo::AStr,
    comment_id::Integer,
)
    return Endpoint(:DELETE, "/repos/$owner/$repo/issues/comments/$comment_id")
end
@not_implemented(
    ::GitHubAPI, ::typeof(delete_pull_request_comment),
    project::Integer, pull_request_id::Integer, comment_id::Integer
)
into(::GitHubAPI, ::typeof(delete_pull_request_comment)) = Comment
