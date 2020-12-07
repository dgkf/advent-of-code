using MetaGraphs
using LightGraphs

input = read(stdin, String)
input = split(replace(input, r"(bags?|\.)" => ""), r"\s*\n")
input = split.(input, r"\s*(contain|,)\s*")
input = input[1:end-1]

g = MetaDiGraph(SimpleDiGraph(), 0)
set_indexing_prop!(g, :name)

for i = input
    if i[1] ∉ keys(g[:name])
        add_vertex!(g, :name, i[1])
    end
    for j = i[2:end]
        jm = match(r"^(\d+) (.*)$", j)
        if jm isa Nothing
            continue
        end
        if jm[2] ∉ keys(g[:name])
            add_vertex!(g, :name, jm[2])
        end
        add_edge!(g, g[i[1], :name], g[jm[2], :name], :weight, parse(Int, jm[1]))
    end
end

count(g.vprops) do (i, d)
    d[:name] != "shiny gold" &&
    has_path(g, g[d[:name], :name], g["shiny gold", :name])
end |> println

function enumerate_all_paths(g, v::AbstractArray)
    vo = vcat.([v], outneighbors(g, last(v)))
    return(vcat([v], enumerate_all_paths.([g], vo)...))
end

function path_weights(g, p)
    if length(p) < 2
        return []
    end
    [get_prop(g, src, dst, :weight) for (src, dst) in zip(p[1:end-1], p[2:end])]
end

println(sum(prod.(filter(i -> length(i) > 0, path_weights.([g], enumerate_all_paths(g, [g["shiny gold", :name]]))))))

