input = read(stdin, String)

seamonster = """
             
                               # 
             #    ##    ##    ###
              #  #  #  #  #  #   
             """

seamonster = Array{Bool}(reshape(replace(split(join(split(seamonster, "\n")), ""), "#" => 1, " " => 0), :, 3)')

tiles = Dict(map(split(input, "\n\n")[1:end-1]) do region
    region = split(region, "\n")
    id = parse(Int, match(r"\d+", region[1]).match)
    grid = reshape([c == "#" for c = split.(join(region[2:end]), "")], :, length(region)-1)'
    id => grid
end)

function printtile(grid)
    println.(map(r -> join(ifelse.(r, '#', '.')), eachrow(grid)))
    return nothing
end

function getedges(grid)
    Dict(
        :l => grid[1:end,     1], 
        :b => grid[end  , 1:end], 
        :r => grid[1:end,   end], 
        :t => grid[1    , 1:end])
end



# part 1

corners = Dict()
for (id, tile) in tiles
    tileedges = collect(values(getedges(tile)))
    othertiledges = vcat([[collect(values(getedges(v))); reverse.(collect(values(getedges(v))))] for (k, v) = tiles if k != id]...)
    edgematches = tileedges .∈ [othertiledges]
    if sum(edgematches) == 2
        corners[id] = (tile, edgematches)
    end
end

println(prod(keys(corners)))


# part 2

# create array of nothings to slot in our placed tiles
puzzletiles = reshape(
    repeat(Array{Union{Tuple,Nothing}}([nothing]), 
    length(tiles)), 
    Int(sqrt(length(tiles))), 
    :)

# determine location of our first corner
cornerid = first(keys(corners))
corneredges = corners[cornerid][2]
cornercoord = 1 .+ (size(puzzletiles) .- 1) .* (corneredges[[1,4]] .- corneredges[[2,3]])
puzzletiles[CartesianIndex(cornercoord...)] = (pop!(tiles, cornerid),)

# create a Dict of offsets to use for querying neighboring tiles
puzzletileoffsets = Dict(
    :l => CartesianIndex( 0, -1),
    :r => CartesianIndex( 0,  1),
    :b => CartesianIndex( 1,  0),
    :t => CartesianIndex(-1,  0))

# loop through unfilled tiles, slotting in tiles when we can
while length(tiles) > 0
    for puzzletilecoord = findall(puzzletiles .== nothing)
        # populate known adjacent edges
        adjedges = Dict{Symbol,Any}(:l => nothing, :r => nothing, :t => nothing, :b => nothing)
        puzzlel = get(puzzletiles, puzzletilecoord + puzzletileoffsets[:l], nothing)
        !(puzzlel isa Nothing) && (adjedges[:l] = getedges(only(puzzlel))[:r])
        puzzler = get(puzzletiles, puzzletilecoord + puzzletileoffsets[:r], nothing)
        !(puzzler isa Nothing) && (adjedges[:r] = getedges(only(puzzler))[:l])
        puzzlet = get(puzzletiles, puzzletilecoord + puzzletileoffsets[:t], nothing)
        !(puzzlet isa Nothing) && (adjedges[:t] = getedges(only(puzzlet))[:b])
        puzzleb = get(puzzletiles, puzzletilecoord + puzzletileoffsets[:b], nothing)
        !(puzzleb isa Nothing) && (adjedges[:b] = getedges(only(puzzleb))[:t])
        # break if we have no edge requirements
        all(values(adjedges) .== nothing) && continue
        # find tile that could fit
        tileadded = false
        for (idx, tile) = tiles, rot = 0:3, flip = [true, false] 
            tilei = rotl90(flip ? tile' : tile, rot)
            edges = getedges(tilei)
            # if all required edges match appropriately, pop! tile into place
            if ((adjedges[:l] isa Nothing || adjedges[:l] == edges[:l]) && 
                (adjedges[:r] isa Nothing || adjedges[:r] == edges[:r]) && 
                (adjedges[:t] isa Nothing || adjedges[:t] == edges[:t]) && 
                (adjedges[:b] isa Nothing || adjedges[:b] == edges[:b]))
                puzzletiles[puzzletilecoord] = (tilei,)
                pop!(tiles, idx)
                break
            end
        end
    end
end

# compile tiles into our grid
sizetile = size(only(puzzletiles[1,1])) .- (2, 2)
puzzlegrid = zeros(Bool, size(puzzletiles) .* sizetile)
for c = CartesianIndices(puzzletiles)
    x, y = c.I
    xrange = ((x-1) * sizetile[1] + 1):(x * sizetile[1])
    yrange = ((y-1) * sizetile[2] + 1):(y * sizetile[2])
    puzzlegrid[xrange,yrange] .= only(puzzletiles[c])[2:end-1,2:end-1]
end

xmax, ymax = size(puzzlegrid) .- size(seamonster)
scanx, scany = UnitRange.(1, size(seamonster))
for rot = 0:3, flip = [true, false]
    nseamonsters = 0
    singlegridi = rotl90(flip ? puzzlegrid' : puzzlegrid, rot)
    for x = 1:xmax, y = 1:ymax
        mati = @view singlegridi[x .+ scanx, y .+ scany]
        nseamonsters += all(mati[seamonster])
    end
    if nseamonsters > 0
        println(sum(puzzlegrid) - nseamonsters * sum(seamonster))
        break
    end
end

