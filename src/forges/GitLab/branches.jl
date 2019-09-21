@json struct Branch
    name::String <- name_of
    merged::Bool
    protected::Bool
    default::Bool
    developers_can_push::Bool
    developers_can_merge::Bool
    can_push::Bool
    commit::Commit
end

sha_of(b::Branch) = sha_of(b.commit)

endpoint(::GitLabAPI, ::typeof(get_branch), owner::AStr, repo::AStr, branch::AStr) =
    Endpoint(:GET, "/projects/$(encode(owner, repo))/repository/branches/$branch")
into(::GitLabAPI, ::typeof(get_branch)) = Branch
