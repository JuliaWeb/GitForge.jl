@json struct Organization
    id::Int
    name::String
    full_name::String
    email::String
    avatar_url::String
    description::String
    website::String
    location::String
    visibility::String
    repo_admin_change_team_access::Bool
    username::String
end

endpoint(::CodebergAPI, ::typeof(is_member), org::AStr, user::AStr) =
    Endpoint(:GET, "/orgs/$org/members/$user"; allow_404=true)
@not_implemented(::CodebergAPI, ::typeof(is_member), ::String, ::Integer)
postprocessor(::CodebergAPI, ::typeof(is_member)) = DoSomething(ismemberorcollaborator)
into(::CodebergAPI, ::typeof(is_member)) = Bool

@not_implemented(::CodebergAPI, ::typeof(groups))

@not_implemented(::CodebergAPI, ::typeof(list_pull_request_comments), ::String, ::String, ::Integer)
@not_implemented(::CodebergAPI, ::typeof(list_pull_request_comments), ::Integer, ::Integer)

@not_implemented(::CodebergAPI, ::typeof(get_pull_request_comment), ::String, ::String, ::Integer)
@not_implemented(::CodebergAPI, ::typeof(get_pull_request_comment), ::Integer, ::Integer, ::Integer)

@not_implemented(::CodebergAPI, ::typeof(create_pull_request_comment), ::String, ::String, ::Integer)
@not_implemented(::CodebergAPI, ::typeof(create_pull_request_comment), ::Integer, ::Integer)

@not_implemented(::CodebergAPI, ::typeof(update_pull_request_comment), ::String, ::String, ::Integer)
@not_implemented(::CodebergAPI, ::typeof(update_pull_request_comment), ::Integer, ::Integer, ::Integer)

@not_implemented(::CodebergAPI, ::typeof(delete_pull_request_comment), ::String, ::String, ::Integer)
@not_implemented(::CodebergAPI, ::typeof(delete_pull_request_comment), ::Integer, ::Integer, ::Integer)

@not_implemented(::CodebergAPI, ::typeof(list_pipeline_schedules), ::Integer)
@not_implemented(::CodebergAPI, ::typeof(list_pipeline_schedules), ::String, ::String)
