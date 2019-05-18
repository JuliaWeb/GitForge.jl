@json struct Label
    id::Int
    node_id::String
    url::String
    name::String
    description::String
    color::String
    default::Bool
end

@json struct Milestone
    url::String
    html_url::String
    labels_url::String
    id::Int
    node_id::String
    number::Int
    state::String
    title::String
    description::String
    creator::User
    open_issues::Int
    closed_issues::Int
    created_at::DateTime
    updated_at::DateTime
    closed_at::DateTime
    due_on::DateTime
end

@json struct Team
    id::Int
    node_id::String
    url::String
    name::String
    slug::String
    description::String
    privacy::String
    permission::String
    members_url::String
    repositories_url::String
    parent::Team
end

# TODO: I don't really know what the right name for this is.
@json struct Head
    label::String
    ref::String
    sha::String
    user::User
    repo::Repo
    base::Head
end

@json struct Link
    href::String
end

@json struct Links
    self::Link
    html::Link
    issue::Link
    comments::Link
    review_comments::Link
    review_comment::Link
    commits::Link
    statuses::Link
end

@json struct PullRequest
    url::String
    id::Int
    node_id::String
    html_url::String
    diff_url::String
    patch_url::String
    issue_url::String
    commits_url::String
    review_comments_url::String
    review_comment_url::String
    comments_url::String
    statuses_url::String
    number::Int
    state::String
    locked::Bool
    title::String
    user::User
    body::String
    labels::Vector{Label}
    milestone::Milestone
    active_lock_reason::String
    created_at::DateTime
    updated_at::DateTime
    closed_at::DateTime
    merged_at::DateTime
    merge_commit_sha::String
    assignee::User
    assignees::Vector{User}
    requested_reviewers::Vector{User}
    requested_teams::Vector{Team}
    head::Head
    base::Head
    repo::Repo
    _links => links::Links
    author_association::String
    draft::Bool
    merged::Bool
    mergeable::Bool
    rebaseable::Bool
    mergeable_state::String
    merged_by::User
    comments::Int
    review_comments::Int
    maintainer_can_modify::Bool
    commits::Int
    additions::Int
    deletions::Int
    changed_files::Int
end

endpoint(::GitHubAPI, ::typeof(get_pull_requests), owner::AStr, repo::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo/pulls")
into(::GitHubAPI, ::typeof(get_pull_requests)) = Vector{PullRequest}

endpoint(::GitHubAPI, ::typeof(get_pull_request), owner::AStr, repo::AStr, number::Integer) =
    Endpoint(:GET, "/repos/$owner/$repo/pulls/$number")
into(::GitHubAPI, ::typeof(get_pull_request)) = PullRequest

endpoint(::GitHubAPI, ::typeof(create_pull_request), owner::AStr, repo::AStr) =
    Endpoint(:POST, "/repos/$owner/$repo/pulls")
into(::GitHubAPI, ::typeof(create_pull_request)) = PullRequest

endpoint(::GitHubAPI, ::typeof(update_pull_request), owner::AStr, repo::AStr, number::Integer) =
    Endpoint(:PATCH, "/repos/$owner/$repo/pulls/$number")
into(::GitHubAPI, ::typeof(update_pull_request)) = PullRequest
