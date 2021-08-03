@json struct PipelineSchedule
    id::Int
    description::String
    ref::String
    cron::String
    cron_timezone::String
    next_run_at::DateTime
    active::Bool
    created_at::DateTime
    updated_at::DateTime
    owner::User
end

## Pipeline Schedules

# Get All Pipeline Schedules
# https://docs.gitlab.com/ee/api/pipeline_schedules.html#get-all-pipeline-schedules
function endpoint(
    ::GitLabAPI,
    ::typeof(list_pipeline_schedules),
    project::Integer,
)
    return Endpoint(:GET, "/projects/$project/pipeline_schedules")
end

function endpoint(
    ::GitLabAPI,
    ::typeof(list_pipeline_schedules),
    owner::AStr,
    repo::AStr,
)
    return Endpoint(:GET, "/projects/$(encode(owner, repo))/pipeline_schedules")
end

into(::GitLabAPI, ::typeof(list_pipeline_schedules)) = Vector{PipelineSchedule}
