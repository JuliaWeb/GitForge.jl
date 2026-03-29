@json struct CommitSignature
    name::String
    email::String
    date::DateTime
end

@json struct CommitTree
    url::String
    sha::String
    created::DateTime
end

@json struct CommitVerification
    verified::Bool
    reason::String
    signature::String
    payload::String
end

@json struct CommitInfo
    url::String
    author::CommitSignature
    committer::CommitSignature
    message::String
    tree::CommitTree
    verification::CommitVerification
end

@json struct CommitFile
    filename::String
    status::String
end

@json struct CommitStats
    total::Int
    additions::Int
    deletions::Int
end

@json struct Commit
    url::String
    sha::String
    created::DateTime
    html_url::String
    commit::CommitInfo
    author::User
    committer::User
    parents::Vector{CommitTree}
    files::Vector{CommitFile}
    stats::CommitStats
end

endpoint(::ForgejoAPI, ::typeof(get_commit), owner::AStr, repo::AStr, ref::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo/git/commits/$ref")
@not_implemented(::ForgejoAPI, ::typeof(get_commit), ::Int64, ::String)
into(::ForgejoAPI, ::typeof(get_commit)) = Commit
