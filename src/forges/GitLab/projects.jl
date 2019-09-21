@json struct Namespace
    id::Int <- id_of
    name::String
    path::String
    kind::String
    full_path::String <- name_of
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
    key::String <- id_of
    name::String <- name_of
    nickname::String
    html_url::String <- web_url
    source_url::String
end

@json struct Group
    group_id::Int <- id_of
    group_name::String
    group_full_path::String <- name_of
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
    id::Int <- id_of
    description::String <- description_of
    default_branch::String
    visibility::String
    ssh_url_to_repo::String
    http_url_to_repo::String <- clone_url
    web_url::String <- web_url
    readme_url::String
    tag_list::Vector{String}
    owner::User <- owner_of
    name::String <- title_of
    name_with_namespace::String
    path::String <- name_of
    path_with_namespace::String
    issues_enabled::Bool
    open_issues_count::Int
    merge_requests_enabled::Bool
    jobs_enabled::Bool
    wiki_enabled::Bool
    snippets_enabled::Bool
    resolve_outdated_diff_discussions::Bool
    container_registry_enabled::Bool
    created_at::DateTime <- created_at
    last_activity_at::DateTime <- updated_at
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

is_private(p::Project) = p.visibility == "private"
is_owned_by_organization(p::Project) = p.namespace.kind == "group"

@json struct FileContents
    file_name::String <- name_of
    file_path::String
    size::Int
    encoding::String
    content::String
    content_sha256::String <- sha_of
    ref::String
    blob_id::String
    commit_id::String
    last_commit_id::String
end

endpoint(::GitLabAPI, ::typeof(get_user_repos)) =
    Endpoint(:GET, "/projects"; query=Dict("membership" => true))
endpoint(::GitLabAPI, ::typeof(get_user_repos), name::AStr) =
    Endpoint(:GET, "/users/$name/projects")
into(::GitLabAPI, ::typeof(get_user_repos)) = Vector{Project}

endpoint(::GitLabAPI, ::typeof(get_repo), owner::AStr, repo::AStr) =
    Endpoint(:GET, "/projects/$(encode(owner, repo))")
into(::GitLabAPI, ::typeof(get_repo)) = Project

# GitLab does not support usernames here.
endpoint(::GitLabAPI, ::typeof(is_collaborator), owner::AStr, repo::AStr, id::Integer) =
    Endpoint(:GET, "/projects/$(encode(owner, repo))/members/$id"; allow_404=true)
postprocessor(::GitLabAPI, ::typeof(is_collaborator)) = DoSomething(ismember)
into(::GitLabAPI, ::typeof(is_collaborator)) = Bool

endpoint(::GitLabAPI, ::typeof(get_file_contents), owner::AStr, repo::AStr, path::AStr) =
    Endpoint(:GET, "/projects/$(encode(owner, repo))/repository/files/$(encode(path))";
             query=Dict(:ref => "master"))
into(::GitLabAPI, ::typeof(get_file_contents)) = FileContents
