input = parse.(Int, readlines())
input = vcat([0], input, [maximum(input)+3])

# part 1
d = diff(sort(input))
sum(d .== 1) * sum(d .== 3)

# part 2
function count_paths(x)
    length(x) == 1 && return 1
    sum(count_paths(x[findfirst(==(j), x):end]) for j = x[1] .+ (1:3) if j ∈ x)
end

splitmap(f::Function, x; kwargs...) = splitmap(f.(x), x; kwargs...)
splitmap(s::AbstractArray{Bool}, x; kwargs...) = splitmap(findall(s), x; kwargs...) 
function splitmap(s::AbstractArray{Int}, x; keep = true)
    split_starts = vcat(1, s .+ (keep ? 0 : 1))
    split_ends = vcat(s, length(x) + 1)
    [x[i:j-1] for (i,j) = zip(split_starts, split_ends)]
end

sortinput = sort(input)
prod(map(count_paths, splitmap(vcat(false, diff(sortinput) .== 3), sortinput)))

