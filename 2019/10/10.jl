using OffsetArrays
using Base.Iterators: flatten
using IterTools: groupby

input = readlines()
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
    # angle                 # distance                    # (x, y)
    (atan((a.I .- t.I)...), sqrt(sum((a.I .- t.I) .^ 2)), a.I)
end

out = sort(out, by = x -> (-x[1], x[2])) # -angle, +distance
out = [flatten(map(enumerate, groupby(x -> x[1], out)))...]
out = sort(out, by = x -> (x[1], -x[2][1])) # +n, -angle
println(sum([100, 1] .* out[200][2][3]))

