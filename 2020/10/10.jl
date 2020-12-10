input = parse.(Int, readlines())
input = vcat([0], input, [maximum(input)+3])

# part 1
d = diff(sort(input))
sum(d .== 1) * sum(d .== 3)

# part 2
# figure out how many sequential 1's we have
max_seq_ones = 0
n = 0
for i = diff(sort(input))
    n = i == 1 ? n += 1 : 0
    max_seq_ones = max(max_seq_ones, n)
end

function count_paths(input)
    n = 0
    length(input) == 1 && return 1
    for j = 1:3
        if (input[1] + j) ∈ input
            n += count_paths(input[findfirst(==(input[1] + j), input):end])
        end
    end
    return n
end

# count number of paths given a sequence of n ones
n_seqs = repeat([0], max_seq_ones)
for seq = 1:max_seq_ones
    n_seqs[seq] = count_paths(1:seq+1)
end

# count sequential 1s and multiply by possible number of branching paths
n_paths = 1
n = 0
for i = diff(sort(input))
    if i == 1
        n += 1
    elseif n > 0
        n_paths *= n_seqs[n]
        n = 0
    end
end

