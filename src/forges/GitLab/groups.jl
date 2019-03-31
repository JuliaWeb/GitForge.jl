@json struct Member
    id::Int
    username::String
    name::String
    state::String
    avatar_url::String
    web_url::String
    expires_at::DateTime
    access_level::Int
end

GitForge.endpoint(::GitLabAPI, ::typeof(is_member), org::AbstractString, id::Integer) =
    Endpoint(:GET, "/groups/$(HTTP.escapeuri(org))/members/$id"; allow_404=true)
GitForge.postprocessor(::GitLabAPI, ::typeof(is_member)) = DoSomething(ismember)
GitForge.into(::GitLabAPI, ::typeof(is_member)) = Bool
