using OffsetArrays
using IterTools

input = readlines("./utils/cache/2019-10.txt")
asteroids = reshape([i == '#' for i=join(input)], length(input), :)
asteroids = findall(OffsetArray(asteroids, -1, -1) .== 1)

# part 1
(n, i) = findmax(map(asteroids) do a
    length(unique([atan((a.I .- b.I)...) for b=asteroids if b != a]))
end)

t = asteroids[i]
println(n)

# part 2
out = map(asteroids) do a
    # angle                 # distance
    (atan((a.I .- t.I)...), sqrt(sum((a.I .- t.I) .^ 2)), a.I)
end

out = sort(out, by = x -> (-x[1], x[2]))
out = [Iterators.flatten(map(enumerate, groupby(x -> x[1], out)))...]
out = sort(out, by = x -> (x[1], -x[2][1]))
println(sum([100, 1] .* out[200][2][3]))

