include("../IntCodeVM.jl")
using .IntCodeVM
using LightGraphs
using MetaGraphs
using OffsetArrays
using Base.Iterators: take

verbose = length(ARGS) > 0 && ARGS[1] == "--verbose"

@enum Content Wall Empty Oxygen Unknown
@enum Direction North=1 South=2 West=3 East=4

function Direction(x::CartesianIndex)
    if x == CartesianIndex(0, -1); North
    elseif x == CartesianIndex(0, 1); South
    elseif x == CartesianIndex(-1, 0); West
    elseif x == CartesianIndex(1, 0); East
    end
end

mutable struct RepairDroid
    loc::CartesianIndex
    cpu::IntComp
end

function add_loc!(g, loc, content=Unknown)
    locs = g[:, :loc] 
    if loc in locs; return; end
    add_vertex!(g, :loc, loc)
    set_prop!(g, g[loc, :loc], :content, content)
    for off=[[-1,0],[1,0],[0,1],[0,-1]]
        offset_loc = loc + CartesianIndex(off...)
        if !(offset_loc in locs); continue; end
        content_loc = get_prop(g, g[loc, :loc], :content)
        content_off = get_prop(g, g[offset_loc, :loc], :content)
        weight = content_loc == Wall || content_off == Wall ? Inf : 1
        if !(Edge(g[loc, :loc] => g[offset_loc, :loc]) in edges(g))
            add_edge!(g, g[loc, :loc], g[offset_loc, :loc])
        end
        set_prop!(g, g[loc, :loc], g[offset_loc, :loc], :weight, weight)
    end
end

function set_content!(g, loc, content)
    locs = g[:, :loc]
    if !(loc in locs); return; end
    set_prop!(g, g[loc, :loc], :content, content)
    for off=[[-1,0],[1,0],[0,1],[0,-1]]
        offset_loc = loc + CartesianIndex(off...)
        if offset_loc in locs && Edge(g[loc, :loc] => g[offset_loc, :loc]) in edges(g)
            weight = content == Wall ? Inf : 1
            cur_weight = get_prop(g, g[loc, :loc], g[offset_loc, :loc], :weight)
            set_prop!(g, g[loc, :loc], g[offset_loc, :loc], :weight, cur_weight * weight)
        end
    end
end

function map_loc!(g, loc, content)
    add_loc!(g, loc, content)
    set_content!(g, loc, content)
    if content == Wall; return; end
    for off=[[-1,0],[1,0],[0,1],[0,-1]]
        add_loc!(g, loc + CartesianIndex(off...), Unknown)
    end
end

function render_map(g, droid)
    if length(g) <= 0; return nothing; end
    indices = [v[:loc] for (k,v)=floorplan.vprops]
    contents = [v[:content] for (k,v)=floorplan.vprops]
    contents = replace(contents, Wall => "#", Unknown => ".", Empty => " ", Oxygen => "O")
    dims = maximum(indices) - minimum(indices) + CartesianIndex(1,1)
    grid = OffsetArray(reshape(repeat([" "], prod(Tuple(dims))), Tuple(dims)...), 
        Tuple(minimum(indices) - CartesianIndex(1,1)))
    for (i,c)=zip(indices, contents); grid[i] = c; end
    grid[0,0] = "x"
    grid[droid.loc] = "D"
    sleep(1 / 60)
    run(Sys.iswindows() ? `cmd /c cls` : `clear` )
    println(join(mapslices(join, grid, dims=1), "\n"))
end

# part 1
droid = RepairDroid(CartesianIndex(0, 0), IntComp(IntCompState(intcode())))
floorplan = MetaGraph(SimpleGraph(), 1.0)
Base.getindex(x::MetaGraph, i::Colon, idx::Symbol) = [v[:loc] for (k, v)=x.vprops]
set_indexing_prop!(floorplan, :loc)

map_loc!(floorplan, droid.loc, Empty)
while any([v[:content] == Unknown for (k,v)=floorplan.vprops])
    # navigate to first unknown tile 
    target = first(k for (k, v)=floorplan.vprops if v[:content] == Unknown)
    path = a_star(floorplan, floorplan[droid.loc, :loc], target)
    step = floorplan[path[1].dst, :loc] - floorplan[path[1].src, :loc]
    push!(droid.cpu.state.input, Int(Direction(step)))
    response = popfirst!(droid.cpu.state.output)

    # update map and location after move
    if response == 0; map_loc!(floorplan, droid.loc + step, Wall)
    else; droid.loc += step
    end
    if response == 2; map_loc!(floorplan, droid.loc, Oxygen)
    else; map_loc!(floorplan, droid.loc, Empty)
    end

    if verbose; render_map(floorplan, droid); end
end

oxygen_system = first(k for (k,v)=floorplan.vprops if v[:content] == Oxygen)
println(length(a_star(floorplan, floorplan[CartesianIndex(0,0),:loc], oxygen_system)))

# part 2
println(maximum(length.(enumerate_paths(dijkstra_shortest_paths(floorplan, oxygen_system)))) - 1)

