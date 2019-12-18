using Base.Iterators: flatten
using Combinatorics

using LightGraphs
using MetaGraphs

input = readlines("./utils/cache/2019-18.txt")

input = split("########################
#f.D.E.e.C.b.A.@.a.B.c.#
######################.#
#d.....................#
########################", "\n")

input = split.(input, [""])

input = reshape(collect(flatten(input)), length(input[1]), length(input))

g = MetaGraph()

for (i, idx)=enumerate(CartesianIndices(input))
    add_vertex!(g, :loc, idx)
    set_prop!(g, i, :char, input[idx])
end

set_indexing_prop!(g, :loc)

for i=CartesianIndices(input)
    iidx = g[i, :loc]
    for j=CartesianIndex.([0, 0, -1, 1], [-1, 1, 0, 0])
        if !(i+j in keys(g[:loc])); continue; end
        jidx = g[i+j, :loc]
        add_edge!(g, iidx, jidx)
        if g.vprops[jidx][:char] == "#"   
            set_prop!(g, iidx, jidx, :weight, Inf)
        end
    end
end

function set_door!(g, idx, weight=Inf)
    if !(idx in keys(g[:loc])); return; end
    iidx = g[idx, :loc]
    for j=CartesianIndex.([0, 0, -1, 1], [-1, 1, 0, 0])
        if !(idx+j in keys(g[:loc])); continue; end
        jidx = g[idx+j, :loc]
        jchar = g.vprops[jidx][:char]
        if jchar == "#"; set_prop!(g, iidx, jidx, :weight, Inf)
        else; set_prop!(g, iidx, jidx, :weight, weight)
        end
    end
end

start = findfirst(input .== "@")
doorkeys = findall(match.([r"[a-z]"], input) .!== nothing)
doorkeys = [k => v for (k,v)=zip(input[doorkeys], doorkeys)]
doors = findall(match.([r"[A-Z]"], input) .!== nothing)
doors = Dict(k => v for (k,v)=zip(input[doors], doors))
for (k, idx)=doors; set_door!(g, idx, Inf); end

min_dist = Inf
for p=permutations(doorkeys)
    p = reverse(p)
    gp = copy(g)
    dist = 0
    loc = start
    while length(p) > 0 && dist != Inf
        next_key = popfirst!(p)
        path_to_key = a_star(gp, gp[loc,:loc], gp[next_key[2],:loc])
        if length(path_to_key) == 0; dist = Inf; continue
        else; dist += length(path_to_key)
        end
        print(length(path_to_key)); print(" ");
        loc = next_key[2]
        door_idx = get(doors, uppercase(next_key[1]), -1)
        set_door!(gp, door_idx, 1)
    end
    global min_dist = min(min_dist, dist) 
    println(min_dist)
end

