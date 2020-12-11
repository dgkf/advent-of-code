input = reduce(hcat, split.(readlines(), ""))

input = map(input) do i
    i == "." && return 0
    i == "L" && return 1
    i == "#" && return 2
end

# part 1
function part1(input)
    input = deepcopy(input)
    input_next = deepcopy(input)
    i = 0
    while true # i < 10
        for x = 1:(size(input)[1]), y = 1:(size(input)[2])
            adj = [input[x+xa,y+ya] for xa=-1:1, ya=-1:1 if 1<=(x+xa)<=size(input)[1] && 1<=(y+ya)<=size(input)[2] && !(xa == ya == 0)]
            if input[x,y] == 1 && sum(adj .== 2) == 0
                input_next[x,y] = 2
            elseif input[x,y] == 2 && sum(adj .== 2) >= 4
                input_next[x,y] = 1
            end
        end
        all(input .== input_next) && return sum(input_next .== 2)
        input .= input_next
        i += 1
    end
end

println(part1(input))


# part 2
function first_seat_toward(input, x, y, dx, dy)
    !(1<=(x+dx)<=size(input)[1] && 1<=(y+dy)<=size(input)[2]) && return missing
    input[x+dx,y+dy] != 0 && return input[x+dx,y+dy]
    return first_seat_toward(input, x+dx, y+dy, dx, dy)
end

function part2(input)
    input = deepcopy(input)
    input_next = deepcopy(input)
    while true
        for x = 1:(size(input)[1]), y = 1:(size(input)[2])
            adj = skipmissing(first_seat_toward(input, x, y, xa, ya) for xa=-1:1, ya=-1:1 if !(xa == ya == 0))
            if input[x,y] == 1 && sum(adj .== 2) == 0
                input_next[x,y] = 2
            elseif input[x,y] == 2 && sum(adj .== 2) >= 5
                input_next[x,y] = 1
            end
        end
        all(input .== input_next) && return sum(input_next .== 2)
        input .= input_next
    end
end

println(part2(input))
