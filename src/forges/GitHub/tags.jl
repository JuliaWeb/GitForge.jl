@json struct Object
    type::String
    sha::String
    url::String
end

@json struct Tag
    ref::String
    node_id::String
    url::String
    object::Object
end

endpoint(::GitHubAPI, ::typeof(get_tags), owner::AStr, repo::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo/git/refs/tags")
@not_implemented(::GitHubAPI, ::typeof(get_tags), ::Int64)
into(::GitHubAPI, ::typeof(get_tags)) = Vector{Tag}
