input = readlines()
@assert(length(input) > 0, "puzzle input must be passed to stdin.")

struct Coord
    x 
    y
    z
end

Base.:+(a::Coord, b::Coord) = Coord(a.x + b.x, a.y + b.y, a.z + b.z)

ps = map(input) do line
    cumsum(map(split(line, ",")) do inst
        val = parse(Int, inst[2:end])
        if     inst[1] == 'R'; Coord(val, 0, val)
        elseif inst[1] == 'L'; Coord(-val, 0, val)
        elseif inst[1] == 'U'; Coord(0, val, val)
        elseif inst[1] == 'D'; Coord(0, -val, val)
        end
    end)
end

find_intersection = function(a1, a2, b1, b2)
    x = ((a2.x * a1.y - a1.x * a2.y) * (b2.x - b1.x) - (b2.x * b1.y - b1.x * b2.y) * (a2.x - a1.x)) / 
        ((a2.x - a1.x) * (b2.y - b1.y) - (b2.x - b1.x) * (a2.y - a1.y))
    y = ((a2.x * a1.y - a1.x * a2.y) * (b2.y - b1.y) - (b2.x * b1.y - b1.x * b2.y) * (a2.y - a1.y)) / 
        ((a2.x - a1.x) * (b2.y - b1.y) - (b2.x - b1.x) * (a2.y - a1.y))

    if (min(a1.x, a2.x) <= x <= max(a1.x, a2.x) && 
        min(a1.y, a2.y) <= y <= max(a1.y, a2.y) &&
        min(b1.x, b2.x) <= x <= max(b1.x, b2.x) && 
        min(b1.y, b2.y) <= y <= max(b1.y, b2.y)) 
        return [x, y]
    else
        return nothing
    end
end

find_min_distance = function(ps)
    min_distance = Inf
    for i=1:(size(ps[1])[1]-1), j=1:(size(ps[2])[1]-1)
        cross = find_intersection(ps[1][i], ps[1][i+1], ps[2][j], ps[2][j+1])

        if cross !== nothing
            dist = sum(abs.(cross))
            if dist < min_distance
                min_distance = dist
            end
        end
    end
    return trunc(Int, min_distance)
end

find_min_path_dist = function(ps)
    min_path_dist = Inf
    for i=1:(size(ps[1])[1]-1), j=1:(size(ps[2])[1]-1)
        cross = find_intersection(ps[1][i], ps[1][i+1], ps[2][j], ps[2][j+1])

        if cross !== nothing
            path_dist = ps[1][i].z + ps[2][j].z + 
                sum(abs.(cross - [ps[1][i].x, ps[1][i].y])) + 
                sum(abs.(cross - [ps[2][j].x, ps[2][j].y]))

            if path_dist < min_path_dist
                min_path_dist = path_dist
            end
        end
    end
    return trunc(Int, min_path_dist)
end

println(find_min_distance(ps))
println(find_min_path_dist(ps))
