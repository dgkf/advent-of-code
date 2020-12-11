input = sort(parse.(Int, readlines()))
input = vcat([0], input, [maximum(input)+3])

# part 1
d = diff(sort(input))
println(sum(d .== 1) * sum(d .== 3))

# part 2: solving for brain teaser trick
function count_paths(x)
    length(x) == 1 && return 1
    sum(count_paths(x[findfirst(==(j), x):end]) for j = x[1] .+ (1:3) if j ∈ x)
end

splitmap(f::Function, x; kwargs...) = 
    splitmap(f.(x), x; kwargs...)

splitmap(s::AbstractArray{Int}, x; kwargs...) = 
    [x[s .== i] for i = unique(skipmissing(s))]

function splitmap(s::AbstractArray{Bool}, x; keep = true)
    groups = cumsum(s)
    !keep && (groups[s] = missing)
    splitmap(cumsum(s), x; keep = keep) 
end

println(prod(map(count_paths, splitmap(vcat(false, diff(input) .== 3), input))))

# part 2: solving by memoising and brute force
const trailing_x = Dict{Array{Int}, Int}()
function count_paths(x)
    length(x) == 1 && return 1
    n = 0
    for j = x[1] .+ (1:3)
        if j ∈ x
            trailing_xi = x[findfirst(==(j), x):end]
            n += get!(trailing_x, trailing_xi) do
                count_paths(trailing_xi)
            end
        end
    end
    return n
end

println(count_paths(input))

