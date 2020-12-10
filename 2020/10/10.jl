input = parse.(Int, readlines())
input = vcat([0], input, [maximum(input)+3])

# part 1
d = diff(sort(input))
sum(d .== 1) * sum(d .== 3)

# part 2
function count_paths(x)
    length(x) == 1 && return 1
    sum(count_paths(x[findfirst(==(x[1]+j), x):end]) for j = 1:3 if (x[1]+j) ∈ x)
end

splitmap(f::Function, x; keep = true) =  splitmap(f.(x), x; keep = keep)
function splitmap(s::AbstractArray{Bool}, x; keep = true)
    split_idxs = findall(s)
    split_starts = vcat([1], split_idxs .+ (keep ? 0 : 1))
    split_ends = vcat(split_idxs, [length(x)+1])
    [x[i:j-1] for (i,j) = zip(split_starts, split_ends)]
end

sortinput = sort(input)
prod(map(count_paths, splitmap(vcat([false], diff(sortinput) .== 3), sortinput)))

