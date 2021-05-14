@json struct CommitStats
    additions::Int
    deletions::Int
    total::Int
end

@json struct Commit
    id::String
    short_id::String
    title::String
    author_name::String
    author_email::String
    committer_name::String
    committer_email::String
    created_at::DateTime
    message::String
    committed_date::ZonedDateTime
    authored_date::ZonedDateTime
    parent_ids::Vector{String}
    last_pipeline::Pipeline
    status::String
    web_url::String
    stats::CommitStats
    project_id::Int
end

StructTypes.keywordargs(::Type{Commit}) = (; dateformat="y-m-dTH:M:S.sssz")

endpoint(::GitLabAPI, ::typeof(get_commit), owner::AStr, repo::AStr, ref::AStr) =
    Endpoint(:GET, "/projects/$(encode(owner, repo))/repository/commits/$ref")
endpoint(::GitLabAPI, ::typeof(get_commit), project::Integer, ref::AStr) =
    Endpoint(:GET, "/projects/$project/repository/commits/$ref")
into(::GitLabAPI, ::typeof(get_commit)) = Commit
