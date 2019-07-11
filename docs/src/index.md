```@meta
CurrentModule = GitForge
```

# GitForge

[![Build Status](https://travis-ci.com/christopher-dG/GitForge.jl.svg?branch=master)](https://travis-ci.com/christopher-dG/GitForge.jl)

**GitForge.jl is a unified interface for interacting with Git ["forges"](https://en.wikipedia.org/wiki/Forge_(software)).**

```@docs
Forge
```

# Supported Forges

## GitHub

```@docs
GitHub.GitHubAPI
GitHub.NoToken
GitHub.Token
GitHub.JWT
```

## GitLab

```@docs
GitLab.GitLabAPI
GitLab.NoToken
GitLab.OAuth2Token
GitLab.PersonalAccessToken
```

# API

## Results

```@docs
Result
value
response
exception
```

## Pagination

```@docs
@paginate
```

## Endpoints

These functions all allow any number of trailing keywords.
For more information on these keywords, see [`request`](@ref).

```@docs
get_user
get_users
update_user
create_user
delete_user
get_user_repos
get_repo
get_branch
get_file_contents
get_pull_request
get_pull_requests
create_pull_request
get_commit
get_tags
is_collaborator
is_member
```

# Internals

The following resources are useful for implementing new forges, or customizing behaviour.

Many functions take a `Function` argument, which can be used to limit the affected API functions.
To make a method specific to a single function, use `::typeof(fun)`.

## URLs

These functions set request URLs.
To determine the full URL for a given request, they are concatenated together.

```@docs
base_url
endpoint
Endpoint
```

## Request Options

These functions set parts of HTTP requests.

```@docs
request_headers
request_query
request_kwargs
```

## Requests

This function makes the actual HTTP requests.

```@docs
request
```

## Rate Limiting

These functions and types handle certain generic rate limiters.

```@docs
RateLimiter
OnRateLimit
RateLimited
has_rate_limits
rate_limit_check
on_rate_limit
rate_limit_wait
rate_limit_period
rate_limit_update!
```

## Post Processing

These functions and types process HTTP responses.

```@docs
postprocessor
into
PostProcessor
postprocess
DoNothing
DoSomething
JSON
@json
```
