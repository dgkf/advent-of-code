using DataStructures

input = readlines()
@assert(length(input) > 0, "puzzle input must be passed to stdin.")

lb, ub = parse.(Int, split(input[1], "-"))

# part 1
println(sum(map(lb:ub) do i
    d = digits(i, base = 10)
	all(diff(d) .<= 0) && any(values(counter(d)) .>= 2)
end))

# part 2
println(sum(map(lb:ub) do i
    d = digits(i, base = 10)
	all(diff(d) .<= 0) && 2 in values(counter(d))
end))

