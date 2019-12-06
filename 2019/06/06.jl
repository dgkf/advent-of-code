using LightGraphs
using MetaGraphs

input = hcat((split(line, ")") for line=readlines("../../utils/cache/2019-6.txt"))...)

bodys = sort(unique(hcat(input...)))
input = findfirst.(.==(input), [bodys])

g = MetaGraph(length(bodys))
set_prop!.([g], 1:length(bodys), [:label], bodys)
set_indexing_prop!(g, :label)
add_edge!.([g], input[1,:], input[2,:])

# part 1
println(sum(length.(a_star.([g], [g["COM", :label]], vertices(g)))))

# part 2
println(length(a_star(g, getindex.([g], ["YOU", "SAN"], [:label])...))-2)

