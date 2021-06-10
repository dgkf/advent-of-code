using Primes
using Combinations

input = parse(Int, readline(stdin))

house = 1
while true
    fac_combos = combinations(factor(Vector, house))
    n = (1 + sum(prod.(unique(fac_combos)))) * 10
    n >= input && break
    house += 1
end
println(house)

house = 1
while true
    fac_combos = combinations(factor(Vector, house))
    n = (1 + sum(filter(i -> house ÷ i <= 50, prod.(unique(fac_combos))))) * 11
    n >= input && break
    house += 1
end
println(house)

