# TODO: GET /orgs/:org/repos is somewhat conflicting.

@json struct Permissions
    admin::Bool
    push::Bool
    pull::Bool
end

@json struct License
    key::String
    name::String
    spdx_id::String
    url::String
    node_id::String
end

@json struct Repo
    id::Int
    node_id::String
    name::String
    full_name::String
    owner::User
    private::Bool
    html_url::String
    description::String
    fork::Bool
    url::String
    archive_url::String
    assignees_url::String
    blobs_url::String
    branches_url::String
    collaborators_url::String
    comments_url::String
    commits_url::String
    compare_url::String
    contents_url::String
    contributors_url::String
    deployments_url::String
    downloads_url::String
    events_url::String
    forks_url::String
    git_commits_url::String
    git_refs_url::String
    git_tags_url::String
    git_url::String
    issue_comment_url::String
    issue_events_url::String
    issues_url::String
    keys_url::String
    labels_url::String
    languages_url::String
    merges_url::String
    milestones_url::String
    notifications_url::String
    pulls_url::String
    releases_url::String
    ssh_url::String
    stargazers_url::String
    statuses_url::String
    subscribers_url::String
    subscription_url::String
    tags_url::String
    teams_url::String
    trees_url::String
    clone_url::String
    mirror_url::String
    hooks_url::String
    svn_url::String
    homepage::String
    language::String
    forks_count::Int
    stargazers_count::Int
    watchers_count::Int
    size::Int
    default_branch::String
    open_issues_count::Int
    topics::Vector{String}
    has_issues::Bool
    has_projects::Bool
    has_wiki::Bool
    has_pages::Bool
    has_downloads::Bool
    archived::Bool
    pushed_at::DateTime
    created_at::DateTime
    updated_at::DateTime
    permissions::Permissions
    allow_rebase_merge::Bool
    allow_squash_merge::Bool
    allow_merge_commit::Bool
    subscribers_count::Int
    network_count::Int
    license::License
    organization::User
    parent::Repo
    source::Repo
end

@json struct FileContentsLinks
    self::String
    git::String
    html::String
end

@json struct FileContents
    _type::String
    encoding::String
    size::Int
    name::String
    path::String
    content::String
    sha::String
    url::String
    git_url::String
    html_url::String
    download_url::String
    _links => links::FileContentsLinks
end

endpoint(::GitHubAPI, ::typeof(get_user_repos)) = Endpoint(:GET, "/user/repos")
endpoint(::GitHubAPI, ::typeof(get_user_repos), id::Integer) =
    Endpoint(:GET, "/users/$id/projects")
@not_implemented(::GitHubAPI, ::typeof(get_user_repos), ::String)
into(::GitHubAPI, ::typeof(get_user_repos)) = Vector{Repo}

endpoint(::GitHubAPI, ::typeof(get_repo), owner_repo::AStr) =
    Endpoint(:GET, "/repos/$owner_repo")
endpoint(::GitHubAPI, ::typeof(get_repo), owner::AStr, repo::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo")
@not_implemented(::GitHubAPI, ::typeof(get_repo), ::String, ::String, ::String)
into(::GitHubAPI, ::typeof(get_repo)) = Repo

endpoint(::GitHubAPI, ::typeof(create_repo)) =
    Endpoint(:POST, "/user/repos")
endpoint(::GitHubAPI, ::typeof(create_repo), org::AStr) =
    Endpoint(:POST, "/orgs/$org/repos")
@not_implemented(::GitHubAPI, ::typeof(create_repo), ::Int64)
@not_implemented(api::GitHubAPI, ::typeof(create_repo), namespace::AStr, repo::AStr)
into(::GitHubAPI, ::typeof(create_repo)) = Repo

endpoint(::GitHubAPI, ::typeof(is_collaborator), owner::AStr, repo::AStr, user::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo/collaborators/$user"; allow_404=true)
@not_implemented(::GitHubAPI, ::typeof(is_collaborator), ::String, ::String, ::Int64)
postprocessor(::GitHubAPI, ::typeof(is_collaborator)) = DoSomething(ismemberorcollaborator)
into(::GitHubAPI, ::typeof(is_collaborator)) = Bool

endpoint(::GitHubAPI, ::typeof(get_file_contents), owner::AStr, repo::AStr, path::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo/contents/$path")
@not_implemented(::GitHubAPI, ::typeof(get_file_contents), ::Int64, ::String)
into(::GitHubAPI, ::typeof(get_file_contents)) = FileContents
