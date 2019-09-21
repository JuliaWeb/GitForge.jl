@json struct Committer
    name::String <- name_of
    date::DateTime <- created_at
    email::String
end

@json struct CommitTree
    sha::String <- sha_of
    url::String
end

@json struct CommitVerification
    verified::Bool
    reason::String <- description_of
    signature::String
    payload::String
end

@json struct CommitInfo
    url::String
    author::Committer <- owner_of
    committer::Committer
    message::String <- description_of
    tree::CommitTree
    comment_count::Int
    verification::CommitVerification
end

created_at(c::CommitInfo) = created_at(c.author)
sha_of(c::CommitInfo) = sha_of(c.tree)
title_of(c::CommitInfo) = c.message === nothing ? nothing : first(split(c.message, "\n"))

@json struct CommitFile
    filename::String <- name_of
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
    sha::String <- sha_of
    node_id::String
    html_url::String <- web_url
    comments_url::String
    commit::CommitInfo
    author::User <- owner_of
    committer::User
    parents::Vector{CommitTree}
    stats::CommitStats
    files::Vector{CommitFile}
end

name_of(c::Commit) = c.sha === nothing ? nothing : c.sha[1:7]
description_of(c::Commit) = description_of(c.commit)
title_of(c::Commit) = title_of(c.commit)
created_at(c::Commit) = created_at(c.commit)

endpoint(::GitHubAPI, ::typeof(get_commit), owner::AStr, repo::AStr, ref::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo/commits/$ref")
into(::GitHubAPI, ::typeof(get_commit)) = Commit
