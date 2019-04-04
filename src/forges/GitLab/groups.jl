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

endpoint(::GitLabAPI, ::typeof(is_member), org::AStr, id::Integer) =
    Endpoint(:GET, "/groups/$(encode(org))/members/$id"; allow_404=true)
postprocessor(::GitLabAPI, ::typeof(is_member)) = DoSomething(ismember)
into(::GitLabAPI, ::typeof(is_member)) = Bool
