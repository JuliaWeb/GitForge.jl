var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": "CurrentModule = GitForge"
},

{
    "location": "#GitForge.Forge",
    "page": "Home",
    "title": "GitForge.Forge",
    "category": "type",
    "text": "A forge is an online platform for Git repositories. The most common example is GitHub.\n\nForge subtypes can access their respective web APIs.\n\n\n\n\n\n"
},

{
    "location": "#GitForge-1",
    "page": "Home",
    "title": "GitForge",
    "category": "section",
    "text": "(Image: Build Status)GitForge.jl is a unified interface for interacting with Git \"forges\".Forge"
},

{
    "location": "#Supported-Forges-1",
    "page": "Home",
    "title": "Supported Forges",
    "category": "section",
    "text": ""
},

{
    "location": "#GitForge.GitHub.GitHubAPI",
    "page": "Home",
    "title": "GitForge.GitHub.GitHubAPI",
    "category": "type",
    "text": "GitHubAPI(;\n    token::AbstractToken=NoToken(),\n    url::AbstractString=\"https://api.github.com\",\n    has_rate_limits::Bool=true,\n    on_rate_limit::OnRateLimit=ORL_RETURN,\n) -> GitHubAPI\n\nCreate a GitHub API client.\n\nKeywords\n\ntoken::AbstractToken=NoToken(): Authorization token (or lack thereof).\nurl::AbstractString=\"https://api.github.com\": Base URL of the target GitHub instance.\nhas_rate_limits::Bool=true: Whether or not the GitHub server has rate limits.\non_rate_limit::OnRateLimit=ORL_RETURN: Behaviour on exceeded rate limits.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.GitHub.NoToken",
    "page": "Home",
    "title": "GitForge.GitHub.NoToken",
    "category": "type",
    "text": "NoToken() -> NoToken\n\nRepresents no authentication. Only public data will be available.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.GitHub.Token",
    "page": "Home",
    "title": "GitForge.GitHub.Token",
    "category": "type",
    "text": "Token(token::AbstractString) -> Token\n\nAn OAuth2 token, or a personal access token.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.GitHub.JWT",
    "page": "Home",
    "title": "GitForge.GitHub.JWT",
    "category": "type",
    "text": "A JWT signed by a private key for GitHub Apps.\n\n\n\n\n\n"
},

{
    "location": "#GitHub-1",
    "page": "Home",
    "title": "GitHub",
    "category": "section",
    "text": "GitHub.GitHubAPI\nGitHub.NoToken\nGitHub.Token\nGitHub.JWT"
},

{
    "location": "#GitForge.GitLab.GitLabAPI",
    "page": "Home",
    "title": "GitForge.GitLab.GitLabAPI",
    "category": "type",
    "text": "GitLabAPI(;\n    token::AbstractToken=NoToken(),\n    url::AbstractString=\"https://gitlab.com/api/v4\",\n    has_rate_limits::Bool=true,\n    on_rate_limit::OnRateLimit=ORL_RETURN,\n) -> GitLabAPI\n\nCreate a GitLab API client.\n\nKeywords\n\ntoken::AbstractToken=NoToken(): Authorization token (or lack thereof).\nurl::AbstractString\"https://gitlab.com/api/v4\": Base URL of the target GitLab instance.\nhas_rate_limits::Bool=true: Whether or not the GitLab server has rate limits.\non_rate_limit::OnRateLimit=ORL_RETURN: Behaviour on exceeded rate limits.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.GitLab.NoToken",
    "page": "Home",
    "title": "GitForge.GitLab.NoToken",
    "category": "type",
    "text": "NoToken() -> NoToken\n\nRepresents no authentication. Only public data will be available.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.GitLab.OAuth2Token",
    "page": "Home",
    "title": "GitForge.GitLab.OAuth2Token",
    "category": "type",
    "text": "OAuth2Token(token::AbstractString) -> OAuth2Token\n\nAn OAuth2 bearer token.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.GitLab.PersonalAccessToken",
    "page": "Home",
    "title": "GitForge.GitLab.PersonalAccessToken",
    "category": "type",
    "text": "PersonalAccessToken(token::AbstractString) -> PersonalAccessToken\n\nA private access token.\n\n\n\n\n\n"
},

