@json struct Branch
    name::String
    merged::Bool
    protected::Bool
    default::Bool
    developers_can_push::Bool
    developers_can_merge::Bool
    can_push::Bool
    commit::Commit
end

endpoint(::GitLabAPI, ::typeof(get_branch), owner::AStr, repo::AStr, branch::AStr) =
    Endpoint(:GET, "/projects/$(encode(owner, repo))/repository/branches/$branch")
into(::GitLabAPI, ::typeof(get_branch)) = Branch
