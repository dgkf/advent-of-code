cups = parse.(Int, split(readlines(stdin)[1], ""))

prev_cup(cups, i) = first(cups[i])
next_cup(cups, i) = last(cups[i])
function cups_game(cups, n = 100)
    current = cups[1]
    maxcup = maximum(cups)

    cups = Dict{Int,Tuple{Int,Int}}(i => (prev, next) for (i, prev, next) in 
        zip(cups, cups[mod1.(0:end-1, end)], cups[mod1.(2:end+1, end)]))

    for i in 1:n
        next1 = next_cup(cups, current)        
        next2 = next_cup(cups, next1)
        next3 = next_cup(cups, next2)
        next4 = next_cup(cups, next3)
        nextset = (next1, next2, next3)

        dest = current - 1
        dest in nextset && (dest -= 1)
        dest in nextset && (dest -= 1)
        dest in nextset && (dest -= 1)
        dest < 1        && (dest = maxcup)
        dest in nextset && (dest -= 1)
        dest in nextset && (dest -= 1)
        dest in nextset && (dest -= 1)

        cups[current] = (cups[current][1], cups[next3][2])
        cups[next4]   = (current, cups[next4][2])
        cups[next3]   = (cups[next3][1], cups[dest][2])
        cups[dest]    = (cups[dest][1], next1)
        cups[next1]   = (dest, cups[next1][2])

        current = next4
    end

    return cups
end

function get_n_cups(cups, start, n = length(cups))
    out = Array{Int}([])
    i = start
    for _ = 1:n
        push!(out, i)
        i = next_cup(cups, i)
    end
    return out
end

# part 1
cupsout = cups_game(cups, 100)
println(join(string.(get_n_cups(cupsout, 1)[2:end]), ""))

# part 2
cupslong = Array{Int}([cups; 10:1e6])
cupsout  = cups_game(cupslong, 1e7)
println(prod(get_n_cups(cupsout, 1, 3)[2:end]))

