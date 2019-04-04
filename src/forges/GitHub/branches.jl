@json struct Committer
    name::String
    date::DateTime
    email::String
end

@json struct CommitTree
    sha::String
    url::String
end

@json struct CommitVerification
    verified::Bool
    reason::String
    signature::String
    payload::String
end

@json struct CommitInfo
    author::Committer
    url::String
    message::String
    tree::CommitTree
    committer::Committer
    verification::CommitVerification
end

@json struct CommitLinks
    html::String
    self::String
end

@json struct CommitChecks
    enforcement_level::String
    contexts::Vector{String}
end

@json struct CommitProtection
    enabled::Bool
    required_status_checks::CommitChecks
end

@json struct Commit
    sha::String
    node_id::String
    commit::CommitInfo
    author::User
    parents::Vector{CommitTree}
    url::String
    committer::User
end

@json struct Branch
    name::String
    commit::Commit
    _links => links::CommitLinks
    protected::Bool
    protection::CommitProtection
    protection_url::String
end

endpoint(::GitHubAPI, ::typeof(get_branch), owner::AStr, repo::AStr, branch::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo/branches/$branch")
into(::GitHubAPI, ::typeof(get_branch)) = Branch
