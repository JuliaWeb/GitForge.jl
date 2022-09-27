using GitForge
using UUIDs
using GitForge: AStr, Endpoint, ForgeAPINotImplemented, ForgeAPIError
using GitForge: GitHub, GitLab, Bitbucket
using GitForge.GitHub: Token, GitHubAPI
using GitForge.GitLab: GitLabAPI, OAuth2Token
using GitForge.Bitbucket: BitbucketAPI
using HTTP, JSON3, Logging
using Test: @test, @testset, TestLogger, @test_throws

const GH_TOKEN = Token("secret token")
const GL_TOKEN = OAuth2Token("secret token")
const USER = "a user"
const WORKSPACE = "a workspace"
const GF = GitForge

function capture(f::Function)
    t = TestLogger()
    result = with_logger(t) do
        f()
    end
    return result, t.logs
end

struct TestPostProcessor <: GF.PostProcessor end
GF.postprocess(::TestPostProcessor, ::HTTP.Response, ::Type) = :foo

struct TestForge <: GF.Forge end
GF.base_url(::TestForge) = "https://httpbin.org"
GF.request_headers(::TestForge, ::Function) = ["Foo" => "Bar"]
GF.request_query(::TestForge, ::Function) = Dict("foo" => "bar")
GF.request_kwargs(::TestForge, ::Function) = Dict(:verbose => 1)
GF.postprocessor(::TestForge, ::Function) = TestPostProcessor()
GF.endpoint(::TestForge, ::typeof(get_user)) = GF.Endpoint(:GET, "/get")
GF.into(::TestForge, ::typeof(get_user)) = Symbol

@testset "GitForge.jl" begin
    f = TestForge()
    (val, resp), out = capture(() -> get_user(f))
    @testset "Basics" begin
        @test val === :foo
        @test resp isa HTTP.Response
    end

    @testset "Request options" begin
        body = JSON3.read(IOBuffer(resp.body))
        @test startswith(get(body, :url, ""), "https://httpbin.org")
        @test get(get(body, :headers, Dict()), :Foo, "") == "Bar"
        @test get(get(body, :args, Dict()), :foo, "") == "bar"
        @test occursin("/get", get(body, :url, ""))
        @test !isempty(out)
    end

    @testset "Per-call request options" begin
        (_, resp), out = capture() do
            get_user(
                f;
                query=Dict("a" => "b"),
                headers=["A" => "B"],
                request_opts=(; verbose=0),
            )
        end

        @test isempty(out)

        body = JSON3.read(IOBuffer(resp.body))
        @test haskey(body.headers, :Foo)
        @test get(body.headers, :A, "") == "B"
        @test haskey(get(body, :args, Dict()), :foo)
        @test get(get(body, :args, Dict()), :a, "") == "b"
    end
end

# test whether apis are conformant

function test_api_func(api, (func, args...), auth)
    exclude(api, func, args...) && return
    try
        endpoint = GF.endpoint(api, func, args...)
        headers = Dict(GF.request_headers(api, func))
        @test headers["Content-Type"] isa AStr
        @test match(r"^Julia v.* \(GitForge v.*\)", headers["User-Agent"]) !== nothing
        if auth
            @test headers["Authorization"] isa AStr
        end
        @test GF.has_rate_limits(api, func) isa Bool
        @test !GF.has_rate_limits(api, func) || GF.on_rate_limit(api, func) isa GF.OnRateLimit
        @test endpoint isa Endpoint
        if hasmethod(GF.into, typeof.((api, func)))
            @test GF.into(api, func) isa Type
        else
            @test typeof(GF.postprocessor(api, func)) in [GF.DoNothing, GF.DoSomething, JSON]
        end
        true
    catch err
        !(err isa ForgeAPINotImplemented) && rethrow(err)
        err isa ForgeAPINotImplemented && !err.noted && println(sprint(io-> showerror(io, err)))
        err isa ForgeAPINotImplemented && !err.noted && @test false
        false
    end
end

mock_id(api) = mock_id(user_id_type(api))
mock_id(::Type{Integer}) = 1
mock_id(::Type{String}) = "fred"
mock_id(::Type{UUID}) = UUID(0)

user_id_type(::GitHubAPI) = Integer
user_id_type(::GitLabAPI) = Integer
user_id_type(::BitbucketAPI) = UUID

