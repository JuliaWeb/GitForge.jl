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
    "text": "GitHubAPI(;\n    token::AbstractToken=NoToken(),\n    url::AbstractString=\"https://api.github.com\",\n    on_rate_limit::OnRateLimit=ORL_RETURN,\n) -> GitHubAPI\n\nCreate a GitHub API client.\n\nKeywords\n\ntoken::AbstractToken=NoToken(): Authorization token (or lack thereof).\nurl::AbstractString=\"https://api.github.com\": Base URL of the target GitHub instance.\non_rate_limit::OnRateLimit=ORL_RETURN: Behaviour on exceeded rate limits.\n\n\n\n\n\n"
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
    "text": "GitLabAPI(;\n    token::AbstractToken=NoToken(),\n    url::AbstractString=\"https://gitlab.com/api/v4\",\n    on_rate_limit::OnRateLimit=ORL_RETURN,\n) -> GitLabAPI\n\nCreate a GitLab API client.\n\nKeywords\n\ntoken::AbstractToken=NoToken(): Authorization token (or lack thereof).\nurl::AbstractString=\"https://gitlab.com/api/v4\": Base URL of the target GitLab instance.\non_rate_limit::OnRateLimit=ORL_RETURN: Behaviour on exceeded rate limits.\n\n\n\n\n\n"
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
    "text": "A Result{T, E<:Exception} is returned from every API function. It encapsulates the value, HTTP response, and thrown exception of the call.\n\n\n\n\n\n"
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
    "text": "exception(::Result{T, E<:Exception}) -> Union{E, Nothing}\n\nReturns the result\'s thrown exception, if any exists.\n\n\n\n\n\n"
},

{
    "location": "#Results-1",
    "page": "Home",
    "title": "Results",
    "category": "section",
    "text": "Result\nvalue\nresponse\nexception"
},

{
    "location": "#GitForge.paginate",
    "page": "Home",
    "title": "GitForge.paginate",
    "category": "function",
    "text": "paginate(fun::Function, f::Forge, args...; kwargs...) -> Paginator\n\nCreate an iterator that paginates the results of repeatedly calling fun(f, args...; kwargs...). fun must return Result{Vector{T}}.\n\n\n\n\n\n"
},

{
    "location": "#Pagination-1",
    "page": "Home",
    "title": "Pagination",
    "category": "section",
    "text": "paginate"
},

{
    "location": "#GitForge.get_user",
    "page": "Home",
    "title": "GitForge.get_user",
    "category": "function",
    "text": "get_user(::Forge)\n\nGet the currently authenticated user.\n\n\n\n\n\nget_user(::Forge, name_or_id::Union{AbstractString, Integer})\n\nGet a user by name or ID.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.get_users",
    "page": "Home",
    "title": "GitForge.get_users",
    "category": "function",
    "text": "get_users(::Forge)\n\nGet all users.\n\n\n\n\n\n"
},

{
    "location": "#Endpoints-1",
    "page": "Home",
    "title": "Endpoints",
    "category": "section",
    "text": "These functions all allow any number of trailing keywords. For more information on these keywords, see request.get_user\nget_users"
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
    "text": "endpoint(::Forge, ::Function, args...) -> String\n\nReturns the endpoint for a given function, relative to the base URL. Trailing arguments are usually important for routing. For example, get_user can take some ID parameter which becomes part of the URL.\n\n\n\n\n\n"
},

{
    "location": "#URLs-1",
    "page": "Home",
    "title": "URLs",
    "category": "section",
    "text": "These functions set request URLs. To determine the full URL for a given request, they are concatenated together.base_url\nendpoint"
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
    "text": "request(\n    f::Forge, fun::Function, url::AbstractString, method::Symbol;\n    headers::Vector{<:Pair}=HTTP.Header[],\n    query::AbstractDict=Dict(),\n    body=HTTP.nobody,\n    kwargs...,\n) -> Result{T, E<:Exception}\n\nMake an HTTP request and return a Result. T is determined by into.\n\nArguments\n\nf::Forge A Forge subtype.\nfun::Function: The API function being called.\nurl::AbstractString: The endpoint, relative to the forge\'s base URL.\nmethod::Symbol: The HTTP request method to use.\n\nKeywords\n\nquery::AbstractDict=Dict(): Query string parameters to add to the request.\nheaders::Vector{<:Pair}=HTTP.Header[]: Headers to add to the request.\nbody=HTTP.nobody: Request body.`\n\nTrailing keywords are passed into HTTP.request.\n\nnote: Note\nEvery API function passes its keyword arguments into this function. Therefore, to customize behaviour for a single request, pass the above keywords to the API function.\n\n\n\n\n\n"
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
    "text": "These functions and types handle certain generic rate limiters.RateLimiter\nOnRateLimit\nRateLimited\nrate_limit_check\non_rate_limit\nrate_limit_wait\nrate_limit_period\nrate_limit_update!"
},

{
    "location": "#GitForge.postprocessor",
    "page": "Home",
    "title": "GitForge.postprocessor",
    "category": "function",
    "text": "postprocessor(::Forge, ::Function) -> Type{<:PostProcessor}\n\nReturns the PostProcessor to be used. Type parameters must not be included (they are produced by into).\n\n\n\n\n\n"
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
    "text": "Determines the behaviour of postprocess. Subtypes must have one type parameter, which is determined by into.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.postprocess",
    "page": "Home",
    "title": "GitForge.postprocess",
    "category": "function",
    "text": "postprocess(::Type{<:PostProcessor}, ::HTTP.Response)\n\nComputes a value from an HTTP response. This is what is returned by value.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.DoNothing",
    "page": "Home",
    "title": "GitForge.DoNothing",
    "category": "type",
    "text": "Does nothing and always returns nothing.\n\n\n\n\n\n"
},

{
    "location": "#GitForge.JSON",
    "page": "Home",
    "title": "GitForge.JSON",
    "category": "type",
    "text": "Parses a JSON response into a given type and returns that object.\n\n\n\n\n\n"
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
    "text": "These functions and types process HTTP responses.postprocessor\ninto\nPostProcessor\npostprocess\nDoNothing\nJSON\n@json"
},

]}
