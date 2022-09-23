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

@json struct Group
    id::Int
    name::String
    path::String
    description::String
end

endpoint(::GitLabAPI, ::typeof(is_member), org::AStr, id::Integer) =
    Endpoint(:GET, "/groups/$(encode(org))/members/$id"; allow_404=true)
@not_implemented(api::GitLabAPI, ::typeof(is_member), org::AStr, user::AStr)
postprocessor(::GitLabAPI, ::typeof(is_member)) = DoSomething(ismember)
into(::GitLabAPI, ::typeof(is_member)) = Bool

endpoint(::GitLabAPI, ::typeof(groups)) = Endpoint(:GET, "/groups")
into(::GitLabAPI, ::typeof(groups)) = Vector{Group}
