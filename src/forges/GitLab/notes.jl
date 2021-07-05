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
into(::GitLabAPI, ::typeof(get_pull_request_comment)) = Note

# Create New Merge Request Note
# https://docs.gitlab.com/ee/api/notes.html#create-new-merge-request-note
function endpoint(
    ::GitLabAPI,
    ::typeof(create_new_pull_request_comment),
    project::Integer,
    pull_request_id::Integer,
)
    return Endpoint(:POST, "/projects/$project/merge_requests/$pull_request_id/notes")
end
into(::GitLabAPI, ::typeof(create_new_pull_request_comment)) = Note

# Modify Merge Request Note
# https://docs.gitlab.com/ee/api/notes.html#modify-existing-merge-request-note
function endpoint(
    ::GitLabAPI,
    ::typeof(modify_pull_request_comment),
    project::Integer,
    pull_request_id::Integer,
    comment_id::Integer,
)
    return Endpoint(
        :PUT, "/projects/$project/merge_requests/$pull_request_id/notes/$comment_id"
    )
end
into(::GitLabAPI, ::typeof(modify_pull_request_comment)) = Note

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
into(::GitLabAPI, ::typeof(delete_pull_request_comment)) = Note
