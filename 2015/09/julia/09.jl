using Combinatorics

towns = Set{String}()
leg_dists = Dict{Tuple,Int}()

map(readlines(stdin)) do line
    m = match(r"(\w+) to (\w+) = (\d+)", line)
    union!(towns, [m[1], m[2]])
    leg_dists[(m[2], m[1])] = leg_dists[(m[1], m[2])] = parse(Int, m[3])
end

trip_dists = map(permutations(collect(towns))) do stops
    sum(leg_dists[leg] for leg in zip(stops[1:end-1], stops[2:end]))
end

println(minimum(trip_dists))
println(maximum(trip_dists))
