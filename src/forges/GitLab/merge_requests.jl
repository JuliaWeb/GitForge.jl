@json struct Milestone
    id::Int
    iid::Int
    project_id::Int
    title::String
    description::String
    state::String
    created_at::DateTime
    updated_at::DateTime
    due_date::Date
    start_date::Date
    web_url::String
end

@json struct TimeStats
    time_estimate::Int
    total_time_spent::Int
    human_time_estimate::String
    human_total_time_spent::String
end

@json struct Pipeline
    id::Int
    sha::String
    ref::String
    status::String
    web_url::String
end

@json struct DiffRefs
    base_sha::String
    head_sha::String
    start_sha::String
end

@json struct MergeRequest
    id::Int
    iid::Int
    project_id::Int
    title::String
    description::String
    state::String
    created_at::DateTime
    updated_at::DateTime
    target_branch::String
    source_branch::String
    upvotes::Int
    downvotes::Int
    author::User
    assignee::User
    source_project_id::Int
    target_project_id::Int
    labels::Vector{String}
    work_in_progress::Bool
    milestone::Milestone
    merge_when_pipeline_succeeds::Bool
    merge_status::String
    merge_error::String
    sha::String
    merge_commit_sha::String
    user_notes_count::Int
    discussion_locked::Bool
    should_remove_source_branch::Bool
    force_remove_source_branch::Bool
    allow_collaboration::Bool
    allow_maintainer_to_push::Bool
    web_url::String
    time_stats::TimeStats
    squash::Bool
    subscribed::Bool
    changes_count::String
    merged_by::User
    merged_at::DateTime
    closed_by::User
    closed_at::DateTime
    latest_build_started_at::DateTime
    latest_build_finished_at::DateTime
    first_deployed_to_production_at::DateTime
    pipeline::Pipeline
    diff_refs::DiffRefs
end

endpoint(::GitLabAPI, ::typeof(get_pull_requests), project::Integer) =
    Endpoint(:GET, "/projects/$project/merge_requests")
into(::GitLabAPI, ::typeof(get_pull_requests)) = Vector{MergeRequest}

endpoint(::GitLabAPI, ::typeof(get_pull_requests), project::Integer, number::Integer) =
    Endpoint(:GET, "/projects/$project/merge_requests/$number")
endpoint(
    ::GitLabAPI, ::typeof(get_pull_requests),
    owner::AStr, repo::AStr, number::Integer,
) = Endpoint(:GET, "/projects/$(encode(owner, repo))/merge_requests/$number")
into(::GitLabAPI, ::typeof(get_pull_request)) = MergeRequest

endpoint(::GitLabAPI, ::typeof(create_pull_request), project::Integer) =
    Endpoint(:POST, "/projects/$project/merge_requests")
endpoint(::GitLabAPI, ::typeof(create_pull_request), owner::AStr, repo::AStr) =
    Endpoint(:POST, "/projects/$(encode(owner, repo))/merge_requests")
into(::GitLabAPI, ::typeof(create_pull_request)) = MergeRequest
