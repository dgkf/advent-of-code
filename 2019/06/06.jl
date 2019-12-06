using LightGraphs
using MetaGraphs

# read in input, create array of data and map input to indices
input = hcat((split(line, ")") for line=readlines())...)
bodys = sort(unique(input))
input = findfirst.(.==(input), [bodys])

# build graph from node indices map, bind orbital body data
g = MetaGraph(length(bodys))
set_prop!.([g], 1:length(bodys), [:label], bodys)
set_indexing_prop!(g, :label)
add_edge!.([g], input[1,:], input[2,:])

# part 1
println(sum(length.(a_star.([g], [g["COM", :label]], vertices(g)))))

# part 2
println(length(a_star(g, getindex.([g], ["YOU", "SAN"], [:label])...))-2)

