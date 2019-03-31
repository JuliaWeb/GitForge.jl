GitForge.endpoint(
    ::GitHubAPI, ::typeof(is_member),
    org::AbstractString, user::AbstractString,
) = Endpoint(:GET, "/orgs/$org/members/$user"; allow_404=true)
GitForge.postprocessor(::GitHubAPI, ::typeof(is_member)) =
    DoSomething(ismemberorcollaborator)
GitForge.into(::GitHubAPI, ::typeof(is_member)) = Bool
