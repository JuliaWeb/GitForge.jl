@json struct Release
    tag_name::String
    description::String
end

@json struct Tag
    commit::Commit
    release::Release
    name::String
    target::String
    message::String
end

endpoint(::GitLabAPI, ::typeof(get_tags), project::Integer) =
    Endpoint(:GET, "/projects/$project/repository/tags")
endpoint(::GitLabAPI, ::typeof(get_tags), owner::AStr, repo::AStr) =
    Endpoint(:GET, "/projects/$(encode(owner, repo))/repository/tags")
into(::GitLabAPI, ::typeof(get_tags)) = Vector{Tag}
