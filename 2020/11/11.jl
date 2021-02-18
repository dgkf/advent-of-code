input = reduce(hcat, split.(readlines("utils/cache/2020/11/input.txt"), ""))

input = map(input) do i
    i == "." && return 0  # floor
    i == "L" && return 1  # open chair
    i == "#" && return 2  # occupied chair
end

# part 1
function part1(grid)
    Δcoord = CartesianIndices((-1:1, -1:1))
    gridᵢ = deepcopy(grid)
    gridⱼ = deepcopy(grid)
    while true
        for coord = CartesianIndices(size(grid))
            adj = skipmissing(get(gridᵢ, coord + Δc, missing) for Δc = Δcoord if Δc.I != (0, 0))
            gridᵢ[coord] == 1 && sum(adj .== 2) == 0 && (gridⱼ[coord] = 2)
            gridᵢ[coord] == 2 && sum(adj .== 2) >= 4 && (gridⱼ[coord] = 1)
        end
        all(gridᵢ .== gridⱼ) && return sum(gridⱼ .== 2)
        gridᵢ .= gridⱼ
    end
end

println(part1(input))


# part 2
function first_seat(grid, coord, Δcoord)
    coordⱼ = coord + Δcoord
    iⱼ = get(grid, coordⱼ, missing)
    (iⱼ isa Missing || iⱼ != 0) ? iⱼ : first_seat(grid, coordⱼ, Δcoord)
end

function part2(grid)
    Δcoord = CartesianIndices((-1:1, -1:1))
    gridᵢ = deepcopy(grid)
    gridⱼ = deepcopy(grid)
    while true
        for coord = CartesianIndices(size(grid))
            adj = skipmissing(first_seat(gridᵢ, coord, Δc) for Δc = Δcoord if Δc.I != (0, 0))
            gridᵢ[coord] == 1 && sum(adj .== 2) == 0 && (gridⱼ[coord] = 2)
            gridᵢ[coord] == 2 && sum(adj .== 2) >= 5 && (gridⱼ[coord] = 1)
        end
        all(gridᵢ .== gridⱼ) && return sum(gridⱼ .== 2)
        gridᵢ .= gridⱼ
    end
end

println(part2(input))
