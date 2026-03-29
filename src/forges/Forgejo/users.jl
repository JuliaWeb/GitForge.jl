@json struct User
    id::Int
    login::String
    full_name::String
    email::String
    avatar_url::String
    html_url::String
    language::String
    is_admin::Bool
    last_login::DateTime
    created::DateTime
    restricted::Bool
    active::Bool
    prohibit_login::Bool
    location::String
    pronouns::String
    website::String
    description::String
    visibility::String
    followers_count::Int
    following_count::Int
    starred_repos_count::Int
    username::String
end

endpoint(::ForgejoAPI, ::typeof(get_user)) = Endpoint(:GET, "/user")
@not_implemented(::ForgejoAPI, ::typeof(get_user), ::Int64)
endpoint(::ForgejoAPI, ::typeof(get_user), name::AStr) = Endpoint(:GET, "/users/$name")
into(::ForgejoAPI, ::typeof(get_user)) = User

endpoint(::ForgejoAPI, ::typeof(get_users)) = Endpoint(:GET, "/admin/users")
into(::ForgejoAPI, ::typeof(get_users)) = Vector{User}

@not_implemented(api::ForgejoAPI, ::typeof(update_user), id::Integer)
@not_implemented(api::ForgejoAPI, ::typeof(update_user))
@not_implemented(::ForgejoAPI, ::typeof(create_user))
@not_implemented(::ForgejoAPI, ::typeof(delete_user), id::Integer)
