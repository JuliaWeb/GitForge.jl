@json struct Note
    id::Int
    body::String
    attachment::String
    author::User
    created_at::DateTime
    updated_at::DateTime
    system::Bool
    noteable_id::Int
    noteable_type::String
    noteable_iid::Int
    resolvable::Bool
    confidential::Bool
end

## Merge Request Notes

# List All Merge Request Notes
# https://docs.gitlab.com/ee/api/notes.html#list-all-merge-request-notes
function endpoint(
    ::GitLabAPI,
    ::typeof(list_pull_request_comments),
    project::Integer,
    pull_request_id::Integer,
)
    return Endpoint(:GET, "/projects/$project/merge_requests/$pull_request_id/notes")
end
@not_implemented(
    api::GitLabAPI,
    ::typeof(list_pull_request_comments),
    owner::AStr,
    repo::AStr,
    pull_request_id::Integer
)
into(::GitLabAPI, ::typeof(list_pull_request_comments)) = Vector{Note}

# Get Single Merge Request Note
# https://docs.gitlab.com/ee/api/notes.html#get-single-merge-request-note
function endpoint(
    ::GitLabAPI,
    ::typeof(get_pull_request_comment),
    project::Integer,
    pull_request_id::Integer,
    comment_id::Integer,
)
    return Endpoint(
        :GET, "/projects/$project/merge_requests/$pull_request_id/notes/$comment_id"
    )
end
@not_implemented(
    api::GitLabAPI,
    ::typeof(get_pull_request_comment),
    owner::AStr,
    repo::AStr,
    comment_id::Integer,
)
into(::GitLabAPI, ::typeof(get_pull_request_comment)) = Note

# Create Merge Request Note
# https://docs.gitlab.com/ee/api/notes.html#create-new-merge-request-note
function endpoint(
    ::GitLabAPI,
    ::typeof(create_pull_request_comment),
    project::Integer,
    pull_request_id::Integer,
)
    return Endpoint(:POST, "/projects/$project/merge_requests/$pull_request_id/notes")
end
@not_implemented(
    api::GitLabAPI,
    ::typeof(create_pull_request_comment),
    owner::AStr,
    repo::AStr,
    pull_request_id::Integer,
)
into(::GitLabAPI, ::typeof(create_pull_request_comment)) = Note

# Update Merge Request Note
# https://docs.gitlab.com/ee/api/notes.html#modify-existing-merge-request-note
function endpoint(
    ::GitLabAPI,
    ::typeof(update_pull_request_comment),
    project::Integer,
    pull_request_id::Integer,
    comment_id::Integer,
)
    return Endpoint(
        :PUT, "/projects/$project/merge_requests/$pull_request_id/notes/$comment_id"
    )
end
@not_implemented(
    api::GitLabAPI,
    ::typeof(update_pull_request_comment),
    owner::AStr,
    repo::AStr,
    comment_id::Integer,
)
into(::GitLabAPI, ::typeof(update_pull_request_comment)) = Note

# Delete Merge Request Note
# https://docs.gitlab.com/ee/api/notes.html#delete-a-merge-request-note
function endpoint(
    ::GitLabAPI,
    ::typeof(delete_pull_request_comment),
    project::Integer,
    pull_request_id::Integer,
    comment_id::Integer,
)
    return Endpoint(
        :DELETE, "/projects/$project/merge_requests/$pull_request_id/notes/$comment_id"
    )
end
@not_implemented(::GitLabAPI, ::typeof(delete_pull_request_comment), ::String, ::String, ::Int64)
into(::GitLabAPI, ::typeof(delete_pull_request_comment)) = Note
