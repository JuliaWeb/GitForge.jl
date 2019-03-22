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
    # Same as Github.User.
    # created_at::DateTime
    is_admin::Bool
    bio::String
    location::String
    public_email::String
    linkedin::String
    twitter::String
    website_url::String
    organization::String
    # last_sign_in_at::DateTime
    # confirmed_at::DateTime
    theme_id::Int
    # last_activity_on::DateTime
    color_scheme_id::Int
    projects_limit::Int
    # current_sign_in_at::DateTime
    identities::Vector{Identity}
    can_create_group::Bool
    can_create_project::Bool
    two_factor_enabled::Bool
    external::Bool
    private_profile::Bool
end

GitForge.endpoint(::GitLabAPI, ::typeof(get_user)) = "/user"
GitForge.endpoint(::GitLabAPI, ::typeof(get_user), id::Integer) = "/users/$id"
GitForge.into(::GitLabAPI, ::typeof(get_user)) = User

GitForge.endpoint(::GitLabAPI, ::typeof(get_users)) = "/users"
GitForge.into(::GitLabAPI, ::typeof(get_users)) = Vector{User}
