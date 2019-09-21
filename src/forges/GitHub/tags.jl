@json struct Object
    type::String
    sha::String <- sha_of
    url::String
end

@json struct Tag
    ref::String
    node_id::String
    url::String
    object::Object
end

name_of(t::Tag) = match(r"refs/tags/(.*)", t.ref)[1]
sha_of(t::Tag) = sha_of(t.object)

endpoint(::GitHubAPI, ::typeof(get_tags), owner::AStr, repo::AStr) =
    Endpoint(:GET, "/repos/$owner/$repo/git/refs/tags")
into(::GitHubAPI, ::typeof(get_tags)) = Vector{Tag}
