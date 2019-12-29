using Base.Iterators: flatten
using MetaGraphs
using LightGraphs

input = readlines()
input = reshape([flatten(split.(input, [""]))...], :, length(input))

maze = copy(input)

function replace_portal_name!(maze, idx, offsetidxA, offsetidxB)
    if (maze[idx] == "." && 
            occursin(r"[A-Z]", maze[idx + offsetidxA]) && 
            occursin(r"[A-Z]", maze[idx + offsetidxB]))
        is_outer = any(Tuple(idx) .<= 3) || any(Tuple(idx) .>= size(maze) .- 3)
        maze[idx] = (is_outer ? "outer " : "inner ") *
            join(maze[[idx + offsetidxA, idx + offsetidxB]])
        maze[[idx + offsetidxA, idx + offsetidxB]] .= " "
    end
end

for ci=CartesianIndices(maze)
    replace_portal_name!(maze, ci, CartesianIndex(0,1), CartesianIndex(0,2))
    replace_portal_name!(maze, ci, CartesianIndex(0,-2), CartesianIndex(0,-1))
    replace_portal_name!(maze, ci, CartesianIndex(1,0), CartesianIndex(2,0))
    replace_portal_name!(maze, ci, CartesianIndex(-2,0), CartesianIndex(-1,0))
end

maze = maze[3:end-2,3:end-2]

g = MetaGraph()

for ci=CartesianIndices(maze)
    add_vertex!(g, Dict(:loc => ci, :txt => maze[ci]))
end

set_indexing_prop!(g, :loc)

for ci=CartesianIndices(maze)
    for offset=CartesianIndex.([-1, 1, 0, 0], [0, 0, -1, 1])
        if !(ci+offset in keys(g[:loc])); continue; end
        if !(Edge(g[ci,:loc], g[ci+offset,:loc]) in edges(g))
            add_edge!(g, g[ci,:loc], g[ci+offset,:loc])
        end
        if maze[ci] in ["#", " "]
            set_prop!(g, g[ci,:loc], g[ci+offset,:loc], :weight, Inf)
        end
        if occursin(r"[A-Z]", maze[ci])
            code = match(r"[A-Z]+", maze[ci]).match
            portals = [i for (i,v)=g.vprops if occursin(code, v[:txt])]
            if length(portals) == 2; add_edge!(g, portals...); end
        end
    end
end

# part 1
iAA = first(i for (i,v)=g.vprops if occursin("AA", v[:txt]))
iZZ = first(i for (i,v)=g.vprops if occursin("ZZ", v[:txt]))
println(length(a_star(g, iAA, iZZ)))

# part 2
g = MetaGraph()

for ci=CartesianIndices(maze)
    add_vertex!(g, Dict(:loc => ci, :txt => maze[ci]))
end

set_indexing_prop!(g, :loc)

for ci=CartesianIndices(maze)
    for offset=CartesianIndex.([-1, 1, 0, 0], [0, 0, -1, 1])
        if !(ci+offset in keys(g[:loc])); continue; end
        if !(Edge(g[ci,:loc], g[ci+offset,:loc]) in edges(g))
            add_edge!(g, g[ci,:loc], g[ci+offset,:loc])
        end
        if maze[ci] in ["#", " "]
            set_prop!(g, g[ci,:loc], g[ci+offset,:loc], :weight, Inf)
        end
    end
end

portals = Dict(v[:txt] => i for (i,v)=g.vprops if occursin(r"[A-Z]", v[:txt]))

# map routes and distances
routes = []  # [(nameA => nameB, dist, recursion)]
for (ki, vi)=portals
    for (kj, vj)=portals
        if ki == kj; continue; end
        path_length = length(a_star(g, vi, vj))
        if path_length > 0
            append!(routes, [(ki, kj, path_length, 0)])
        end
    end
    if occursin("inner", ki)
        kj = replace(ki, "inner" => "outer")
        append!(routes, [(ki, kj, 1, 1)])
    end
end

route_g = MetaGraph()
set_indexing_prop!(route_g, :state)

function get_weight(g, a, b)
    e = Edge(a, b)
    if e in keys(g.eprops); return g.eprops[e][:weight]; end
    g.eprops[Edge(b, a)][:weight]
end

min_distance = Inf
recursions = 0
while true
    for (s, e, d, r)=routes
        start_state = (s, recursions)
        if !(start_state in keys(route_g[:state]))
            add_vertex!(route_g, :state, start_state)
        end
        end_state = (e, recursions + r)
        if !(end_state in keys(route_g[:state]))
            add_vertex!(route_g, :state, end_state)
        end
        add_edge!(route_g, 
            route_g[start_state,:state], 
            route_g[end_state,:state], :weight, d)
    end
    path = enumerate_paths(dijkstra_shortest_paths(
        route_g, 
        route_g[("outer AA", 0),:state]), 
        route_g[("outer ZZ", 0),:state])
    if length(path) > 0
        dist = sum([get_weight(route_g, a, b)
            for (a,b)=zip(path[1:end-1], path[2:end])])
    else
        dist = Inf
    end
    if min_distance != Inf && dist == min_distance; break; end
    if dist > 0; global min_distance = dist; end
    global recursions += 1
end

println(min_distance)

