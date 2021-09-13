@json struct Branch
    name::String
    merged::Bool
    protected::Bool
    default::Bool
    developers_can_push::Bool
    developers_can_merge::Bool
    can_push::Bool
    web_url::String
    commit::Commit
end

endpoint(::GitLabAPI, ::typeof(get_branch), owner::AStr, repo::AStr, branch::AStr) =
    Endpoint(:GET, "/projects/$(encode(owner, repo))/repository/branches/$branch")
into(::GitLabAPI, ::typeof(get_branch)) = Branch


# Get Repository Branches
# https://docs.gitlab.com/ee/api/branches.html#list-repository-branches
function endpoint(
    ::GitLabAPI,
    ::typeof(get_branches),
    owner::AStr,
    repo::AStr,
)
    return Endpoint(:GET, "/projects/$(encode(owner, repo))/repository/branches")
end
into(::GitLabAPI, ::typeof(get_branches)) = Vector{Branch}

# Delete Branch
# https://docs.gitlab.com/ee/api/branches.html#delete-repository-branch
function endpoint(
    ::GitLabAPI,
    ::typeof(delete_branch),
    owner::AStr,
    repo::AStr,
    branch::AStr,
)
    return Endpoint(
        :DELETE,
        "/projects/$(encode(owner, repo))/repository/branches/$(encode(branch))",
    )
end
postprocessor(::GitLabAPI, ::typeof(delete_branch)) = DoNothing