{
    "location": "#GitLab-1",
    "page": "Home",
    "title": "GitLab",
    "category": "section",
    "text": "GitLab.GitLabAPI\nGitLab.NoToken\nGitLab.OAuth2Token\nGitLab.PersonalAccessToken"
},

{
    "location": "#API-1",
    "page": "Home",
    "title": "API",
    "category": "section",
    "text": ""
},

{
    "location": "#GitForge.Result",
    "page": "Home",
    "title": "GitForge.Result",
    "category": "type",
    "text": "A Result{T} is returned from every API function. It encapsulates the value, HTTP response, and thrown exception of the call.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.value",
    "page": "Home",
    "title": "GitForge.value",
    "category": "function",
    "text": "value(::Result{T}) -> Union{T, Nothing}\n\nReturns the result\'s value, if any exists.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.response",
    "page": "Home",
    "title": "GitForge.response",
    "category": "function",
    "text": "response(::Result) -> Union{HTTP.Response, Nothing}\n\nReturns the result\'s HTTP response, if any exists.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.exception",
    "page": "Home",
    "title": "GitForge.exception",
    "category": "function",
    "text": "exception(::Result{T}) -> Union{Tuple{Exception, Vector{StackFrame}}, Nothing}\n\nReturns the result\'s thrown exception and stack trace, if any exists.\n\n\n\n\n\n"
},

{
    "location": "#Results-1",
    "page": "Home",
    "title": "Results",
    "category": "section",
    "text": "Result\nvalue\nresponse\nexception"
},

{
    "location": "#GitForge.@paginate",
    "page": "Home",
    "title": "GitForge.@paginate",
    "category": "macro",
    "text": "@paginate fun(args...; kwargs...) page=1 per_page=100 -> Paginator\n\nCreate an iterator that paginates the results of repeatedly calling fun(args...; kwargs...). fun must take a Forge as its first argument and return a Result{Vector{T}}.\n\nKeywords\n\npage::Int=1: Starting page.\nper_page::Int=100: Number of entries per page.\n\n\n\n\n\n"
},

{
    "location": "#Pagination-1",
    "page": "Home",
    "title": "Pagination",
    "category": "section",
    "text": "@paginate"
},

