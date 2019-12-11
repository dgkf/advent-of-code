using OffsetArrays
using Base.Iterators: flatten
using IterTools: groupby

input = readlines()
asteroids = reshape([i == '#' for i=join(input)], length(input), :)
asteroids = Tuple.(findall(OffsetArray(asteroids, -1, -1) .== 1))

# part 1
(n, i) = findmax(map(asteroids) do a
    length(unique([atan((a .- b)...) for b=asteroids if b != a]))
end)

t = asteroids[i]
println(n)

# part 2
#(angle            , distance                , (x, y))
[(atan((a .- t)...), sqrt(sum((a .- t) .^ 2)), a) for a=asteroids] |> 
    (a -> sort(a, by = x -> (-x[1], x[2]))) |>               # -angle, +distance
    (a -> [flatten(map(enumerate, groupby(first, a)))...]) |> 
    (a -> sort(a, by = x -> (x[1], -x[2][1]))) |>            # +n, -angle
    (a -> println(sum([100, 1] .* a[200][2][3])))

