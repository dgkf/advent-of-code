using Base.Iterators: flatten
using Combinatorics
using Random

using LightGraphs
using MetaGraphs

input = split.(readlines(), [""])
input = reshape(collect(flatten(input)), length(input[1]), length(input))

# part 1
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

start = "@" => findfirst(input .== "@")
doorkeys = findall(match.([r"[a-z]"], input) .!== nothing)
doorkeys = [k => v for (k,v)=zip(input[doorkeys], doorkeys)]
doors = findall(match.([r"[A-Z]"], input) .!== nothing)
doors = Dict(k => v for (k,v)=zip(input[doors], doors))

paths = []  # [(start_char, end_char, dist, [prereqs...])]
for (A, Acoord)=doorkeys
    # start --> letterA
    path = a_star(g, g[start[2],:loc], g[Acoord,:loc])
    chars = [g.vprops[p.dst][:char] for p=path]
    door_chars = lowercase.(chars[match.([r"[A-Z]"], chars) .!== nothing])
    chars = [c[1] for c=chars]
    door_chars = [dc[1] for dc=door_chars]
    push!(paths, (start[1][1], A[1], length(chars), door_chars))

    # letterA --> letterB
    for (B, Bcoord)=doorkeys
        if A==B; continue; end
        path = a_star(g, g[Acoord,:loc], g[Bcoord,:loc])
        chars = [g.vprops[p.dst][:char] for p=path]
        door_chars = lowercase.(chars[match.([r"[A-Z]"], chars) .!== nothing])
        chars = [c[1] for c=chars]
        door_chars = [dc[1] for dc=door_chars]
        push!(paths, (A[1], B[1], length(chars), door_chars))
    end
end

function graph_states!(g, state, paths, total_keys)
    if !(state in keys(g[:state])); add_vertex!(g, :state, state); end
    moves = [p for p=paths if 
        p[1] == state[1] && 
        !(p[2] in state[2]) &&
        all(in.(p[4], [state[2]]))]

    for (a, b, dist, req_keys)=moves
        next_keys = union(Set(b), state[2])
        next_state = (next_keys == total_keys ? ' ' : b, next_keys)
        if !(next_state in keys(g[:state])); 
            add_vertex!(g, :state, next_state)
            graph_states!(g, next_state, paths, total_keys)
        end
        add_edge!(g, g[state,:state], g[next_state,:state])
        set_prop!(g, g[state,:state], g[next_state,:state], :weight, dist)
    end
end

states = MetaDiGraph()
set_indexing_prop!(states, :state)
graph_states!(states, ('@', Set([])), paths, Set([p[1] for p=paths if p[1] != '@']))

end_state = first([i for (i,v)=states.vprops if v[:state][1] == ' '])

path = enumerate_paths(dijkstra_shortest_paths(states, 1), end_state)
println(sum([states.eprops[Edge(a => b)][:weight] for (a,b)=zip(path[1:end-1], path[2:end])]))



# part 2
g = MetaGraph()

for (i, idx)=enumerate(CartesianIndices(input2))
    add_vertex!(g, :loc, idx)
    set_prop!(g, i, :char, input2[idx])
end

set_indexing_prop!(g, :loc)

for i=CartesianIndices(input2)
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

input2 = copy(input)
orig_at = findfirst(input .== "@")
input2[[orig_at + CartesianIndex(a,b) for a=-1:1, b=-1:1]] .= "#"
starts = ("@" .* string.(1:4)) .=> [orig_at + CartesianIndex(a,b) for a=[-1,1] for b=[-1,1]]
input2[last.(starts)] = first.(starts)

doorkeys = findall(match.([r"[a-z]"], input2) .!== nothing)
doorkeys = [k => v for (k,v)=zip(input2[doorkeys], doorkeys)]
doors = findall(match.([r"[A-Z]"], input2) .!== nothing)
doors = Dict(k => v for (k,v)=zip(input2[doors], doors))

paths = []  # [(start_char, end_char, dist, [prereqs...])]
for (A, Acoord)=doorkeys
    # start --> letterA
    for start=starts
        path = a_star(g, g[start[2],:loc], g[Acoord,:loc])
        chars = [g.vprops[p.dst][:char] for p=path]
        door_chars = lowercase.(chars[match.([r"[A-Z]"], chars) .!== nothing])
        push!(paths, (start[1], A, length(chars), door_chars))
    end

    # letterA --> letterB
    for (B, Bcoord)=doorkeys
        if A==B; continue; end
        path = a_star(g, g[Acoord,:loc], g[Bcoord,:loc])
        chars = [g.vprops[p.dst][:char] for p=path]
        door_chars = lowercase.(chars[match.([r"[A-Z]"], chars) .!== nothing])
        push!(paths, (A, B, length(chars), door_chars))
    end
end
filter!(x -> x[3] > 0, paths)

function graph_states!(g, state, paths, total_keys)
    if !(state in keys(g[:state])); add_vertex!(g, :state, state); end
    for robot=1:4
        moves = [p for p=paths if 
            p[1] == state[robot] && 
            !(p[2] in state[end]) &&
            all(in.(p[4], [state[end]]))]

        for (a, b, dist, req_keys)=moves
            next_keys = union(Set([b]), state[end])
            next_state = copy(state)
            next_state[end] = next_keys
            next_state[robot] = next_keys == total_keys ? " " : b
            if !(next_state in keys(g[:state])); 
                add_vertex!(g, :state, next_state)
                graph_states!(g, next_state, paths, total_keys)
            end
            add_edge!(g, g[state,:state], g[next_state,:state])
            set_prop!(g, g[state,:state], g[next_state,:state], :weight, dist)
        end
    end
end

states = MetaDiGraph()  # (@1, @2, @3, @4, keys)
set_indexing_prop!(states, :state)

all_keys = Set([p[1] for p=paths if !startswith(p[1], "@")])
graph_states!(states, ["@1", "@2", "@3", "@4", Set([])], paths, all_keys)

end_states = [i for (i,v)=states.vprops if any(v[:state][1:4] .== " ")]
println(minimum(map(end_states) do es
    path = enumerate_paths(dijkstra_shortest_paths(states, 1), es)
    out = sum([states.eprops[Edge(a => b)][:weight] for (a,b)=zip(path[1:end-1], path[2:end])])
    println(out)
    out
end))


