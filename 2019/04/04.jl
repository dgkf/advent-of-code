using DataStructures

input = readlines()
@assert(length(input) > 0, "puzzle input must be passed to stdin.")

lb, ub = parse.(Int, split(input[1], "-"))
println(join(sum(hcat(map(lb:ub) do i
	d = digits(i, base = 10)
	c = counter(d)
	all(diff(d) .<= 0) .& [any(values(c) .>= 2), 2 in values(c)]
end...), dims = 2), "\n"))

