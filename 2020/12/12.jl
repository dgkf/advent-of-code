input = readlines("utils/cache/2020/12/input.txt")

right(x, n) = n == 0 ? x : right([-sign(n)*x[2],  sign(n)*x[1]], n-sign(n))

input = map(input) do i
    l = i[1]
    n = parse(Int, i[2:end])

    turn_to = 
        l == 'R' ? x -> right(x, n / 90) :
        l == 'L' ? x -> right(x, -n / 90) :
        identity

    move_along = 
        l == 'N' ? x -> [ 0, -1] : 
        l == 'S' ? x -> [ 0,  1] :
        l == 'E' ? x -> [ 1,  0] :
        l == 'W' ? x -> [-1, 0]  :
        l == 'R' ? x -> [0, 0] :
        l == 'L' ? x -> [0, 0] :
        identity

    (l, turn_to, move_along, l ∈ ['R', 'L'] ? 0 : n)
end

# part 1
function sail(input, pos, facing)
    for (l, turn_to, move_along, n) = input
        pos .+= move_along(facing) .* n
        facing = turn_to(facing)
    end
    return sum(abs.(pos))
end
println(sail(input, [0, 0], [1, 0]))

# part 2
function sailawaypoint(input, pos, waypoint)
    for (l, turn, move_along, n) = input
        l == 'F' && (pos .+= n .* waypoint)
        l != 'F' && (waypoint .+= move_along(missing) .* n)
        waypoint = turn(waypoint)
    end
    return sum(abs.(pos))
end
println(sailawaypoint(input, [0, 0], [10, -1]))

