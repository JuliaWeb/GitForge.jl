@json struct User
    id::Int
    login::String
    login_name::String
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
    website::String
    description::String
    visibility::String
    followers_count::Int
    following_count::Int
    starred_repos_count::Int
    username::String
end

endpoint(::CodebergAPI, ::typeof(get_user)) = Endpoint(:GET, "/user")
endpoint(::CodebergAPI, ::typeof(get_user), name::AStr) = Endpoint(:GET, "/users/$name")
@not_implemented(::CodebergAPI, ::typeof(get_user), ::Int64)
into(::CodebergAPI, ::typeof(get_user)) = User

endpoint(::CodebergAPI, ::typeof(get_users)) = Endpoint(:GET, "/admin/users")
into(::CodebergAPI, ::typeof(get_users)) = Vector{User}

@not_implemented(::CodebergAPI, ::typeof(update_user))
@not_implemented(::CodebergAPI, ::typeof(update_user), ::Integer)

@not_implemented(::CodebergAPI, ::typeof(create_user))

@not_implemented(::CodebergAPI, ::typeof(delete_user), ::Integer)
