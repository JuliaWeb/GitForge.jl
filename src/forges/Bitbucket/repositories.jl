@json struct Project
    key::String
    links::NamedTuple
    name::String
    uuid::UUID
end

@json struct Branch
    name::String
end

@json struct Workspace
    links::NamedTuple
    name::String
    slug::String
    uuid::UUID
end

@json struct Repo
    created_on::DateTime
    description::String
    fork_policy::String
    full_name::String
    has_issues::Bool
    has_wiki::Bool
    is_private::Bool
    language::String
    links::NamedTuple
    mainbranch::Branch
    name::String
    owner::User
    project::Project
    size::Int
    slug::String
    updated_on::DateTime
    uuid::UUID
    website::String
    workspace::Workspace
end

@not_implemented(::BitbucketAPI, ::typeof(get_user_repos))
@not_implemented(::BitbucketAPI, ::typeof(get_user_repos), ::String)
@not_implemented(::BitbucketAPI, ::typeof(get_user_repos), ::UUID)
into(::BitbucketAPI, ::typeof(get_user_repos)) = Vector{Repo}

endpoint(api::BitbucketAPI, ::typeof(get_repo), workspace::AStr, repo::AStr) = 
    Endpoint(:GET, "/repositories/$workspace/$repo")
@not_implemented(::BitbucketAPI, ::typeof(get_repo), ::String, ::String, ::String)
into(::BitbucketAPI, ::typeof(get_repo)) = Repo
@not_implemented(::BitbucketAPI, ::typeof(get_repo), ::String)

endpoint(::BitbucketAPI, ::typeof(create_repo), workspace::AStr, repo::AStr) =
    Endpoint(:POST, "/repositories/$workspace/$repo")
@not_implemented(::BitbucketAPI, ::typeof(create_repo), org::AStr)
@not_implemented(::BitbucketAPI, ::typeof(create_repo), ::UUID)
@not_implemented(::BitbucketAPI, ::typeof(create_repo),)
into(::BitbucketAPI, ::typeof(create_repo)) = Repo

function is_bitbucket_collaborator(resp::HTTP.Response)
    if HTTP.status(resp) == 200
        d = JSON3.read(String(HTTP.body(resp)), Dict)
        return haskey(d, "values") && length(d["values"]) > 0 &&
            d["values"][1]["permissions"] in ["write" "admin"]
    end
    false
end

endpoint(::BitbucketAPI, ::typeof(is_collaborator), wrksp::AStr, repo::AStr) =
    Endpoint(:GET, "/user/permissions/repositories";
             allow_404=true,
             query=Dict(
                 :q=> "repository.full_name=\"$wrksp/$repo\""
             ),
             )
endpoint(::BitbucketAPI, ::typeof(is_collaborator), wrksp::AStr, repo::AStr, user::AStr) =
    Endpoint(:GET, "/workspaces/$wrksp/permissions/repositories/$repo";
             allow_404=true,
             query=Dict(
                 :q=> "user.nickname=\"$user\""
             )
             )
endpoint(::BitbucketAPI, ::typeof(is_collaborator), wrksp::String, repo::String, user::UUID) =
    Endpoint(:GET, "/workspaces/$wrksp/permissions/repositories/$repo";
             allow_404=true,
             query=Dict(
                 :q=> "user.uuid=\"{$user}\""
             )
             )
postprocessor(::BitbucketAPI, ::typeof(is_collaborator)) = DoSomething(is_bitbucket_collaborator)
into(::BitbucketAPI, ::typeof(is_collaborator)) = Bool

endpoint(api::BitbucketAPI, ::typeof(get_file_contents), wrksp::AStr, repo::AStr, path::AStr) =
    Endpoint(:GET, "/repositories/$wrksp/$repo/src/$path")
@not_implemented(::BitbucketAPI, ::typeof(get_file_contents), repo::UUID, path::AStr)
postprocessor(::BitbucketAPI, ::typeof(get_file_contents)) = DoSomething() do req
    String(req.body)
end
into(::BitbucketAPI, ::typeof(get_file_contents)) = String

@not_implemented(::BitbucketAPI, ::typeof(list_pull_request_comments), ::String, ::String, ::UUID)
@not_implemented(::BitbucketAPI, ::typeof(list_pull_request_comments), ::UUID, ::UUID)

@not_implemented(::BitbucketAPI, ::typeof(get_pull_request_comment), ::String, ::String, ::UUID)
@not_implemented(::BitbucketAPI, ::typeof(get_pull_request_comment), ::UUID, ::UUID, ::UUID)

@not_implemented(::BitbucketAPI, ::typeof(create_pull_request_comment), ::String, ::String, ::UUID)
@not_implemented(::BitbucketAPI, ::typeof(create_pull_request_comment), ::UUID, ::UUID)

@not_implemented(::BitbucketAPI, ::typeof(update_pull_request_comment), ::String, ::String, ::UUID)
@not_implemented(::BitbucketAPI, ::typeof(update_pull_request_comment), ::UUID, ::UUID, ::UUID)

@not_implemented(::BitbucketAPI, ::typeof(delete_pull_request_comment), ::String, ::String, ::UUID)
@not_implemented(::BitbucketAPI, ::typeof(delete_pull_request_comment), ::UUID, ::UUID, ::UUID)

@not_implemented(::BitbucketAPI, ::typeof(list_pipeline_schedules), ::UUID)
@not_implemented(::BitbucketAPI, ::typeof(list_pipeline_schedules), ::String, ::String)
