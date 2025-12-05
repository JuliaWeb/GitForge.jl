@json struct CommitUser
    name::String
    email::String
    date::DateTime
end

@json struct RepoCommit
    url::String
    author::CommitUser
    committer::CommitUser
    message::String
end

@json struct CommitAffectedFiles
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
    html_url::String
    commit::RepoCommit
    author::User
    committer::User
    parents::Vector{Commit}
    files::Vector{CommitAffectedFiles}
    stats::CommitStats
    created::DateTime
end

endpoint(::CodebergAPI, ::typeof(get_commit), owner::AStr, repo::AStr, ref::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo/git/commits/$ref")
@not_implemented(::CodebergAPI, ::typeof(get_commit), ::Integer, ::String)
into(::CodebergAPI, ::typeof(get_commit)) = Commit
