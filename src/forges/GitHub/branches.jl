@json struct BranchChecks
    enforcement_level::String
    contexts::Vector{String}
end

@json struct BranchProtection
    enabled::Bool
    required_status_checks::BranchChecks
end

@json struct BranchLinks
    html::String
    self::String
end

@json struct Branch
    name::String
    commit::Commit
    _links => links::BranchLinks
    protected::Bool
    protection::BranchProtection
    protection_url::String
end

endpoint(::GitHubAPI, ::typeof(get_branch), owner::AStr, repo::AStr, branch::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo/branches/$branch")
into(::GitHubAPI, ::typeof(get_branch)) = Branch

# Get Repository Branches
# https://docs.github.com/en/rest/reference/repos#list-branches
function endpoint(
    ::GitHubAPI,
    ::typeof(get_branches),
    owner::AStr,
    repo::AStr,
)
    return Endpoint(:GET, "repos/$owner/$repo/branches")
end
into(::GitHubAPI, ::typeof(get_branches)) = Vector{Branch}

# Delete Branch (Delete Reference)
# https://docs.github.com/en/rest/reference/git#delete-a-reference
# The :ref in the URL must be formatted as heads/<branch name> for branches
function endpoint(
    ::GitHubAPI,
    ::typeof(delete_branch),
    owner::AStr,
    repo::AStr,
    branch::AStr,
)
    return Endpoint(:DELETE, "/repos/$owner/$repo/git/refs/heads/$branch")
end
postprocessor(::GitHubAPI, ::typeof(delete_branch)) = DoNothing()
