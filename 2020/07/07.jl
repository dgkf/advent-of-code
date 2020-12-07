using MetaGraphs
using LightGraphs

input = read(stdin, String)
input = split(replace(input, r"(bags?|\.)" => ""), r"\s*\n")
input = split.(input, r"\s*(contain|,)\s*")
input = input[1:end-1]

g = MetaDiGraph(SimpleDiGraph(), 0)
set_indexing_prop!(g, :name)

function add_vertex_if_missing!(g, idx, val)
    if val ∉ keys(g[idx])
        add_vertex!(g, :name, val)
    end
end

# part 1
for i = input
    add_vertex_if_missing!(g, :name, i[1])
    for j = filter(i -> i isa RegexMatch, match.(r"^(\d+) (.*)$", i[2:end]))
        add_vertex_if_missing!(g, :name, j[2])
        add_edge!(g, g[i[1], :name], g[j[2], :name], :weight, parse(Int, j[1]))
    end
end

count(g.vprops) do (i, d)
    d[:name] != "shiny gold" &&
    has_path(g, g[d[:name], :name], g["shiny gold", :name])
end |> println

# part 2
function enumerate_all_paths(g, v::AbstractArray)
    vo = vcat.([v], outneighbors(g, last(v)))
    return(vcat([v], enumerate_all_paths.([g], vo)...))
end

function path_weights(g, p)
    get_prop(g, src, dst, :weight) for (src, dst) = zip(p[1:end-1], p[2:end])
end

paths = enumerate_all_paths(g, [g["shiny gold", :name]])
println(sum(prod.(filter(i -> length(i) > 0, path_weights.([g], paths)))))

