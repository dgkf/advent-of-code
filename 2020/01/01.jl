using Combinatorics

values = parse.(Int64, readlines())

for part in 1:2
    for i in permutations(values, part + 1)
        if sum(i) == 2020
            println(prod(i))
            break
        end
    end
end

