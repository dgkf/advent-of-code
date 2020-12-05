input = readlines("./utils/cache/2020/5/input.txt")
seat_ids = map(input) do i
    i = split(i, "") .∈ [["B", "R"]]
    8 * sum(i[1:7] .* (2 .^ (6:-1:0))) + sum(i[8:10] .* (2 .^ (2:-1:0)))
end

println(maximum(seat_ids))

all_seat_ids = collect(minimum(seat_ids):maximum(seat_ids))
println(all_seat_ids[findfirst(all_seat_ids .∉ [seat_ids])])
