using SparseArrays
using LightGraphs

input = hcat((split(line, ")") for line=readlines())...)
bodys = sort(unique(hcat(input...)))

orbits = SimpleDiGraph(sparse(
    findfirst.(.==(input[1,:]), [bodys]),
    findfirst.(.==(input[2,:]), [bodys]), 
    repeat([1], size(input)[2])))

# part 1
com = findfirst(==("COM"), bodys)
println(sum(length.(a_star.([orbits], [com], vertices(orbits)))))

# part 2
you_orbiting = input[1, findfirst(==("YOU"), input[2,:])]
san_orbiting = input[1, findfirst(==("SAN"), input[2,:])]
length(a_star(
    SimpleGraph(orbits), 
    findfirst(==(you_orbiting), bodys), 
    findfirst(==(san_orbiting), bodys)))
