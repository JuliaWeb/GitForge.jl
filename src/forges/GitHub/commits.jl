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
    url::String
    author::Committer
    committer::Committer
    message::String
    tree::CommitTree
    comment_count::Int
    verification::CommitVerification
end

@json struct CommitFile
    filename::String
    additions::Int
    deletions::Int
    changes::Int
    status::String
    raw_url::String
    blob_url::String
    patch::String
end

@json struct CommitStats
    additions::Int
    deletions::Int
    total::Int
end

@json struct Commit
    url::String
    sha::String
    node_id::String
    html_url::String
    comments_url::String
    commit::CommitInfo
    author::User
    committer::User
    parents::Vector{CommitTree}
    stats::CommitStats
    files::Vector{CommitFile}
end

endpoint(::GitHubAPI, ::typeof(get_commit), owner::AStr, repo::AStr, ref::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo/commits/$ref")
into(::GitHubAPI, ::typeof(get_commit)) = Commit
