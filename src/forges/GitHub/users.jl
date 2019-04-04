@json struct Plan
    name::String
    space::Int
    private_repos::Int
    collaborators::Int
end

@json struct User
    login::String
    id::Int
    node_id::String
    avatar_url::String
    gravatar_id::String
    url::String
    html_url::String
    followers_url::String
    following_url::String
    gists_url::String
    starred_url::String
    subscriptions_url::String
    organizations_url::String
    repos_url::String
    events_url::String
    received_events_url::String
    type::String
    site_admin::Bool
    name::String
    company::String
    blog::String
    location::String
    email::String
    hireable::Bool
    bio::String
    public_repos::Int
    public_gists::Int
    followers::Int
    following::Int
    created_at::DateTime
    updated_at::DateTime
    private_gists::Int
    total_private_repos::Int
    owned_private_repos::Int
    disk_usage::Int
    collaborators::Int
    two_factor_authentication::Bool
    plan::Plan
end

endpoint(::GitHubAPI, ::typeof(get_user)) = Endpoint(:GET, "/user")
endpoint(::GitHubAPI, ::typeof(get_user), name::AStr) = Endpoint(:GET, "/users/$name")
into(::GitHubAPI, ::typeof(get_user)) = User

endpoint(::GitHubAPI, ::typeof(get_users)) = Endpoint(:GET, "/users")
into(::GitHubAPI, ::typeof(get_users)) = Vector{User}

endpoint(::GitHubAPI, ::typeof(update_user)) = Endpoint(:PATCH, "/user")
into(::GitHubAPI, ::typeof(update_user)) = User
