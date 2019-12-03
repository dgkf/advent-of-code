input = readlines("./2019/03/data.txt")

coords = cumsum.(map(input) do line
    hcat((map(split(line, ",")) do inst
        if inst[1] == 'R' 
            [parse(Int64, inst[2:end]), 0]
        elseif inst[1] == 'L'
            [-parse(Int64, inst[2:end]), 0]
        elseif inst[1] == 'U'
            [0, parse(Int64, inst[2:end])]
        elseif inst[1] == 'D'
            [0, -parse(Int64, inst[2:end])]
        end
    end)...)'
end, dims = 1)

find_intersection = function(p1a, p1b, p2a, p2b)
    x = ((p1b[1] * p1a[2] - p1a[1] * p1b[2]) * (p2b[1] - p2a[1]) - (p2b[1] * p2a[2] - p2a[1] * p2b[2]) * (p1b[1] - p1a[1])) / 
        ((p1b[1] - p1a[1]) * (p2b[2] - p2a[2]) - (p2b[1] - p2a[1]) * (p1b[2] - p1a[2]))
    y = ((p1b[1] * p1a[2] - p1a[1] * p1b[2]) * (p2b[2] - p2a[2]) - (p2b[1] * p2a[2] - p2a[1] * p2b[2]) * (p1b[2] - p1a[2])) / 
        ((p1b[1] - p1a[1]) * (p2b[2] - p2a[2]) - (p2b[1] - p2a[1]) * (p1b[2] - p1a[2]))

    if (min(p1a[1], p1b[1]) <= x <= max(p1a[1], p1b[1]) && 
        min(p1a[2], p1b[2]) <= y <= max(p1a[2], p1b[2])) 
        return [x, y]
    else
        return nothing
    end
end

intesections = []
for i=1:(size(coords[1])[1]-1)
    for j=1:(size(coords[2])[1]-1)
        maybe_intersection = find_intersection(
            coords[1][i,:], 
            coords[1][i+1,:], 
            coords[2][j,:], 
            coords[2][j+1,:])

        if maybe_intersection !== nothing
            push!(intersections, maybe_intersection)
        end
    end
end

println(intersections)