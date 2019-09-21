@json struct Member
    id::Int <- id_of
    username::String <- name_of
    name::String <- title_of
    state::String
    avatar_url::String
    web_url::String <- web_url
    expires_at::DateTime
    access_level::Int
end

# GitLab does not support usernames here.
endpoint(::GitLabAPI, ::typeof(is_member), org::AStr, id::Integer) =
    Endpoint(:GET, "/groups/$(encode(org))/members/$id"; allow_404=true)
postprocessor(::GitLabAPI, ::typeof(is_member)) = DoSomething(ismember)
into(::GitLabAPI, ::typeof(is_member)) = Bool
