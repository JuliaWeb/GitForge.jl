@json struct Permissions
    admin::Bool
    push::Bool
    pull::Bool
end

@json struct FileContentsLinks
    self::String
    git::String
    html::String
end

@json struct FileContents
    name::String
    path::String
    sha::String
    last_commit_sha::String
    last_commit_when::DateTime
    type => _type::String
    size::Int
    encoding::String
    content::String
    target::String
    url::String
    html_url::String
    git_url::String
    download_url::String
    submodule_git_url::String
    _links => links::FileContentsLinks
end

@json struct Repo
    id::Int
    owner::User
    name::String
    full_name::String
    description::String
    private::Bool
    html_url::String
    url::String
    ssh_url::String
    clone_url::String
    website::String
    stars_count::Int
    forks_count::Int
    watchers_count::Int
    open_issues_count::Int
    open_pr_counter::Int
    default_branch::String
    archived::Bool
    created_at::DateTime
    updated_at::DateTime
    permissions::Permissions
end

endpoint(::ForgejoAPI, ::typeof(get_user_repos)) = Endpoint(:GET, "/user/repos")
endpoint(::ForgejoAPI, ::typeof(get_user_repos), name::AStr) =
    Endpoint(:GET, "/users/$name/repos")
@not_implemented(::ForgejoAPI, ::typeof(get_user_repos), ::Int64)
into(::ForgejoAPI, ::typeof(get_user_repos)) = Vector{Repo}

endpoint(::ForgejoAPI, ::typeof(get_repo), owner_repo::AStr) =
    Endpoint(:GET, "/repos/$owner_repo")
endpoint(::ForgejoAPI, ::typeof(get_repo), owner::AStr, repo::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo")
@not_implemented(::ForgejoAPI, ::typeof(get_repo), ::Int64)
@not_implemented(::ForgejoAPI, ::typeof(get_repo), ::String, ::String, ::String)
into(::ForgejoAPI, ::typeof(get_repo)) = Repo

endpoint(::ForgejoAPI, ::typeof(create_repo)) = Endpoint(:POST, "/user/repos")
endpoint(::ForgejoAPI, ::typeof(create_repo), org::AStr) =
    Endpoint(:POST, "/orgs/$org/repos")
@not_implemented(::ForgejoAPI, ::typeof(create_repo), ::Int64)
@not_implemented(::ForgejoAPI, ::typeof(create_repo), ::String, ::String)
into(::ForgejoAPI, ::typeof(create_repo)) = Repo

endpoint(::ForgejoAPI, ::typeof(is_collaborator), owner::AStr, repo::AStr, user::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo/collaborators/$user"; allow_404=true)
@not_implemented(::ForgejoAPI, ::typeof(is_collaborator), ::String, ::String, ::Int64)
postprocessor(::ForgejoAPI, ::typeof(is_collaborator)) = DoSomething(ismemberorcollaborator)
into(::ForgejoAPI, ::typeof(is_collaborator)) = Bool

endpoint(::ForgejoAPI, ::typeof(get_file_contents), owner::AStr, repo::AStr, path::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo/contents/$(HTTP.escapeuri(path))")
@not_implemented(::ForgejoAPI, ::typeof(get_file_contents), ::Int64, ::String)
into(::ForgejoAPI, ::typeof(get_file_contents)) = FileContents

@not_implemented(::ForgejoAPI, ::typeof(list_pipeline_schedules), ::Int64)
@not_implemented(::ForgejoAPI, ::typeof(list_pipeline_schedules), ::String, ::String)
