cups = parse.(Int, split(readlines(stdin)[1], ""))

function cup_game(cups, n = 100)
    cups = deepcopy(cups)
    cupsinto = deepcopy(cups)
    maxcup = maximum(cups)
    i = 1
    while i <= n
        i % max(n ÷ 1000, 1) == 0 && (println("$(i / n)%"))

        dest = cups[1] - 1
        dest ∈ cups[2:4] && (dest = dest - 1)
        dest ∈ cups[2:4] && (dest = dest - 1)
        dest ∈ cups[2:4] && (dest = dest - 1)

        dest < 1 && (dest = maxcup)
        dest ∈ cups[2:4] && (dest = dest - 1)
        dest ∈ cups[2:4] && (dest = dest - 1)
        dest ∈ cups[2:4] && (dest = dest - 1)

        loc = findfirst(==(dest), cups)

        cupsinto[1:loc-4] .= @view cups[5:loc]
        cupsinto[loc-3:loc-1] .= @view cups[2:4]
        cupsinto[loc:end-1] .= @view cups[loc+1:end]
        cupsinto[end:end] .= @view cups[1:1]
        cups, cupsinto = cupsinto, cups

        i += 1
    end
    return cups
end


# part 1
cupsout = cup_game(cups)
loc1 = findfirst(==(1), cupsout)
println(join(string.([cupsout[loc1+1:end]; cupsout[1:loc1-1]]), ""))

# part 2: brute force, smdh
cups = Array{Int}([cups; 10:1e6])
cupsout = cup_game(cups, 1e7)
loc1 = findfirst(==(1), cupsout)
cupsout[loc1+1] * cupsout[loc1+2]

