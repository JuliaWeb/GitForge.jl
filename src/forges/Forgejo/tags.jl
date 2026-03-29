@json struct TagCommit
    url::String
    sha::String
    created::DateTime
end

@json struct Tag
    name::String
    message::String
    id::String
    commit::TagCommit
    zipball_url::String
    tarball_url::String
    archive_download_count::Dict{String, Int}
end

endpoint(::ForgejoAPI, ::typeof(get_tags), owner::AStr, repo::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo/tags")
@not_implemented(::ForgejoAPI, ::typeof(get_tags), ::Int64)
into(::ForgejoAPI, ::typeof(get_tags)) = Vector{Tag}
