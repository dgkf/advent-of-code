input = readlines()
@assert(length(input) > 0, "puzzle input must be passed to stdin.")

# define a coordinate type as syntactic sugar around an array (point.x)
# it's much slower, but also easier to keep track of
struct Coord; vec :: AbstractArray; end
Base.:+(a::Coord, b::Coord) = Coord(a.vec + b.vec)
Base.getproperty(coord::Coord, x::Symbol) = coord_prop(coord, Val(x), x)
coord_prop(coord::Coord, sym::Val{:x}, x) = coord.vec[1]
coord_prop(coord::Coord, sym::Val{:y}, x) = coord.vec[2]
coord_prop(coord::Coord, sym, x) = getfield(coord, x)

(lineA, lineB) = map(input) do line
    cumsum(map(split(line, ",")) do inst
        val = parse(Int, inst[2:end])
        if     inst[1] == 'R'; Coord([val, 0, val])
        elseif inst[1] == 'L'; Coord([-val, 0, val])
        elseif inst[1] == 'U'; Coord([0, val, val])
        elseif inst[1] == 'D'; Coord([0, -val, val])
        end
    end)
end

function find_intersection(a1, a2, b1, b2)
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

function path_stats(lineA, lineB)
    min_manh_dist = Inf
    min_path_dist = Inf
    for i=1:(length(lineA)-1), j=1:(length(lineB)-1)
        cross = find_intersection(lineA[i], lineA[i+1], lineB[j], lineB[j+1])
        if cross === nothing; continue; end

        # calculate manhattan distance
        manh_dist = sum(abs.(cross))
        min_manh_dist = manh_dist < min_manh_dist ? manh_dist : min_manh_dist

        # calculate path length
        path_dist = lineA[i].vec[3] + lineB[j].vec[3] + 
            sum(abs.(cross - [lineA[i].x, lineA[i].y])) + 
            sum(abs.(cross - [lineB[j].x, lineB[j].y]))
        min_path_dist = path_dist < min_path_dist ? path_dist : min_path_dist
    end
    return trunc(Int, min_manh_dist), trunc(Int, min_path_dist)
end

println(join(path_stats(lineA, lineB), "\n"))

