@json struct Tag
    links::NamedTuple
    name::String
    target::Commit
end

endpoint(::BitbucketAPI, ::typeof(get_tags), workspace::String, repo::String) = Endpoint(:GET, "/repositories/$workspace/$repo/refs/tags")
@not_implemented(::BitbucketAPI, ::typeof(get_tags), ::UUID)
into(::BitbucketAPI, ::typeof(get_tags)) = Page{get_tags, Tag}
