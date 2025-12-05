@json struct PayloadCommit
    id::String
    message::String
    url::String
    author::CommitUser
    committer::CommitUser
    timestamp::DateTime
end

@json struct BranchProtection
    branch_name::String
    enable_push::Bool
    enable_push_whitelist::Bool
    push_whitelist_usernames::Vector{String}
    push_whitelist_teams::Vector{String}
    push_whitelist_deploy_keys::Bool
    enable_merge_whitelist::Bool
    merge_whitelist_usernames::Vector{String}
    merge_whitelist_teams::Vector{String}
    enable_status_check::Bool
    status_check_contexts::Vector{String}
    required_approvals::Int
    enable_approvals_whitelist::Bool
    approvals_whitelist_usernames::Vector{String}
    approvals_whitelist_teams::Vector{String}
    block_on_rejected_reviews::Bool
    block_on_official_review_requests::Bool
    block_on_outdated_branch::Bool
    dismiss_stale_approvals::Bool
    require_signed_commits::Bool
    protected_file_patterns::String
    unprotected_file_patterns::String
    created_at::DateTime
    updated_at::DateTime
end

@json struct Branch
    name::String
    commit::PayloadCommit
    protected::Bool
    required_approvals::Int
    enable_status_check::Bool
    status_check_contexts::Vector{String}
    user_can_push::Bool
    user_can_merge::Bool
    effective_branch_protection_name::String
end

endpoint(::CodebergAPI, ::typeof(get_branch), owner::AStr, repo::AStr, branch::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo/branches/$branch")
into(::CodebergAPI, ::typeof(get_branch)) = Branch

endpoint(::CodebergAPI, ::typeof(get_branches), owner::AStr, repo::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo/branches")
into(::CodebergAPI, ::typeof(get_branches)) = Vector{Branch}

endpoint(::CodebergAPI, ::typeof(delete_branch), owner::AStr, repo::AStr, branch::AStr) =
    Endpoint(:DELETE, "/repos/$owner/$repo/branches/$branch")
postprocessor(::CodebergAPI, ::typeof(delete_branch)) = DoNothing()
