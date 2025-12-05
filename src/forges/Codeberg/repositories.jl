@json struct Permission
    admin::Bool
    push::Bool
    pull::Bool
end

@json struct InternalTracker
    enable_time_tracker::Bool
    allow_only_contributors_to_track_time::Bool
    enable_issue_dependencies::Bool
end

@json struct ExternalTracker
    external_tracker_url::String
    external_tracker_format::String
    external_tracker_style::String
    external_tracker_regexp_pattern::String
end

@json struct ExternalWiki
    external_wiki_url::String
end

@json struct Repo
    id::Int
    owner::User
    name::String
    full_name::String
    description::String
    empty::Bool
    private::Bool
    fork::Bool
    template::Bool
    parent::Repo
    mirror::Bool
    size::Int
    language::String
    languages_url::String
    html_url::String
    url::String
    ssh_url::String
    clone_url::String
    original_url::String
    website::String
    stars_count::Int
    forks_count::Int
    watchers_count::Int
    open_issues_count::Int
    open_pr_counter::Int
    release_counter::Int
    default_branch::String
    archived::Bool
    created_at::DateTime
    updated_at::DateTime
    archived_at::DateTime
    permissions::Permission
    has_issues::Bool
    internal_tracker::InternalTracker
    external_tracker::ExternalTracker
    has_wiki::Bool
    external_wiki::ExternalWiki
    has_pull_requests::Bool
    has_projects::Bool
    has_releases::Bool
    has_packages::Bool
    has_actions::Bool
    ignore_whitespace_conflicts::Bool
    allow_merge_commits::Bool
    allow_rebase::Bool
    allow_rebase_explicit::Bool
    allow_squash_merge::Bool
    allow_rebase_update::Bool
    default_delete_branch_after_merge::Bool
    default_merge_style::String
    default_allow_maintainer_edit::Bool
    avatar_url::String
    internal::Bool
    mirror_interval::String
    mirror_updated::DateTime
    repo_transfer::NamedTuple
end

@json struct FileContentsLinks
    self::String
    git::String
    html::String
end

@json struct FileContents
    type::String
    encoding::String
    size::Int
    name::String
    path::String
    content::String
    sha::String
    url::String
    html_url::String
    git_url::String
    download_url::String
    submodule_git_url::String
    _links => links::FileContentsLinks
end

endpoint(::CodebergAPI, ::typeof(get_user_repos)) = Endpoint(:GET, "/user/repos")
endpoint(::CodebergAPI, ::typeof(get_user_repos), name::AStr) = Endpoint(:GET, "/users/$name/repos")
@not_implemented(::CodebergAPI, ::typeof(get_user_repos), ::Integer)
into(::CodebergAPI, ::typeof(get_user_repos)) = Vector{Repo}

endpoint(::CodebergAPI, ::typeof(get_repo), owner::AStr, repo::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo")
@not_implemented(::CodebergAPI, ::typeof(get_repo), ::String)
@not_implemented(::CodebergAPI, ::typeof(get_repo), ::Integer)
@not_implemented(::CodebergAPI, ::typeof(get_repo), ::String, ::String, ::String)
into(::CodebergAPI, ::typeof(get_repo)) = Repo

endpoint(::CodebergAPI, ::typeof(create_repo)) = Endpoint(:POST, "/user/repos")
endpoint(::CodebergAPI, ::typeof(create_repo), org::AStr) = Endpoint(:POST, "/orgs/$org/repos")
@not_implemented(::CodebergAPI, ::typeof(create_repo), ::Integer)
@not_implemented(::CodebergAPI, ::typeof(create_repo), ::String, ::String)
into(::CodebergAPI, ::typeof(create_repo)) = Repo

endpoint(::CodebergAPI, ::typeof(is_collaborator), owner::AStr, repo::AStr, user::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo/collaborators/$user"; allow_404=true)
@not_implemented(::CodebergAPI, ::typeof(is_collaborator), ::String, ::String, ::Integer)
postprocessor(::CodebergAPI, ::typeof(is_collaborator)) = DoSomething(ismemberorcollaborator)
into(::CodebergAPI, ::typeof(is_collaborator)) = Bool

endpoint(::CodebergAPI, ::typeof(get_file_contents), owner::AStr, repo::AStr, path::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo/contents/$path")
@not_implemented(::CodebergAPI, ::typeof(get_file_contents), ::Integer, ::String)
into(::CodebergAPI, ::typeof(get_file_contents)) = FileContents