{
    "location": "#GitForge.get_user",
    "page": "Home",
    "title": "GitForge.get_user",
    "category": "function",
    "text": "get_user(::Forge[, name_or_id::Union{AbstractString, Integer}])\n\nGet the currently authenticated user, or a user by name or ID.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.get_users",
    "page": "Home",
    "title": "GitForge.get_users",
    "category": "function",
    "text": "get_users(::Forge)\n\nGet all users.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.update_user",
    "page": "Home",
    "title": "GitForge.update_user",
    "category": "function",
    "text": "update_user(::Forge[, id::Integer]; kwargs...)\n\nUpdate the currently authenticated user, or a user by ID.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.create_user",
    "page": "Home",
    "title": "GitForge.create_user",
    "category": "function",
    "text": "create_user(::Forge; kwargs...)\n\nCreate a new user.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.delete_user",
    "page": "Home",
    "title": "GitForge.delete_user",
    "category": "function",
    "text": "delete_user(::Forge, id::Integer)\n\nDelete a user by ID.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.get_user_repos",
    "page": "Home",
    "title": "GitForge.get_user_repos",
    "category": "function",
    "text": "get_user_repos(::Forge[, name_or_id::Union{AbstractString, Integer}])\n\nGet the currently authenticated user\'s repositories, or those of a user by name or ID.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.get_repo",
    "page": "Home",
    "title": "GitForge.get_repo",
    "category": "function",
    "text": "get_repo(::Forge, owner::AbstractString, repo::AbstractString)\nget_repo(::Forge, id::Integer)\n\nGet a repository by owner and name or ID.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.get_branch",
    "page": "Home",
    "title": "GitForge.get_branch",
    "category": "function",
    "text": "get_branch(::Forge, owner::AbstractString, repo::AbstractString, branch::AbstractString)\n\nGet a branch from a repository.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.get_file_contents",
    "page": "Home",
    "title": "GitForge.get_file_contents",
    "category": "function",
    "text": "get_file_contents(\n    ::Forge,\n    owner::AbstractString,\n    repo::AbstractString,\n    path::AbstractString,\n)\nget_file_contents(f::Forge, id::Integer, path::AbstractString)\n\nGet a file from a repository.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.get_pull_request",
    "page": "Home",
    "title": "GitForge.get_pull_request",
    "category": "function",
    "text": "get_pull_request(::Forge, owner::AbstractString, repo::AbstractString, number::Integer)\nget_pull_request(::Forge, project::Integer, number::Integer)\n\nGet a specific pull request.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.get_pull_requests",
    "page": "Home",
    "title": "GitForge.get_pull_requests",
    "category": "function",
    "text": "get_pull_requests(::Forge, owner::AbstractString, repo::AbstractString)\nget_pull_requests(::Forge, project::Integer)\n\nList a repository\'s pull requests.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.create_pull_request",
    "page": "Home",
    "title": "GitForge.create_pull_request",
    "category": "function",
    "text": "create_pull_requests(::Forge, owner::AbstractString, repo::AbstractString; kwargs...)\ncreate_pull_requests(::Forge, project::Integer; kwargs...)\n\nCreate a pull request.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.get_commit",
    "page": "Home",
    "title": "GitForge.get_commit",
    "category": "function",
    "text": "get_commit(::Forge, owner::AbstractString, repo::AbstractString, ref::AbstractString)\nget_commit(::Forge, project::Integer, ref::AbstractString)\n\nGet a commit from a repository.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.get_tags",
    "page": "Home",
    "title": "GitForge.get_tags",
    "category": "function",
    "text": "get_tags(::Forge, owner::AbstractString, repo::AbstractString)\nget_tags(::Forge, project::Integer)\n\nGet a list of tags from a repository.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.is_collaborator",
    "page": "Home",
    "title": "GitForge.is_collaborator",
    "category": "function",
    "text": "is_collaborator(\n    ::Forge,\n    owner::AbstractString,\n    repo::AbstractString,\n    name_or_id::Union{AbstractString, Integer},\n)\n\nCheck whether or not a user is a collaborator on a repository.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.is_member",
    "page": "Home",
    "title": "GitForge.is_member",
    "category": "function",
    "text": "is_member(::Forge, org::AbstractString, name_or_id::Union{AbstractString, Integer})\n\nCheck whether or not a user is a member of an organization.\n\n\n\n\n\n"
},

{
    "location": "#Endpoints-1",
    "page": "Home",
    "title": "Endpoints",
    "category": "section",
    "text": "These functions all allow any number of trailing keywords. For more information on these keywords, see request.get_user\nget_users\nupdate_user\ncreate_user\ndelete_user\nget_user_repos\nget_repo\nget_branch\nget_file_contents\nget_pull_request\nget_pull_requests\ncreate_pull_request\nget_commit\nget_tags\nis_collaborator\nis_member"
},

{
    "location": "#Internals-1",
    "page": "Home",
    "title": "Internals",
    "category": "section",
    "text": "The following resources are useful for implementing new forges, or customizing behaviour.Many functions take a Function argument, which can be used to limit the affected API functions. To make a method specific to a single function, use ::typeof(fun)."
},

