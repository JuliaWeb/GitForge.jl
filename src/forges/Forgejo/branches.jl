@json struct CommitUser
    name::String
    email::String
    username::String
end

@json struct VerificationSigner
    name::String
    email::String
    username::String
end

@json struct Verification
    verified::Bool
    reason::String
    signature::String
    payload::String
    signer::VerificationSigner
end

@json struct PayloadCommit
    id::String
    message::String
    url::String
    author::CommitUser
    committer::CommitUser
    verification::Verification
    timestamp::DateTime
    added::Vector{String}
    removed::Vector{String}
    modified::Vector{String}
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

endpoint(::ForgejoAPI, ::typeof(get_branch), owner::AStr, repo::AStr, branch::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo/branches/$branch")
into(::ForgejoAPI, ::typeof(get_branch)) = Branch

endpoint(::ForgejoAPI, ::typeof(get_branches), owner::AStr, repo::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo/branches")
into(::ForgejoAPI, ::typeof(get_branches)) = Vector{Branch}

endpoint(::ForgejoAPI, ::typeof(delete_branch), owner::AStr, repo::AStr, branch::AStr) =
    Endpoint(:DELETE, "/repos/$owner/$repo/branches/$branch")
postprocessor(::ForgejoAPI, ::typeof(delete_branch)) = DoNothing()
