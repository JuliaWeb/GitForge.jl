macro json(ex::Expr)
    # Make the struct mutable.
    ex.args[1] = true

    # Make all fields nullable.
    foreach(ex.args[3].args) do ex
        ex isa Expr && (ex.args[2] = :(Union{$(ex.args[2]), Nothing}))
    end

    # Add a zero argument constructor.
    T = ex.args[2]
    nothings = repeat([nothing], count(ex -> ex isa Expr, ex.args[3].args))
    push!(ex.args[3].args, :($T() = new($(nothings...))))

    # Apply the noargs JSON2 format.
    ex = Expr(:block, ex, :(JSON2.@format $T noargs))

    esc(ex)
end
