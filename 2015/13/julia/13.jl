using Combinatorics

input = readlines(stdin)

x = Dict{String,Dict{String,Int}}()
for line in input
    rm = match(r"([A-Z][a-z]*).*(gain|lose).*?(\d+).*?([A-Z][a-z]+)", line)
    get!(x, rm[1], Dict{String,Int}())
    x[rm[1]][rm[4]] = (rm[2] == "gain" ? 1 : -1) *  parse(Int, rm[3])
end

println(maximum(permutations(collect(keys(x)))) do p
    sum(x[a][b] + x[b][a] for (a, b) in zip(p, [p[2:end]; p[1]]))
end)

println(maximum(permutations(collect(keys(x)))) do p
    vals = [x[a][b] + x[b][a] for (a, b) in zip(p, [p[2:end]; p[1]])]
    sum(vals) - minimum(vals)
end)
