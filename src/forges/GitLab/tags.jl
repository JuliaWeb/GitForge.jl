@json struct Release
    tag_name::String <- name_of
    description::String <- description_of
end

@json struct Tag
    commit::Commit
    release::Release
    name::String <- name_of
    target::String <- sha_of
    message::String <- description_of
end

endpoint(::GitLabAPI, ::typeof(get_tags), owner::AStr, repo::AStr) =
    Endpoint(:GET, "/projects/$(encode(owner, repo))/repository/tags")
into(::GitLabAPI, ::typeof(get_tags)) = Vector{Tag}