{
    "location": "#GitForge.base_url",
    "page": "Home",
    "title": "GitForge.base_url",
    "category": "function",
    "text": "base_url(::Forge) -> String\n\nReturns the base URL of all API endpoints.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.endpoint",
    "page": "Home",
    "title": "GitForge.endpoint",
    "category": "function",
    "text": "endpoint(::Forge, ::Function, args...) -> Endpoint\n\nReturns an Endpoint for a given function. Trailing arguments are usually important for routing. For example, get_user can take some ID parameter which becomes part of the URL.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.Endpoint",
    "page": "Home",
    "title": "GitForge.Endpoint",
    "category": "type",
    "text": "Endpoint(\n    method::Symbol,\n    url::AbstractString;\n    headers::Vector{<:Pair}=HTTP.Header[],\n    query::Dict=Dict(),\n    allow_404::Bool=false,\n) -> Endpoint\n\nContains information on how to call an endpoint.\n\nArguments\n\nmethod::Symbol: HTTP request method to use.\nurl::AbstractString: Endpoint URL, relative to the base URL.\n\nKeywords\n\nheaders::Vector{<:Pair}=HTTP.Header[]: Request headers to add.\nquery::Dict=Dict(): Query string parameters to add.\nallow_404::Bool=false: Sends responses  with 404 statuses to the postprocessor.\n\n\n\n\n\n"
},

{
    "location": "#URLs-1",
    "page": "Home",
    "title": "URLs",
    "category": "section",
    "text": "These functions set request URLs. To determine the full URL for a given request, they are concatenated together.base_url\nendpoint\nEndpoint"
},

{
    "location": "#GitForge.request_headers",
    "page": "Home",
    "title": "GitForge.request_headers",
    "category": "function",
    "text": "request_headers(::Forge, ::Function) -> Vector{Pair}\n\nReturns the headers that should be added to each request.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.request_query",
    "page": "Home",
    "title": "GitForge.request_query",
    "category": "function",
    "text": "request_query(::Forge, ::Function) -> Dict\n\nReturns the query string parameters that should be added to each request.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.request_kwargs",
    "page": "Home",
    "title": "GitForge.request_kwargs",
    "category": "function",
    "text": "request_kwargs(::Forge, ::Function) -> Dict{Symbol}\n\nReturns the extra keyword arguments that should be passed to HTTP.request.\n\n\n\n\n\n"
},

{
    "location": "#Request-Options-1",
    "page": "Home",
    "title": "Request Options",
    "category": "section",
    "text": "These functions set parts of HTTP requests.request_headers\nrequest_query\nrequest_kwargs"
},

{
    "location": "#GitForge.request",
    "page": "Home",
    "title": "GitForge.request",
    "category": "function",
    "text": "request(\n    f::Forge, fun::Function, ep::Endpoint;\n    headers::Vector{<:Pair}=HTTP.Header[],\n    query::AbstractDict=Dict(),\n    request_opts=Dict(),\n    kwargs...,\n) -> Result{T}\n\nMake an HTTP request and return a Result. T is determined by into.\n\nArguments\n\nf::Forge A Forge subtype.\nfun::Function: The API function being called.\nep::Endpoint: The endpoint information.\n\nKeywords\n\nquery::AbstractDict=Dict(): Query string parameters to add to the request.\nheaders::Vector{<:Pair}=HTTP.Header[]: Headers to add to the request.\nrequest_opts=Dict(): Keywords passed into HTTP.request.\n\nTrailing keywords are sent as a JSON body for PATCH, POST, and PUT requests. For other request types, the keywords are sent as query string parameters.\n\nnote: Note\nEvery API function passes its keyword arguments into this function. Therefore, to customize behaviour for a single request, pass the above keywords to the API function.\n\n\n\n\n\n"
},

{
    "location": "#Requests-1",
    "page": "Home",
    "title": "Requests",
    "category": "section",
    "text": "This function makes the actual HTTP requests.request"
},

