input = readlines("utils/cache/2020/5/input.txt")
seat_ids = map(input) do i
    i = split(i, "") .∈ [["B", "R"]]
    sum(i .* (2 .^ (9:-1:0)))
end

# part 1
println(maximum(seat_ids))

# part 2
all_ids = UnitRange(extrema(seat_ids)...)
println(all_ids[findfirst(i -> i ∉ seat_ids, all_ids)])
