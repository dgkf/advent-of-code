using LightGraphs
using MetaGraphs

# extend MetaGraphs indexing to support node data
Base.getindex(x::MetaGraphs.AbstractMetaGraph, indx) = x[indx, :data]

# extend MetaGraphs with constructor from object pairs
function MetaGraph(x::AbstractArray{<:Pair})
	objs = sort(unique([first.(x)..., last.(x)...]))
	g = MetaGraphs.MetaGraph(length(objs))
	for (i, obj)=enumerate(objs); set_prop!(g, i, :data, obj); end
	set_indexing_prop!(g, :data)
	x_indxs = [findfirst(==(a), objs) => findfirst(==(b), objs) for (a,b)=x]
	for (i, (a, b))=enumerate(x_indxs); add_edge!(g, a, b); end
	return g
end

# build graph from pairs
input = [Pair(split(line, ")")...) for line=readlines()]
g = MetaGraph(input)

# part 1
println(sum(length.(a_star(g, g["COM"], i) for i=vertices(g))))

# part 2
println(length(a_star(g, g["YOU"], g["SAN"])) - 2)

