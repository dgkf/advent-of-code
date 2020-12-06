input = readlines()

# create array of groups (arrays of strings)
groups = split.(split(join(input, "\n"), "\n\n"), "\n")

# part 1
sum(length(union(Set.(group)...)) for group in groups)

# part 2
sum(length(intersect(Set.(group)...)) for group in groups)

