endpoint(::BitbucketAPI, ::typeof(is_member), workspace::String, user::String) =
    Endpoint(:GET, "/workspaces/$workspace/members";
             allow_404=true,
             query=Dict(
                 :q => "user.nickname=\"$user\""
             )
             )
endpoint(::BitbucketAPI, ::typeof(is_member), workspace::String, user::UUID) =
    Endpoint(:GET, "/workspaces/$workspace/members";
             allow_404=true,
             query=Dict(
                 :q => "user.nickname=\"{$user}\""
             )
             )
postprocessor(::BitbucketAPI, ::typeof(is_member)) = DoSomething(ismemberorcollaborator)
into(::BitbucketAPI, ::typeof(is_member)) = Dict

@not_implemented(::BitbucketAPI, ::typeof(groups), )
