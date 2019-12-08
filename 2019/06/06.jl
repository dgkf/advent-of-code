using LightGraphs
using MetaGraphs

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

function MetaGraph(x::Base.Generator, args...; kwargs...) 
    MetaGraph([x...], args...; kwargs...)
end

# build graph from pairs
g = MetaGraph(a => b for (a, b)=split.(readlines(), ")"))

# part 1
println(sum(length.(a_star(g, g["COM", :data], i) for i=vertices(g))))

# part 2
println(length(a_star(g, g["YOU", :data], g["SAN", :data])) - 2)

