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
