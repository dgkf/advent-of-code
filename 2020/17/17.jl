input = map(readlines()) do line
    replace(split(line, ""), "." => false, "#" => true)
end

input = reshape(vcat(input...), :, length(input))'
input3d = reshape(input, size(input)..., 1)
input4d = reshape(input, size(input)..., 1, 1)

function simulate(input, cycles)
    # build our state matrix
    state_size = size(input) .+ (cycles * 2)
    state_input_block = UnitRange.(cycles + 1, cycles .+ size(input))
    state = zeros(Bool, state_size)
    state[state_input_block...] .= input

    # set up our adjacenct offsets
    adj = CartesianIndices((repeat([-1:1], length(size(input)))...,))

    # iterate through cycles, updating state
    state_next = deepcopy(state)
    for cycle in 1:cycles
        for coord in CartesianIndices(state)
            n_adj = sum(get(state, coord + a, 0) for a in adj) - state[coord]
            if state[coord] && n_adj ∉ [2, 3]
                state_next[coord] = false
            elseif !state[coord] && n_adj == 3
                state_next[coord] = true
            end
        end
        state .= state_next
    end

    return(state)
end

println(sum(simulate(input3d, 6)))
println(sum(simulate(input4d, 6)))

