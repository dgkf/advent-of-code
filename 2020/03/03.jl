input = readlines()
trees = reshape([i == '#' for i = join(input)], :, length(input))
tx, ty = size(trees)

dirs = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]
n_trees = [0, 0, 0, 0, 0]

for (i, d) = enumerate(dirs)
    xs = mod1.(range(1; length = ty ÷ d[2], step = d[1]), tx)
    ys = range(1; length = ty ÷ d[2], step = d[2])
    n_trees[i] = sum(trees[CartesianIndex.(xs, ys)])
end

println(n_trees[2])
println(prod(n_trees))
