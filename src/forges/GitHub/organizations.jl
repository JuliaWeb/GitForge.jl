endpoint(::GitHubAPI, ::typeof(is_member), org::AStr, user::AStr) =
    Endpoint(:GET, "/orgs/$org/members/$user"; allow_404=true)
@not_implemented(::GitHubAPI, ::typeof(is_member), ::String, ::Int64)
postprocessor(::GitHubAPI, ::typeof(is_member)) = DoSomething(ismemberorcollaborator)
into(::GitHubAPI, ::typeof(is_member)) = Bool

@not_implemented(::GitHubAPI, ::typeof(groups), )