function test_api(api; auth = false)
    unimplemented = 0
    @test GF.base_url(api) isa AStr
    for func in [
        get_user, (get_user, "fred"), (get_user, mock_id(api)),
        get_users,
        update_user, (update_user, mock_id(api)),
        create_user, (delete_user, mock_id(api)),
        get_user_repos, (get_user_repos, "fred"), (get_user_repos, mock_id(api)),
        (get_repo, "owner/repo"), (get_repo, "owner", "repo"), (get_repo, "owner", "subgroup", "repo"),
        create_repo, (create_repo, "org"), (create_repo, mock_id(api)), (create_repo, "namespace", "repo"),
        (get_branch, "owner", "repo", "branch"),
        (get_branches, "owner", "repo"),
        (delete_branch, "owner", "repo", "branch"),
        (get_file_contents, "owner", "repo", "path"), (get_file_contents, mock_id(api), "path"),
        (get_pull_request, "owner", "repo", mock_id(api)), (get_pull_request, mock_id(api), mock_id(api)),
        (get_pull_requests, "owner", "repo"), (get_pull_requests, mock_id(api)),
        (create_pull_request, "owner", "repo"), (create_pull_request, mock_id(api)),
        (update_pull_request, "owner", "repo", 1), (update_pull_request, mock_id(api), 1),
        (subscribe_to_pull_request, mock_id(api), mock_id(api)),
        (unsubscribe_from_pull_request, mock_id(api), mock_id(api)),
        (get_commit, "owner", "repo", "ref"), (get_commit, mock_id(api), "ref"),
        (is_collaborator, "owner", "repo", "user"), (is_collaborator, "owner", "repo", mock_id(api)),
        (is_member, "org", "user"), (is_member, "org", mock_id(api)),
        groups,
        (get_tags, "owner", "repo"), (get_tags, mock_id(api)),
        (list_pull_request_comments, "owner", "repo", mock_id(api)), (list_pull_request_comments, mock_id(api), mock_id(api)),
        (get_pull_request_comment, "owner", "repo", mock_id(api)), (get_pull_request_comment, mock_id(api), mock_id(api), mock_id(api)),
        (create_pull_request_comment, "owner", "repo", mock_id(api)), (create_pull_request_comment, mock_id(api), mock_id(api)),
        (update_pull_request_comment, "owner", "repo", mock_id(api)), (update_pull_request_comment, mock_id(api), mock_id(api), mock_id(api)),
        (delete_pull_request_comment, "owner", "repo", mock_id(api)), (delete_pull_request_comment, mock_id(api), mock_id(api), mock_id(api)),
        (list_pipeline_schedules, mock_id(api)), (list_pipeline_schedules, "owner", "repo"),
        ]
        tuple = func isa Function ? (func,) : func
        impl = test_api_func(api, tuple, auth)
        !impl && (unimplemented += 1)
    end
    unimplemented > 0 && println("    $unimplemented unimplmented method$(unimplemented == 1 ? "" : "s")")
end

"""
    exclude(api, func, args...)

exclude an api function from testing
"""
exclude(_api, _func, _args...) = false
#exclude(::BitbucketAPI, ::typeof(get_file_contents), _args...) = true

@testset "Bitbucket.jl" begin
    api = BitbucketAPI(; token = GH_TOKEN, workspace = WORKSPACE)
    @test api.token == GH_TOKEN
    @test api.url == Bitbucket.DEFAULT_URL
    @test api.workspace == WORKSPACE
    test_api(api, auth = true)
    @test_throws ForgeAPINotImplemented GF.endpoint(api, get_repo, "owner")
end

@testset "GitHub.jl" begin
    api = GitHubAPI(; token = GH_TOKEN)
    @test api.token == GH_TOKEN
    @test api.url == GitHub.DEFAULT_URL
    test_api(api, auth = true)
end

@testset "GitLab.jl" begin
    api = GitLabAPI(; token = GL_TOKEN)
    @test api.token == GL_TOKEN
    @test api.url == GitLab.DEFAULT_URL
    test_api(api, auth = true)
end

