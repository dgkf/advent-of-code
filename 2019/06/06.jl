using SparseArrays
using LightGraphs

input = hcat((split(line, ")") for line=readlines("./utils/cache/2019-6.txt"))...)
bodys = sort(unique(hcat(input...)))

orbits = SimpleDiGraph(sparse(
    findfirst.(.==(input[1,:]), [bodys]),
    findfirst.(.==(input[2,:]), [bodys]), 
    repeat([1], size(input)[2])))

n_orbits = 0
com = findfirst(==("COM"), bodys)
for i=vertices(orbits)
    global n_orbits += length(a_star(orbits, com, i))
end

# part 1
println(n_orbits)

# part 2
you_orbiting = input[1,828]
san_orbiting = input[1,299]
length(a_star(
    SimpleGraph(orbits), 
    findfirst(==(you_orbiting), bodys), 
    findfirst(==(san_orbiting), bodys)))
    