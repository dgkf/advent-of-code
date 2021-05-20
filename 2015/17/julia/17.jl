using Combinatorics
using Counters

input = parse.(Int, readlines(stdin))

println(length(filter(==(150), sum.(combinations(input)))))

counts = counter(length.(filter(==(150) ∘ sum, collect(combinations(input)))))
println(counts[minimum(counts)])
