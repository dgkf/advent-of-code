input = readlines()

# crate array of groups (arrays of strings)
groups = split.(split(join(input, "\n"), "\n\n"), "\n")

# part 1
sum(map(group -> length(union(Set.(group)...)), groups))

# part 2
sum(map(group -> length(intersect(Set.(group)...)), groups))

