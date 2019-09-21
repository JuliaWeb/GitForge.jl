@json struct Identity
    provider::String
    extern_uid::String
end

@json struct User
    id::Int
    username::String
    email::String
    name::String
    state::String
    avatar_url::String
    web_url::String
    created_at::DateTime
    is_admin::Bool
    bio::String
    location::String
    public_email::String
    skype::String
    linkedin::String
    twitter::String
    website_url::String
    organization::String
    last_sign_in_at::DateTime
    confirmed_at::DateTime
    theme_id::Int
    last_activity_on::Date
    color_scheme_id::Int
    projects_limit::Int
    current_sign_in_at::DateTime
    identities::Vector{Identity}
    can_create_group::Bool
    can_create_project::Bool
    two_factor_enabled::Bool
    external::Bool
    private_profile::Bool
    # Undocumented
    shared_runners_minutes_limit::Int
end

endpoint(::GitLabAPI, ::typeof(get_user)) = Endpoint(:GET, "/user")
endpoint(::GitLabAPI, ::typeof(get_user), name::AStr) =
    Endpoint(:GET, "/users"; query=Dict(:username => name))
postprocessor(f::GitLabAPI, ::typeof(get_user)) = DoSomething() do r
    val = JSON2.read(IOBuffer(r.body), Union{User, Vector{User}})
    return if val isa User
        val
    else
        isempty(val) && throw(HTTPError(HTTP.StatusError(404, r), stacktrace()))
        u = first(val)
        try internal_get_user(f, u.id) catch; u end
    end
end
into(::GitLabAPI, ::typeof(get_user)) = User

endpoint(::GitLabAPI, ::typeof(get_users)) = Endpoint(:GET, "/users")
into(::GitLabAPI, ::typeof(get_users)) = Vector{User}

internal_get_user(f::GitLabAPI, id::Integer) =
    request(f, get_user, Endpoint(:GET, "/users/$id"))
