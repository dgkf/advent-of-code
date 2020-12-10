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
function splitmap(s::AbstractArray{Bool}, x; keep = true)
    groups = cumsum(s)
    !keep && groups[s] = missing 
    splitmap(cumsum(s), x; kwargs...) 
end
function splitmap(s::AbstractArray{Int}, x; keep = true)
    [x[s .== i] for i = unique(s)]
end

sortinput = sort(input)
prod(map(count_paths, splitmap(vcat(false, diff(sortinput) .== 3), sortinput)))

