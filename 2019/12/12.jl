using Primes

input = parse.(Int, hcat(split.(readlines(), r"[^-0-9]+", keepempty=false)...))'

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

i = 1
repeat_i = [0, 0, 0]
while any(repeat_i .== 0)
    vel .+= sum([(row' .> pos) - (row' .< pos) for row=eachslice(pos, dims=1)])
    pos .+= vel
    ax = (sum(pos .!= orig_pos, dims=1) .+ sum(vel .!= orig_vel, dims=1)) .== 0
    if (any(ax)); global repeat_i[[((repeat_i .== 0) .& ax')...]] .= i; end
    global i += 1
end

# print least common multiple
println(prod([f^p for (f,p)=merge(max, factor.([Dict], repeat_i)...)]))

