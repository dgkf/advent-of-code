input = readlines()
@assert(length(input) > 0, "puzzle input must be passed to stdin.")

module_masses = parse.(Int64, input[1])

# part 1
fuel = sum(div.(module_masses, 3) .- 2)
println(fuel)

# part 2
calc_fuel_required = function(mass)
    fuel = div(mass, 3) - 2
    fuel <= 0 ? 0 : fuel + calc_fuel_required(fuel)
end

fuel = sum(calc_fuel_required.(module_masses))
println(fuel)
