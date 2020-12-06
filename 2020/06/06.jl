input = read(stdin, String)

# create array of groups (arrays of strings)
groups = split.(split(input, "\n\n"), "\n")

# part 1
sum(length(union(Set.(group)...)) for group in groups) |> println

# part 2
sum(length(intersect(Set.(group)...)) for group in groups) |> println

