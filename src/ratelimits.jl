"""
Determines how to react to an exceeded rate limit.

- `ORL_THROW`: Throw a [`RateLimitedError`](@ref).
- `ORL_WAIT`: Block and wait for the rate limit to expire.
"""
@enum OnRateLimit ORL_THROW ORL_WAIT

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
    remaining = tryheader(r, "RateLimit-Remaining")
    reset = tryheader(r, "RateLimit-Reset")
    remaining === nothing && reset === nothing && return

    if remaining === nothing || reset === nothing
        @warn "Parsing rate limit headers failed"
    else
        parsed_remaining = tryparse(Int, remaining)
        parsed_reset = tryparse(Int, reset)
        if parsed_remaining === nothing || parsed_reset === nothing
            @warn "Parsing rate limit headers failed"
            return
        end
        rl.remaining = parsed_remaining
        rl.reset = parsed_reset
    end
end

function tryheader(r::HTTP.Response, header::AStr)
    for h in [header, "X-$header"]
        HTTP.hasheader(r, h) && return HTTP.header(r, h)
    end
    return nothing
end
