@json struct Namespace
    id::Int
    name::String
    path::String
    kind::String
    full_path::String
end

@json struct Access
    access_level::Int
    notification_level::Int
end

@json struct Permissions
    project_access::Access
    group_access::Access
end

@json struct License
    key::String
    name::String
    nickname::String
    html_url::String
    source_url::String
end

@json struct Group
    group_id::Int
    group_name::String
    group_full_path::String
    group_access_level::Int
end

@json struct Statistics
    commit_count::Int
    storage_size::Int
    repository_size::Int
    lfs_objects_size::Int
    job_artifacts_size::Int
end

@json struct Links
    self::String
    issues::String
    merge_requests::String
    repo_branches::String
    labels::String
    events::String
    members::String
end

@json struct Project
    id::Int
    description::String
    default_branch::String
    visibility::String
    ssh_url_to_repo::String
    http_url_to_repo::String
    web_url::String
    readme_url::String
    tag_list::Vector{String}
    owner::User
    name::String
    name_with_namespace::String
    path::String
    path_with_namespace::String
    issues_enabled::Bool
    open_issues_count::Int
    merge_requests_enabled::Bool
    jobs_enabled::Bool
    wiki_enabled::Bool
    snippets_enabled::Bool
    resolve_outdated_diff_discussions::Bool
    container_registry_enabled::Bool
    created_at::DateTime
    last_activity_at::DateTime
    creator_id::Int
    namespace::Namespace
    import_status::String
    import_error::String
    permissions::Permissions
    archived::Bool
    avatar_url::String
    license_url::String
    license::License
    shared_runners_enabled::Bool
    forks_count::Int
    star_count::Int
    runners_token::String
    public_jobs::Bool
    shared_with_groups::Vector{Group}
    only_allow_merge_if_pipeline_succeeds::Bool
    only_allow_merge_if_all_discussions_are_resolved::Bool
    printing_merge_requests_link_enabled::Bool
    request_access_enabled::Bool
    merge_method::String
    statistics::Statistics
    _links => links::Links
end

@json struct FileContents
    file_name::String
    file_path::String
    size::Int
    encoding::String
    content::String
    content_sha256::String
    ref::String
    blob_id::String
    commit_id::String
    last_commit_id::String
end

endpoint(::GitLabAPI, ::typeof(get_user_repos)) =
    Endpoint(:GET, "/projects"; query=Dict("membership" => true))
endpoint(::GitLabAPI, ::typeof(get_user_repos), name::AStr) =
    Endpoint(:GET, "/users/$name/repos")
into(::GitLabAPI, ::typeof(get_user_repos)) = Vector{Project}

endpoint(::GitLabAPI, ::typeof(get_repo), owner::AStr, repo::AStr) =
    Endpoint(:GET, "/projects/$(encode(owner, repo))")
into(::GitLabAPI, ::typeof(get_repo)) = Project

endpoint(::GitLabAPI, ::typeof(is_collaborator), owner::AStr, repo::AStr, id::Integer) =
    Endpoint(:GET, "/projects/$(encode(owner, repo))/members/$id"; allow_404=true)
postprocessor(::GitLabAPI, ::typeof(is_collaborator)) = DoSomething(ismember)
into(::GitLabAPI, ::typeof(is_collaborator)) = Bool

endpoint(::GitLabAPI, ::typeof(get_file_contents), id::Integer, path::AStr) =
    Endpoint(:GET, "/projects/$id/repository/files/$path"; query=Dict(:ref => "master"))
into(::GitLabAPI, ::typeof(get_file_contents)) = FileContents
