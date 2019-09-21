@json struct Commit
    id::String <- sha_of
    short_id::String <- name_of
    title::String <- title_of
    author_name::String
    author_email::String
    committer_name::String
    committer_email::String
    created_at::DateTime <- created_at
    message::String <- description_of
    committed_date::DateTime
    authored_date::DateTime
    parent_ids::Vector{String}
    last_pipeline::Pipeline
    status::String
end

endpoint(::GitLabAPI, ::typeof(get_commit), owner::AStr, repo::AStr, ref::AStr) =
    Endpoint(:GET, "/projects/$(encode(owner, repo))/repository/commits/$ref")
into(::GitLabAPI, ::typeof(get_commit)) = Commit
