foods = map(readlines()) do food
    m = match(r"(?<ingredients>.*)\(contains (?<allergens>.*)\)", food)
    ingredients = string.(split(strip(m["ingredients"]), " "))
    allergens = string.(split(strip(m["allergens"]), ", "))
    (ingredients, allergens)
end

# part 1
allingredients = unique(vcat(first.(foods)...))
allallergies = unique(vcat(last.(foods)...))

allergin_ingredients = Dict(allallergies .=> [allingredients])
for (ingredients, allergins) = foods, allergin = allergins
    allergin_ingredients[allergin] = intersect(allergin_ingredients[allergin], ingredients)
end

possible_allergins = vcat(values(allergin_ingredients)...)
println(sum(i -> length(setdiff(i, possible_allergins)), first.(values(foods))))

# part 2
known_allergins = Dict()
while !all(keys(allergin_ingredients) .∈ [keys(known_allergins)])
    for (allergin, ingredients) = allergin_ingredients
        remaining_ingredients = setdiff(ingredients, values(known_allergins))
        if length(remaining_ingredients) == 1
            known_allergins[allergin] = only(remaining_ingredients)
        end
    end
end

println(join(last.(sort([(k, v) for (k, v) = known_allergins])), ","))
