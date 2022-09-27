@json struct Author
    raw::String
    user::User
end

@json struct Participant
    user::User
    role::String
    approved::Bool
    state::String
    participated_on::DateTime
end

@json struct Commit
    hash::String
    date::DateTime
    author::Author
    message::String
    summary::Dict{String, Any}
    parents::Vector{Commit}
    #not present in parent commit objects
    repository::Repo
    participants::Vector{Participant}
end

endpoint(::BitbucketAPI, ::typeof(get_commit), workspace::AStr, repo::AStr, ref::AStr) =
    Endpoint(:GET, "/repositories/$workspace/$repo/commit/$ref")
@not_implemented(::BitbucketAPI, ::typeof(get_commit), ::UUID, ::String)
into(::BitbucketAPI, ::typeof(get_commit)) = Commit
