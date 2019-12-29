verbose = "--verbose" in ARGS
bugs_scan = hcat(map(x -> Int8.(split(x, "") .== "#"), readlines())...)

# part 1
biodiversity(x) = sum(reshape(x, :) .* (2 .^ (0:(length(x)-1))))

function adjacency(x)
    map(CartesianIndices(x)) do i
        sum(get(x, i+o, 0) for o=CartesianIndex.([0,1,0,-1], [-1,0,1,0]))
    end
end

function tick!(x)
    adj = adjacency(x)
    die = (x .== 1) .& (adj .!= 1)
    infest = (x .== 0) .& (0 .< adj .< 3)
    x[die] .= 0
    x[infest] .= 1 
    x
end

bugs = copy(bugs_scan)
biodiversities = []
while true
    push!(biodiversities, biodiversity(bugs))
    if (length(biodiversities) > length(unique(biodiversities))); break; end
    tick!(bugs)
end

println(last(biodiversities))

# part 2
bugs = Dict((0, ci - CartesianIndex(3,3)) => x
    for (x, ci)=zip(bugs_scan, CartesianIndices(bugs_scan)))
delete!(bugs, (0, CartesianIndex(0,0)))

function adjacent(depth, ci)
    tiles = [ci+o for o=CartesianIndex.([0,1,0,-1], [-1,0,1,0])]
    neighbors = []
    for tile=tiles
        x, y = Tuple(tile)
        if x < -2;     push!(neighbors, (depth - 1, CartesianIndex(-1, 0)))
        elseif x > 2;  push!(neighbors, (depth - 1, CartesianIndex(1, 0)))
        elseif y < -2; push!(neighbors, (depth - 1, CartesianIndex(0, -1)))
        elseif y > 2;  push!(neighbors, (depth - 1, CartesianIndex(0, 1)))
        elseif (x, y) == (0, 0)
            idxs = (if ci[1] == -1; CartesianIndex.([-2], -2:2)
                elseif ci[1] == 1;  CartesianIndex.([2], -2:2)
                elseif ci[2] == -1; CartesianIndex.(-2:2, [-2])
                elseif ci[2] == 1;  CartesianIndex.(-2:2, [2])
                end)
            for n=idxs; push!(neighbors, (depth + 1, n)); end
        else
            push!(neighbors, (depth, tile))
        end
    end
    neighbors
end

function adjacency(x::Dict)
    adj = copy(x)
    for (k, v)=adj; adj[k]=sum(get(x, adjk, 0) for adjk=adjacent(k...)); end
    adj
end

function add_adjacent!(x::Dict)
    for (k, v)=x
        for adjk=adjacent(k...)
            if !(adjk in keys(x)); x[adjk] = 0; end
        end
    end
end

function tick!(x::Dict)
    add_adjacent!(x)
    adj = adjacency(x)
    for (k, n)=adj
        if (x[k] == 1) && (n != 1); x[k] = 0
        elseif (x[k] == 0) && (0 < n < 3); x[k] = 1
        end
    end
end

for i=1:200
    if verbose; println("iteration: $i"); end
    tick!(bugs)
end

println(sum(values(bugs)))

