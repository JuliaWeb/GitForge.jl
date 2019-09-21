"""
This module provides some functions for common operations that abstract away any details specific to the forge you're interacting with.
"""
module Compat

using ..GitForge: GitForge, AStr
using ..GitForge.GitHub: GitHubAPI
using ..GitForge.GitLab: GitLabAPI

"""
    get_pull_requests(
        f::Forge, owner::$AStr, repo::$AStr;
        head::$AStr="", base::$AStr="",
        state::$AStr="open", kwargs...,
    )

List pull requests.
"""
function get_pull_requests(
    f::GitHubAPI, owner::AStr, repo::AStr;
    head::AStr="", base::AStr="master", state::AStr="open", kwargs...,
)
    lowercase(state) in ("open", "opened") && (state = "opened")
    lowercase(state) in ("close", "closed") && (state = "closed")
    return GitForge.get_pull_requests(
        f, owner, repo;
        head=head, base=base, state=state, kwargs...,
    )
end

function get_pull_requests(
    f::GitLabAPI, owner::AStr, repo::AStr;
    head::AStr="", base::AStr="master", state::AStr="open", kwargs...,
)
    lowercase(state) in ("open", "opened") && (state = "opened")
    lowercase(state) in ("close", "closed") && (state = "closed")
    return GitForge.get_pull_requests(
        f, owner, repo;
        source_branch=head, target_branch=base, state=state, kwargs...,
    )
end

"""
    create_pull_request(
        f::Forge, owner::$AStr, repo::$AStr;
        head::$AStr, base::$AStr="master",
        title::$AStr, body::$AStr="", kwargs...,
    )

Create a pull request.
"""
create_pull_request(
    f::GitHubAPI, owner::AStr, repo::AStr;
    head::AStr, base::AStr="master", title::AStr, body::AStr="", kwargs...,
) = GitForge.create_pull_request(
    f, owner, repo;
    head=head, base=base, title=title, body=body, kwargs...,
)
create_pull_request(
    f::GitLabAPI, owner::AStr, repo::AStr;
    head::AStr, base::AStr="master", title::AStr, body::AStr="", kwargs...,
) = GitForge.create_pull_request(
    f, owner, repo;
    source_branch=head, target_branch=base, title=title, description=body, kwargs...,
)

end