{
    "location": "#GitForge.RateLimiter",
    "page": "Home",
    "title": "GitForge.RateLimiter",
    "category": "type",
    "text": "A generic rate limiter using the [X-]RateLimit-Remaining and [X-]RateLimit-Reset response headers. The reset header is assumed to be a Unix timestamp in seconds.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.OnRateLimit",
    "page": "Home",
    "title": "GitForge.OnRateLimit",
    "category": "type",
    "text": "Determines how to react to an exceeded rate limit.\n\nORL_RETURN: Return a Result containing a RateLimited exception.\nORL_WAIT: Block and wait for the rate limit to expire.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.RateLimited",
    "page": "Home",
    "title": "GitForge.RateLimited",
    "category": "type",
    "text": "A signal that a rate limit has been exceeded. Can contain the amount of time until its expiry.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.has_rate_limits",
    "page": "Home",
    "title": "GitForge.has_rate_limits",
    "category": "function",
    "text": "has_rate_limits(::Forge, ::Function) -> Bool\n\nReturns whether or not the forge server uses rate limiting.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.rate_limit_check",
    "page": "Home",
    "title": "GitForge.rate_limit_check",
    "category": "function",
    "text": "rate_limit_check(::Forge, ::Function) -> Bool\n\nReturns whether or not there is an active rate limit. If one is found, on_rate_limit is called to determine how to react.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.on_rate_limit",
    "page": "Home",
    "title": "GitForge.on_rate_limit",
    "category": "function",
    "text": "on_rate_limit(::Forge, ::Function) -> OnRateLimit\n\nReturns an OnRateLimit that determines how to react to an exceeded rate limit.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.rate_limit_wait",
    "page": "Home",
    "title": "GitForge.rate_limit_wait",
    "category": "function",
    "text": "rate_limit_wait(::Forge, ::Function)\n\nWait for a rate limit to expire.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.rate_limit_period",
    "page": "Home",
    "title": "GitForge.rate_limit_period",
    "category": "function",
    "text": "rate_limit_period(::Forge, ::Function) -> Period\n\nCompute the amount of time until a rate limit expires.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.rate_limit_update!",
    "page": "Home",
    "title": "GitForge.rate_limit_update!",
    "category": "function",
    "text": "rate_limit_update!(::Forge, ::Function, ::HTTP.Response)\n\nUpdate the rate limiter with a new response.\n\n\n\n\n\n"
},

{
    "location": "#Rate-Limiting-1",
    "page": "Home",
    "title": "Rate Limiting",
    "category": "section",
    "text": "These functions and types handle certain generic rate limiters.RateLimiter\nOnRateLimit\nRateLimited\nhas_rate_limits\nrate_limit_check\non_rate_limit\nrate_limit_wait\nrate_limit_period\nrate_limit_update!"
},

{
    "location": "#GitForge.postprocessor",
    "page": "Home",
    "title": "GitForge.postprocessor",
    "category": "function",
    "text": "postprocessor(::Forge, ::Function) -> PostProcessor\n\nReturns the PostProcessor to be used.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.into",
    "page": "Home",
    "title": "GitForge.into",
    "category": "function",
    "text": "into(::Forge, ::Function) -> Type\n\nReturns the type that the PostProcessor should create from the response.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.PostProcessor",
    "page": "Home",
    "title": "GitForge.PostProcessor",
    "category": "type",
    "text": "Determines the behaviour of postprocess.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.postprocess",
    "page": "Home",
    "title": "GitForge.postprocess",
    "category": "function",
    "text": "postprocess(::PostProcessor, ::HTTP.Response, ::Type{T})\n\nComputes a value from an HTTP response. This is what is returned by value.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.DoNothing",
    "page": "Home",
    "title": "GitForge.DoNothing",
    "category": "type",
    "text": "Does nothing and always returns nothing.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.DoSomething",
    "page": "Home",
    "title": "GitForge.DoSomething",
    "category": "type",
    "text": "DoSomething(::Function) -> DoSomething\n\nRuns a user-defined postprocessor.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.JSON",
    "page": "Home",
    "title": "GitForge.JSON",
    "category": "type",
    "text": "JSON(f::Function=identity) -> JSON\n\nParses a JSON response into a given type and runs f on that object.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.@json",
    "page": "Home",
    "title": "GitForge.@json",
    "category": "macro",
    "text": "@json struct T ... end\n\nCreate a type that can be parsed from JSON.\n\n\n\n\n\n"
},

{
    "location": "#Post-Processing-1",
    "page": "Home",
    "title": "Post Processing",
    "category": "section",
    "text": "These functions and types process HTTP responses.postprocessor\ninto\nPostProcessor\npostprocess\nDoNothing\nDoSomething\nJSON\n@json"
},

]}
