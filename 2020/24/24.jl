function cardinal_to_dir(s)
    s == "e"  && return CartesianIndex( 2, 0)
    s == "w"  && return CartesianIndex(-2, 0)
    s == "ne" && return CartesianIndex( 1, 1)
    s == "sw" && return CartesianIndex(-1,-1)
    s == "se" && return CartesianIndex( 1,-1)
    s == "nw" && return CartesianIndex(-1, 1)
end


directions = map(readlines(stdin)) do line
    [cardinal_to_dir(m.match) for m=eachmatch(r"(?<!s)e|se|sw|(?<!s)w|nw|ne", line)]
end

# part 1
tiles = Dict()
for ds in directions
    pos = reduce(+, ds, init = CartesianIndex(0, 0))
    tiles[pos] = !get(tiles, pos, false)
end
println(sum(values(tiles)))


# part 2
function adjacent_coordinates(coord)
    [coord + off for off = cardinal_to_dir.(["e", "w", "ne", "sw", "se", "nw"])]
end

function adjacent_tiles(tiles, coord)
    map(c -> get(tiles, c, false), adjacent_coordinates(coord))
end

function living_art(tiles, n)
    tiles = deepcopy(tiles)
    for i = 1:n
        # seed surrounding tiles
        for (coord, tile) in tiles
            for adj in adjacent_coordinates(coord)
                get!(tiles, adj, false)
            end
        end

        # update tiles as specified
        tilesnext = deepcopy(tiles)
        for (coord, tile) in tiles
            adjtiles = adjacent_tiles(tiles, coord)
            nblack = sum(adjtiles)
            if tile && (nblack == 0 || nblack > 2)
                tilesnext[coord] = false
            elseif !tile && nblack == 2
                tilesnext[coord] = true
            end
        end

        # only propegate black tiles for next iteration
        tiles = Dict(k => v for (k, v) in tilesnext if v)
    end
    return sum(values(tiles))
end

println(living_art(tiles, 100))


