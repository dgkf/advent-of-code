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
    deg_dist = (atan((astroid.I .- astroids[i].I)...), -sqrt(sum((astroid.I .- astroids[i].I) .^ 2)), astroid.I)
end

out = sort(t, rev = true)

out_i = [o[1] for o=out]
out_i = diff(out_i) .== 0
out_i = reduce((a, b) -> [a..., b == 1 ? last(a) + 1 : 1], out_i, init = [out_i[1]])

out_j = [(i, -o[1], o[2:end]...) for (o, i)=zip(out, out_i)]

out_j = sort(out_j)

println(sum([100, 1] .* out_j[200][4]))
