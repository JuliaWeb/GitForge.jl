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
A generic rate limiter using the `X-RateLimit-Remaining` and `X-RateLimit-Reset` response headers.
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
    try
        rl.remaining = parse(Int, HTTP.header(r, "X-RateLimit-Remaining"))
        rl.reset = parse(Int, HTTP.header(r, "X-RateLimit-Reset"))
    catch e
        @warn "Parsing rate limit headers failed" exception=(e, catch_backtrace())
    end
end
