input = readlines()

n = parse(Int, input[1])
schedule = parse.(Int, replace(split(input[2], ","), "x" => "-1"))

bus_n = filter(!=(-1), schedule)
bus_dt = (1:length(schedule))[schedule .!= -1] .- 1

# part 1
min_remainder = findmin(bus_n .- n .% bus_n)
println(bus_n[min_remainder[2]] * min_remainder[1])

# part 2
inc = bus_n[1] 
n = 0
for (i, offset) in zip(bus_n[2:end], bus_dt[2:end])
    while (n + offset) % i != 0
        n += inc
    end
    inc = lcm(inc, i)
end
println(n)

