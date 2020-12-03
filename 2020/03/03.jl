input = readlines()
trees = reshape([i == '#' for i=join(input)], :, length(input))

dirs = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]
n_trees = [0, 0, 0, 0, 0]

for (i, d) = enumerate(dirs)
    coords = [1, 1]
    while coords[2] <= size(trees)[2]
        n_trees[i] += trees[coords[1], coords[2]]
        coords = [mod1(coords[1] + d[1], size(trees)[1]), coords[2] + d[2]]
    end
end

println(n_trees[2])
print(prod(n_trees))




