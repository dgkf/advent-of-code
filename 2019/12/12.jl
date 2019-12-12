using Primes

input = reshape(parse.(Int, getfield.(eachmatch(r"-?\d+", join(readlines())), :match)), 3, :)'

# part 1
pos = copy(input)
vel = zeros(Int, size(input))

for i=1:100
    vel .+= sum([(row' .> pos) - (row' .< pos) for row=eachslice(pos, dims=1)])
    pos .+= vel
end

energy = sum(sum(abs.(pos), dims = 2) .* sum(abs.(vel), dims = 2))
println(energy)


# part 2
orig_pos = copy(input)
pos = copy(orig_pos)
orig_vel = zeros(Int, size(input))
vel = copy(orig_vel)

xs = Int[]
ys = Int[]
zs = Int[]

for i=1:1e6
    vel .+= sum([(row' .> pos) - (row' .< pos) for row=eachslice(pos, dims=1)])
    pos .+= vel
    if all(pos[:,1] .== orig_pos[:,1]) && all(vel[:,1] .== orig_vel[:,1])
        push!(xs, i)
    end
    if all(pos[:,2] .== orig_pos[:,2]) && all(vel[:,2] .== orig_vel[:,2])
        push!(ys, i)
    end
    if all(pos[:,3] .== orig_pos[:,3]) && all(vel[:,3] .== orig_vel[:,3])
        push!(zs, i)
    end
end

f = prod(first.(first.(getfield.(factor.([xs[1], ys[1], zs[1]]), :pe))))
println(xs[1] * ys[1] * zs[1] ÷ f)

