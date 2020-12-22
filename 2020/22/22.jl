p1 = parse.(Int, split(strip(readuntil(stdin, "\n\n")), "\n")[2:end])
p2 = parse.(Int, split(strip(readuntil(stdin, "\n\n")), "\n")[2:end])

# part 1
function space_cards(p1, p2)
    while length(p1) > 0 && length(p2) > 0
        if p1[1] > p2[1]
            push!(push!(p1, popfirst!(p1)), popfirst!(p2))
        elseif p2[1] > p1[1]
            push!(push!(p2, popfirst!(p2)), popfirst!(p1))
        else
            break
        end
    end
    return length(p1) == 0 ? p2 : p1
end

println(sum(prod.(enumerate(reverse(space_cards(deepcopy(p1), deepcopy(p2)))))))


# part 2
function recursive_space_cards(p1, p2)
    observed_decks = Set()
    while length(p1) > 0 && length(p2) > 0
        winner = -1

        if (p1,p2) ∈ observed_decks
            return (1, p1, p2)
        elseif length(p1) > p1[1] && length(p2) > p2[1]
            winner, _, _ = recursive_space_cards(p1[2:1+p1[1]], p2[2:1+p2[1]])
        end

        push!(observed_decks, (deepcopy(p1),deepcopy(p2)))
        
        if winner == 1 || (winner == -1 && p1[1] > p2[1])
            push!(push!(p1, popfirst!(p1)), popfirst!(p2))
        elseif winner == 2 || (winner == -1 && p2[1] > p1[1])
            push!(push!(p2, popfirst!(p2)), popfirst!(p1))
        end

    end
    (length(p1) == 0 ? 2 : 1, p1, p2)        
end

winner, p1out, p2out = recursive_space_cards(deepcopy(p1), deepcopy(p2))
println(sum(prod.(enumerate(reverse(length(p1out) == 0 ? p2out : p1out)))))

