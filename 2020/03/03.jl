input = readlines()
trees = reshape([i == '#' for i = join(input)], :, length(input))

strides = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]
n_trees = repeat([0], length(strides))
tx, ty  = size(trees)

for (i, stride) = enumerate(strides)
    xs = mod1.(range(1; length = ty ÷ stride[2], step = stride[1]), tx)
    ys = range(1; length = ty ÷ stride[2], step = stride[2])
    n_trees[i] = sum(trees[CartesianIndex.(xs, ys)])
end

println(n_trees[2])
println(prod(n_trees))
