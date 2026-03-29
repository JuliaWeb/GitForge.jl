endpoint(::ForgejoAPI, ::typeof(is_member), org::AStr, user::AStr) =
    Endpoint(:GET, "/orgs/$org/members/$user"; allow_404=true)
@not_implemented(::ForgejoAPI, ::typeof(is_member), ::String, ::Int64)
postprocessor(::ForgejoAPI, ::typeof(is_member)) = DoSomething(ismemberorcollaborator)
into(::ForgejoAPI, ::typeof(is_member)) = Bool

@not_implemented(::ForgejoAPI, ::typeof(groups))
into(::ForgejoAPI, ::typeof(groups)) = Vector{Any}
