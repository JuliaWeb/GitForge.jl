endpoint(::GitHubAPI, ::typeof(is_member), org::AStr, user::AStr) =
    Endpoint(:GET, "/orgs/$org/members/$user"; allow_404=true)
postprocessor(::GitHubAPI, ::typeof(is_member)) = DoSomething(ismemberorcollaborator)
into(::GitHubAPI, ::typeof(is_member)) = Bool
