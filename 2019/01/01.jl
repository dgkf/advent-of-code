@assert isfile("data.txt") "input must be saved in '2019/01/data.txt'"
module_masses = parse.(Int64, readlines("data.txt"))

# part 1
fuel = sum(div.(module_masses, 3) .- 2)
println("Part 1 Fuel Required: $fuel")

# part 2
calc_fuel_required = function(mass)
    fuel = div(mass, 3) - 2
    fuel <= 0 ? 0 : fuel + calc_fuel_required(fuel)
end

fuel = sum(calc_fuel_required.(module_masses))
println("Part 2 Fuel Required: $fuel")
