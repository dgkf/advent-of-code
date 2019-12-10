using OffsetArrays

input = readlines("./utils/cache/2019-10.txt")
astroids = reshape([i == '#' for i=join(input)], length(input), :)
astroids = findall(OffsetArray(astroids, -1, -1) .== 1)

(n, i) = findmax(map(astroids) do astroid
    slopes = [(other.I[1] > astroid.I[1] , /((other.I .- astroid.I)...)) for other=astroids if other != astroid]
    length(unique(slopes))
end)

println(n)

t = map(astroids) do astroid
    deg_dist = (atan((astroid.I .- astroids[i].I)...), -sqrt(sum((astroid.I .- astroids[i].I) .^ 2)), astroid.I...)
end

out = sort(t, rev = true)

ns = [x[1] for x=out]
