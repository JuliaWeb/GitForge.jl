@json struct Commit
    author_email::String
    author_name::String
    authored_date::DateTime
    committed_date::DateTime
    committer_email::String
    committer_name::String
    id::String
    short_id::String
    title::String
    message::String
    parent_ids::Vector{String}
end

@json struct Branch
    name::String
    merged::Bool
    protected::Bool
    default::Bool
    developers_can_push::Bool
    developers_can_merge::Bool
    can_push::Bool
    commit::Commit
end

endpoint(::GitLabAPI, ::typeof(get_branch), owner::AStr, repo::AStr, branch::AStr) =
    Endpoint(:GET, "/projects/" * escapeuri("$owner/$repo") * "/repository/branches/$branch")
into(::GitLabAPI, ::typeof(get_branch)) = Branch
