"""
Determines how to react to an exceeded rate limit.

- `ORL_RETURN`: Return a [`Result`](@ref) containing a [`RateLimited`](@ref) exception.
- `ORL_WAIT`: Block and wait for the rate limit to expire.
"""
@enum OnRateLimit ORL_RETURN ORL_WAIT

"""
A signal that a rate limit has been exceeded.
Can contain the amount of time until its expiry.
"""
struct RateLimited <: Exception
    period::Union{Period, Nothing}
end

"""
A generic rate limiter using the `[X-]RateLimit-Remaining` and `[X-]RateLimit-Reset` response headers.
The reset header is assumed to be a Unix timestamp in seconds.
"""
mutable struct RateLimiter
    remaining::Int
    reset::Int

    RateLimiter() = new(1, 0)
end

rate_limit_check(rl::RateLimiter) =
    rl.remaining == 0 && rate_limit_period(rl) > Millisecond(0)

rate_limit_wait(rl::RateLimiter) = sleep(rate_limit_period(rl))

rate_limit_period(rl::RateLimiter) = max(Millisecond(0), unix2datetime(rl.reset) - now(UTC))

function rate_limit_update!(rl::RateLimiter, r::HTTP.Response)
    remaining = tryheader(i -> parse(Int, i), r, "RateLimit-Remaining")
    reset = tryheader(i -> parse(Int, i), r, "RateLimit-Reset")
    if remaining === nothing  || reset === nothing
        @warn "Parsing rate limit headers failed"
    else
        rl.remaining = remaining
        rl.reset = reset
    end
end

function tryheader(f::Function, r::HTTP.Response, header::AStr)
    for h in [header, "X-$header"]
        HTTP.hasheader(r, h) && return f(HTTP.header(r, h))
    end
    return nothing
end
