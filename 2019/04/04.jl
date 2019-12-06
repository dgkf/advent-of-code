using DataStructures

lb, ub = parse.(Int, split(readlines()[1], "-"))
println(join(sum(map(lb:ub) do i
	d = digits(i, base = 10)
	c = counter(d)
	all(diff(d) .<= 0) .& [any(values(c) .>= 2), 2 in values(c)]
end), "\n"))