# encoding tests
const ENCODING_SAMPLES = [
    GitHub.Repo => "{\"has_projects\":true,\"open_issues_count\":0,\"has_pages\":false,\"squash_merge_commit_title\":\"COMMIT_OR_PR_TITLE\",\"keys_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/keys{/key_id}\",\"hooks_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/hooks\",\"license\":null,\"forks\":0,\"homepage\":null,\"assignees_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/assignees{/user}\",\"contributors_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/contributors\",\"clone_url\":\"https://github.com/zot/examplebranchsubdir.jl.git\",\"has_wiki\":true,\"merge_commit_title\":\"MERGE_MESSAGE\",\"private\":false,\"name\":\"examplebranchsubdir.jl\",\"commits_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/commits{/sha}\",\"blobs_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/git/blobs{/sha}\",\"git_commits_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/git/commits{/sha}\",\"notifications_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/notifications{?since,all,participating}\",\"contents_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/contents/{+path}\",\"allow_update_branch\":false,\"issues_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/issues{/number}\",\"watchers_count\":0,\"updated_at\":\"2022-07-21T14:20:23Z\",\"stargazers_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/stargazers\",\"labels_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/labels{/name}\",\"created_at\":\"2022-03-09T06:32:33Z\",\"watchers\":0,\"teams_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/teams\",\"is_template\":false,\"visibility\":\"public\",\"html_url\":\"https://github.com/zot/examplebranchsubdir.jl\",\"url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl\",\"default_branch\":\"master\",\"subscription_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/subscription\",\"fork\":false,\"git_refs_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/git/refs{/sha}\",\"full_name\":\"zot/examplebranchsubdir.jl\",\"merges_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/merges\",\"id\":467805961,\"forks_count\":0,\"milestones_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/milestones{/number}\",\"allow_merge_commit\":true,\"allow_rebase_merge\":true,\"pulls_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/pulls{/number}\",\"svn_url\":\"https://github.com/zot/examplebranchsubdir.jl\",\"subscribers_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/subscribers\",\"git_url\":\"git://github.com/zot/examplebranchsubdir.jl.git\",\"network_count\":0,\"delete_branch_on_merge\":false,\"issue_events_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/issues/events{/number}\",\"branches_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/branches{/branch}\",\"allow_squash_merge\":true,\"tags_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/tags\",\"topics\":[],\"releases_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/releases{/id}\",\"archived\":false,\"permissions\":{\"admin\":true,\"maintain\":true,\"pull\":true,\"push\":true,\"triage\":true},\"pushed_at\":\"2022-03-09T06:32:42Z\",\"statuses_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/statuses/{sha}\",\"comments_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/comments{/number}\",\"use_squash_pr_title_as_default\":false,\"allow_auto_merge\":false,\"language\":\"Julia\",\"owner\":{\"organizations_url\":\"https://api.github.com/users/zot/orgs\",\"starred_url\":\"https://api.github.com/users/zot/starred{/owner}{/repo}\",\"avatar_url\":\"https://avatars.githubusercontent.com/u/26665?v=4\",\"following_url\":\"https://api.github.com/users/zot/following{/other_user}\",\"repos_url\":\"https://api.github.com/users/zot/repos\",\"gravatar_id\":\"\",\"login\":\"zot\",\"gists_url\":\"https://api.github.com/users/zot/gists{/gist_id}\",\"url\":\"https://api.github.com/users/zot\",\"site_admin\":false,\"subscriptions_url\":\"https://api.github.com/users/zot/subscriptions\",\"received_events_url\":\"https://api.github.com/users/zot/received_events\",\"id\":26665,\"html_url\":\"https://github.com/zot\",\"node_id\":\"MDQ6VXNlcjI2NjY1\",\"type\":\"User\",\"events_url\":\"https://api.github.com/users/zot/events{/privacy}\",\"followers_url\":\"https://api.github.com/users/zot/followers\"},\"downloads_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/downloads\",\"allow_forking\":true,\"description\":null,\"collaborators_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/collaborators{/collaborator}\",\"has_issues\":true,\"size\":1,\"disabled\":false,\"mirror_url\":null,\"node_id\":\"R_kgDOG-InCQ\",\"open_issues\":0,\"has_downloads\":true,\"merge_commit_message\":\"PR_TITLE\",\"squash_merge_commit_message\":\"COMMIT_MESSAGES\",\"events_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/events\",\"ssh_url\":\"git@github.com:zot/examplebranchsubdir.jl.git\",\"issue_comment_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/issues/comments{/number}\",\"compare_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/compare/{base}...{head}\",\"git_tags_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/git/tags{/sha}\",\"temp_clone_token\":\"\",\"forks_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/forks\",\"subscribers_count\":1,\"archive_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/{archive_format}{/ref}\",\"languages_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/languages\",\"web_commit_signoff_required\":false,\"stargazers_count\":0,\"deployments_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/deployments\",\"trees_url\":\"https://api.github.com/repos/zot/examplebranchsubdir.jl/git/trees{/sha}\"}",
    GitLab.User => "{\"is_followed\":false,\"theme_id\":1,\"location\":null,\"confirmed_at\":\"2018-08-25T12:57:20.160Z\",\"created_at\":\"2018-08-25T12:57:20.440Z\",\"state\":\"active\",\"followers\":0,\"private_profile\":false,\"can_create_project\":true,\"website_url\":\"\",\"can_create_group\":true,\"commit_email\":\"bill.burdick@gmail.com\",\"identities\":[{\"provider\":\"github\",\"saml_provider_id\":null,\"extern_uid\":\"26665\"}],\"projects_limit\":100000,\"shared_runners_minutes_limit\":null,\"linkedin\":\"\",\"bot\":false,\"job_title\":\"\",\"following\":0,\"pronouns\":null,\"color_scheme_id\":1,\"external\":false,\"work_information\":null,\"extra_shared_runners_minutes_limit\":null,\"web_url\":\"https://gitlab.com/zot1\",\"name\":\"Bill Burdick\",\"bio\":\"\",\"last_activity_on\":\"2022-09-23\",\"email\":\"bill.burdick@gmail.com\",\"organization\":null,\"username\":\"zot1\",\"two_factor_enabled\":false,\"avatar_url\":\"https://secure.gravatar.com/avatar/5ad6635635270fd81ab229ece9b2d2a0?s=80&d=identicon\",\"local_time\":\"6:55 AM\",\"id\":2742710,\"skype\":\"\",\"public_email\":\"\",\"current_sign_in_at\":\"2022-09-22T07:18:43.706Z\",\"last_sign_in_at\":\"2022-08-02T17:40:49.238Z\",\"twitter\":\"\"}",
    GitLab.Project => "{\"id\":34333070,\"description\":\"\",\"name\":\"ExampleBranchSubdir.jl\",\"name_with_namespace\":\"Bill Burdick / ExampleBranchSubdir.jl\",\"path\":\"ExampleBranchSubdir.jl\",\"path_with_namespace\":\"zot1/ExampleBranchSubdir.jl\",\"created_at\":\"2022-03-09T07:30:26.467Z\",\"default_branch\":\"master\",\"tag_list\":[],\"topics\":[],\"ssh_url_to_repo\":\"git@gitlab.com:zot1/ExampleBranchSubdir.jl.git\",\"http_url_to_repo\":\"https://gitlab.com/zot1/ExampleBranchSubdir.jl.git\",\"web_url\":\"https://gitlab.com/zot1/ExampleBranchSubdir.jl\",\"readme_url\":null,\"avatar_url\":null,\"forks_count\":1,\"star_count\":0,\"last_activity_at\":\"2022-03-29T21:40:37.298Z\",\"namespace\":{\"id\":3495260,\"name\":\"Bill Burdick\",\"path\":\"zot1\",\"kind\":\"user\",\"full_path\":\"zot1\",\"parent_id\":null,\"avatar_url\":\"https://secure.gravatar.com/avatar/5ad6635635270fd81ab229ece9b2d2a0?s=80\\u0026d=identicon\",\"web_url\":\"https://gitlab.com/zot1\"},\"container_registry_image_prefix\":\"registry.gitlab.com/zot1/examplebranchsubdir.jl\",\"_links\":{\"self\":\"https://gitlab.com/api/v4/projects/34333070\",\"issues\":\"https://gitlab.com/api/v4/projects/34333070/issues\",\"merge_requests\":\"https://gitlab.com/api/v4/projects/34333070/merge_requests\",\"repo_branches\":\"https://gitlab.com/api/v4/projects/34333070/repository/branches\",\"labels\":\"https://gitlab.com/api/v4/projects/34333070/labels\",\"events\":\"https://gitlab.com/api/v4/projects/34333070/events\",\"members\":\"https://gitlab.com/api/v4/projects/34333070/members\",\"cluster_agents\":\"https://gitlab.com/api/v4/projects/34333070/cluster_agents\"},\"packages_enabled\":true,\"empty_repo\":false,\"archived\":false,\"visibility\":\"public\",\"owner\":{\"id\":2742710,\"username\":\"zot1\",\"name\":\"Bill Burdick\",\"state\":\"active\",\"avatar_url\":\"https://secure.gravatar.com/avatar/5ad6635635270fd81ab229ece9b2d2a0?s=80\\u0026d=identicon\",\"web_url\":\"https://gitlab.com/zot1\"},\"resolve_outdated_diff_discussions\":false,\"container_expiration_policy\":{\"cadence\":\"1d\",\"enabled\":false,\"keep_n\":10,\"older_than\":\"90d\",\"name_regex\":\".*\",\"name_regex_keep\":null,\"next_run_at\":\"2022-03-10T07:30:26.514Z\"},\"issues_enabled\":true,\"merge_requests_enabled\":true,\"wiki_enabled\":true,\"jobs_enabled\":true,\"snippets_enabled\":true,\"container_registry_enabled\":true,\"service_desk_enabled\":true,\"service_desk_address\":\"contact-project+zot1-examplebranchsubdir-jl-34333070-issue-@incoming.gitlab.com\",\"can_create_merge_request_in\":true,\"issues_access_level\":\"enabled\",\"repository_access_level\":\"enabled\",\"merge_requests_access_level\":\"enabled\",\"forking_access_level\":\"enabled\",\"wiki_access_level\":\"enabled\",\"builds_access_level\":\"enabled\",\"snippets_access_level\":\"enabled\",\"pages_access_level\":\"enabled\",\"operations_access_level\":\"enabled\",\"analytics_access_level\":\"enabled\",\"container_registry_access_level\":\"enabled\",\"security_and_compliance_access_level\":\"private\",\"emails_disabled\":null,\"shared_runners_enabled\":true,\"lfs_enabled\":true,\"creator_id\":2742710,\"import_url\":\"https://bitbucket.org/zot-julia/examplebranchsubdir.jl.git\",\"import_type\":\"bitbucket\",\"import_status\":\"finished\",\"import_error\":null,\"open_issues_count\":0,\"runners_token\":\"GR1348941BXpcpX3ysWGvAD3ZnN1e\",\"ci_default_git_depth\":20,\"ci_forward_deployment_enabled\":true,\"ci_job_token_scope_enabled\":false,\"ci_separated_caches\":true,\"ci_opt_in_jwt\":false,\"ci_allow_fork_pipelines_to_run_in_parent_project\":true,\"public_jobs\":true,\"build_git_strategy\":\"fetch\",\"build_timeout\":3600,\"auto_cancel_pending_pipelines\":\"enabled\",\"ci_config_path\":\"\",\"shared_with_groups\":[],\"only_allow_merge_if_pipeline_succeeds\":false,\"allow_merge_on_skipped_pipeline\":null,\"restrict_user_defined_variables\":false,\"request_access_enabled\":true,\"only_allow_merge_if_all_discussions_are_resolved\":false,\"remove_source_branch_after_merge\":true,\"printing_merge_request_link_enabled\":true,\"merge_method\":\"merge\",\"squash_option\":\"default_off\",\"enforce_auth_checks_on_uploads\":true,\"suggestion_commit_message\":null,\"merge_commit_template\":null,\"squash_commit_template\":null,\"auto_devops_enabled\":false,\"auto_devops_deploy_strategy\":\"continuous\",\"autoclose_referenced_issues\":true,\"keep_latest_artifact\":true,\"runner_token_expiration_interval\":null,\"external_authorization_classification_label\":\"\",\"requirements_enabled\":false,\"requirements_access_level\":\"enabled\",\"security_and_compliance_enabled\":true,\"compliance_frameworks\":[],\"permissions\":{\"project_access\":{\"access_level\":50,\"notification_level\":3},\"group_access\":null}}",
    Bitbucket.Repo => "{\"type\": \"repository\", \"full_name\": \"wrburdick/example.jl\", \"links\": {\"self\": {\"href\": \"https://api.bitbucket.org/2.0/repositories/wrburdick/example.jl\"}, \"html\": {\"href\": \"https://bitbucket.org/wrburdick/example.jl\"}, \"avatar\": {\"href\": \"https://bytebucket.org/ravatar/%7Bbb41ce36-a601-40ab-988c-3b4a37598e8f%7D?ts=default\"}, \"pullrequests\": {\"href\": \"https://api.bitbucket.org/2.0/repositories/wrburdick/example.jl/pullrequests\"}, \"commits\": {\"href\": \"https://api.bitbucket.org/2.0/repositories/wrburdick/example.jl/commits\"}, \"forks\": {\"href\": \"https://api.bitbucket.org/2.0/repositories/wrburdick/example.jl/forks\"}, \"watchers\": {\"href\": \"https://api.bitbucket.org/2.0/repositories/wrburdick/example.jl/watchers\"}, \"branches\": {\"href\": \"https://api.bitbucket.org/2.0/repositories/wrburdick/example.jl/refs/branches\"}, \"tags\": {\"href\": \"https://api.bitbucket.org/2.0/repositories/wrburdick/example.jl/refs/tags\"}, \"downloads\": {\"href\": \"https://api.bitbucket.org/2.0/repositories/wrburdick/example.jl/downloads\"}, \"source\": {\"href\": \"https://api.bitbucket.org/2.0/repositories/wrburdick/example.jl/src\"}, \"clone\": [{\"name\": \"https\", \"href\": \"https://wrburdick@bitbucket.org/wrburdick/example.jl.git\"}, {\"name\": \"ssh\", \"href\": \"git@bitbucket.org:wrburdick/example.jl.git\"}], \"hooks\": {\"href\": \"https://api.bitbucket.org/2.0/repositories/wrburdick/example.jl/hooks\"}}, \"name\": \"Example.jl\", \"slug\": \"example.jl\", \"description\": \"\", \"scm\": \"git\", \"website\": null, \"owner\": {\"display_name\": \"wrburdick\", \"links\": {\"self\": {\"href\": \"https://api.bitbucket.org/2.0/users/%7Bbaa4b755-09fc-44d1-b6c6-894cdd9bbe32%7D\"}, \"avatar\": {\"href\": \"https://secure.gravatar.com/avatar/5ad6635635270fd81ab229ece9b2d2a0?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FW-5.png\"}, \"html\": {\"href\": \"https://bitbucket.org/%7Bbaa4b755-09fc-44d1-b6c6-894cdd9bbe32%7D/\"}}, \"type\": \"user\", \"uuid\": \"{baa4b755-09fc-44d1-b6c6-894cdd9bbe32}\", \"account_id\": \"5ac0edc1b7687c3f7e5e8a57\", \"nickname\": \"wrburdick\"}, \"workspace\": {\"type\": \"workspace\", \"uuid\": \"{baa4b755-09fc-44d1-b6c6-894cdd9bbe32}\", \"name\": \"wrburdick\", \"slug\": \"wrburdick\", \"links\": {\"avatar\": {\"href\": \"https://bitbucket.org/workspaces/wrburdick/avatar/?ts=1543700346\"}, \"html\": {\"href\": \"https://bitbucket.org/wrburdick/\"}, \"self\": {\"href\": \"https://api.bitbucket.org/2.0/workspaces/wrburdick\"}}}, \"is_private\": false, \"project\": {\"type\": \"project\", \"key\": \"JUL3\", \"uuid\": \"{4afe0de1-1b45-4075-9cb9-378551b1299a}\", \"name\": \"Julia\", \"links\": {\"self\": {\"href\": \"https://api.bitbucket.org/2.0/workspaces/wrburdick/projects/JUL3\"}, \"html\": {\"href\": \"https://bitbucket.org/wrburdick/workspace/projects/JUL3\"}, \"avatar\": {\"href\": \"https://bitbucket.org/account/user/wrburdick/projects/JUL3/avatar/32?ts=1646463647\"}}}, \"fork_policy\": \"allow_forks\", \"created_on\": \"2022-01-17T16:21:42.416498+00:00\", \"updated_on\": \"2022-01-17T17:10:27.581218+00:00\", \"size\": 309449, \"language\": \"\", \"has_issues\": false, \"has_wiki\": false, \"uuid\": \"{bb41ce36-a601-40ab-988c-3b4a37598e8f}\", \"mainbranch\": {\"name\": \"master\", \"type\": \"branch\"}, \"override_settings\": {\"default_merge_strategy\": false, \"branching_model\": false}}",
    Bitbucket.Commit => "{\"participants\":[],\"parents\":[{\"links\":{\"self\":{\"href\":\"https://api.bitbucket.org/2.0/repositories/wrburdick/example.jl/commit/d29ad46e7f17df304388024a2041bde4fcbbc819\"},\"html\":{\"href\":\"https://bitbucket.org/wrburdick/example.jl/commits/d29ad46e7f17df304388024a2041bde4fcbbc819\"}},\"hash\":\"d29ad46e7f17df304388024a2041bde4fcbbc819\",\"type\":\"commit\"}],\"author\":{\"raw\":\"Dilum Aluthge <dilum@aluthge.com>\",\"type\":\"author\",\"user\":{\"links\":{\"self\":{\"href\":\"https://api.bitbucket.org/2.0/users/%7B7dc90380-f131-43f7-b7c1-5aad8f0537c6%7D\"},\"html\":{\"href\":\"https://bitbucket.org/%7B7dc90380-f131-43f7-b7c1-5aad8f0537c6%7D/\"},\"avatar\":{\"href\":\"https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/557058:985818f4-2fb5-4d9e-a7b2-1125d0013f8a/1fd6ad00-0bba-426e-b522-b7f0f7c4590f/128\"}},\"account_id\":\"557058:985818f4-2fb5-4d9e-a7b2-1125d0013f8a\",\"uuid\":\"{7dc90380-f131-43f7-b7c1-5aad8f0537c6}\",\"display_name\":\"Dilum Aluthge\",\"nickname\":\"dilumaluthge\",\"type\":\"user\"}},\"repository\":{\"name\":\"Example.jl\",\"links\":{\"self\":{\"href\":\"https://api.bitbucket.org/2.0/repositories/wrburdick/example.jl\"},\"html\":{\"href\":\"https://bitbucket.org/wrburdick/example.jl\"},\"avatar\":{\"href\":\"https://bytebucket.org/ravatar/%7Bbb41ce36-a601-40ab-988c-3b4a37598e8f%7D?ts=default\"}},\"uuid\":\"{bb41ce36-a601-40ab-988c-3b4a37598e8f}\",\"full_name\":\"wrburdick/example.jl\",\"type\":\"repository\"},\"links\":{\"statuses\":{\"href\":\"https://api.bitbucket.org/2.0/repositories/wrburdick/example.jl/commit/9f288cc4864dbfc2c82338caac0b1eb1fc7ff87f/statuses\"},\"patch\":{\"href\":\"https://api.bitbucket.org/2.0/repositories/wrburdick/example.jl/patch/9f288cc4864dbfc2c82338caac0b1eb1fc7ff87f\"},\"self\":{\"href\":\"https://api.bitbucket.org/2.0/repositories/wrburdick/example.jl/commit/9f288cc4864dbfc2c82338caac0b1eb1fc7ff87f\"},\"approve\":{\"href\":\"https://api.bitbucket.org/2.0/repositories/wrburdick/example.jl/commit/9f288cc4864dbfc2c82338caac0b1eb1fc7ff87f/approve\"},\"html\":{\"href\":\"https://bitbucket.org/wrburdick/example.jl/commits/9f288cc4864dbfc2c82338caac0b1eb1fc7ff87f\"},\"diff\":{\"href\":\"https://api.bitbucket.org/2.0/repositories/wrburdick/example.jl/diff/9f288cc4864dbfc2c82338caac0b1eb1fc7ff87f\"},\"comments\":{\"href\":\"https://api.bitbucket.org/2.0/repositories/wrburdick/example.jl/commit/9f288cc4864dbfc2c82338caac0b1eb1fc7ff87f/comments\"}},\"type\":\"commit\",\"message\":\"Fix whitespace in `Project.toml` to match the way that Pkg prints it out (#61)\\n\\n\",\"rendered\":{\"message\":{\"raw\":\"Fix whitespace in `Project.toml` to match the way that Pkg prints it out (#61)\\n\\n\",\"html\":\"<p>Fix whitespace in <code>Project.toml</code> to match the way that Pkg prints it out (#61)</p>\",\"markup\":\"markdown\",\"type\":\"rendered\"}},\"summary\":{\"raw\":\"Fix whitespace in `Project.toml` to match the way that Pkg prints it out (#61)\\n\\n\",\"html\":\"<p>Fix whitespace in <code>Project.toml</code> to match the way that Pkg prints it out (#61)</p>\",\"markup\":\"markdown\",\"type\":\"rendered\"},\"hash\":\"9f288cc4864dbfc2c82338caac0b1eb1fc7ff87f\",\"date\":\"2021-05-22T00:44:36+00:00\"}",
]

@testset "encoding" begin
    for (type, json) in ENCODING_SAMPLES
        ob1 = JSON3.read(json, type)
        @test typeof(ob1) == type
        ob2 = JSON3.read(JSON3.write(ob1), type)
        @test ob1 == ob2
    end
end
