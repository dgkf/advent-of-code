using MetaGraphs
using LightGraphs

input = read(stdin, String)
input = split(replace(input, r"(bags?|\.)" => ""), r"\s*\n")
input = split.(input, r"\s*(contain|,)\s*")
input = input[1:end-1]

g = MetaDiGraph(SimpleDiGraph(), 0)
set_indexing_prop!(g, :name)

# build graph
maybe_add_vertex!(g, k, v) = val ∉ keys(g[k]) && add_vertex!(g, k, v)

for i = input
    maybe_add_vertex!(g, :name, i[1])
    for j = filter(i -> i isa RegexMatch, match.(r"^(\d+) (.*)$", i[2:end]))
        maybe_add_vertex!(g, :name, j[2])
        add_edge!(g, g[i[1], :name], g[j[2], :name], :weight, parse(Int, j[1]))
    end
end

# part 1
println(length(neighborhood(g, g["shiny gold", :name], nv(g); dir = :in)) - 1)

# part 2
bfs_path(g, v::Int) = bfs_paths(g, [v])
function bfs_paths(g, vs::AbstractArray)

end

function enumerate_all_paths(g, v::AbstractArray)
    vo = vcat.([v], setdiff(neighbors(g, last(v)), v))
    return(vcat([v], enumerate_all_paths.([g], vo)...))
end

function path_edge_weights(g, p)
    get_prop(g, src, dst, :weight) for (src, dst) = zip(p[1:end-1], p[2:end])
end

paths = enumerate_all_paths(g, [g["shiny gold", :name]])
println(sum(prod.(filter(i -> length(i) > 0, path_edge_weights.([g], paths)))))

