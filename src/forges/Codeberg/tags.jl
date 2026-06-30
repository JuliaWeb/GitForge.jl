@json struct Tag
    id::String
    name::String
    message::String
    commit::PayloadCommit
    zipball_url::String
    tarball_url::String
end

endpoint(::CodebergAPI, ::typeof(get_tags), owner::AStr, repo::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo/tags")
@not_implemented(::CodebergAPI, ::typeof(get_tags), ::Integer)
into(::CodebergAPI, ::typeof(get_tags)) = Vector{Tag}
