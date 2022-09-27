@json struct User
    account_id::String
    account_status::String
    created_on::DateTime
    display_name::String
    has_2fa_enabled::Bool
    is_staff::Bool
    links::NamedTuple
    location::String
    nickname::String
    type::String
    username::String
    uuid::UUID
    website::String
end

@json struct WorkspaceMembership
    links::NamedTuple
    user::User
end

endpoint(::BitbucketAPI, ::typeof(get_user)) = Endpoint(:GET, "/user")
endpoint(::BitbucketAPI, ::typeof(get_user), name::AStr) =
    Endpoint(:GET, "/workspaces/$name/members",
             query = Dict(
                 :q=> "user.username=\"$name\""
             )
             )
@not_implemented(::BitbucketAPI, ::typeof(get_user), ::UUID)
postprocessor(::BitbucketAPI, ::typeof(get_user)) = DoSomething() do resp
    try
        if match(r".*/workspaces/", resp.request.target) !== nothing
            JSON3.read(String(resp.body), Page{get_user, WorkspaceMembership}).values[1].user
        else
            JSON3.read(String(resp.body), User)
        end
    catch err
        @error "Error converting $(String(resp.body))" exception=(err,catch_backtrace())
        rethrow(err)
    end
end
into(::BitbucketAPI, ::typeof(get_user)) = User

endpoint(api::BitbucketAPI, ::typeof(get_users), workspace::AStr) = Endpoint(:GET, "/workspaces/$workspace/members")
into(::BitbucketAPI, ::typeof(get_users)) = Page{get_users, User}
@not_implemented(api::BitbucketAPI, ::typeof(get_users))

@not_implemented(api::BitbucketAPI, ::typeof(update_user))
@not_implemented(api::BitbucketAPI, ::typeof(update_user), id::UUID)

@not_implemented(api::BitbucketAPI, ::typeof(create_user))

@not_implemented(api::BitbucketAPI, ::typeof(delete_user), id::UUID)
