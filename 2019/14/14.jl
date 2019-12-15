using MetaGraphs

verbose = length(ARGS) && ARGS[1] == "--verbose"
input = readlines("./utils/cache/2019-14.txt") 

# part 1
compounds = sort(unique([c.match for lc=eachmatch.([r"[A-Z]+"], input) for c=lc]))
compounds = Dict(k => v for (k,v)=zip(compounds, 1:length(compounds)))
g = MetaDiGraph(length(compounds), 1.0)
set_indexing_prop!(g, :name)

for line=input
    reagents, products = split.(split(line, " => "), ", ")
    n, product = split(products[1], " ")
    set_prop!(g, compounds[product], :name, product)
    for (rn, reagent)=split.(reagents, " ")
        set_prop!(g, compounds[reagent], :name, reagent)
        add_edge!(g, compounds[reagent], compounds[product])
        set_prop!(g, compounds[reagent], compounds[product], :n_out, parse(Int, n)) 
        set_prop!(g, compounds[reagent], compounds[product], :n_in, parse(Int, rn))
    end
end

function calc_ore_to_make(graph, n=1)
    g = copy(graph) 
      edges = Edge.(inneighbors(g, g["FUEL", :name]), [g["FUEL", :name]])
      set_prop!(g, g["FUEL", :name], :needed, n)

    while length(edges) > 0
        edge = popfirst!(edges)
        
        if length(outneighbors(g, edge.dst)) > get(g.vprops[edge.dst], :accounted, 0)
            append!(edges, [edge])
            continue
        end

        ep = g.eprops[edge]
        src = g.vprops[edge.src]
        dst = g.vprops[edge.dst]

        if verbose
            println("$(ep[:n_in]) $(src[:name]) -> $(ep[:n_out]) $(dst[:name]) ($(Int(dst[:needed])))")
        end

        set_prop!(g, edge.src, :accounted, 
            get(g.vprops[edge.src], :accounted, 0) + 1)
        set_prop!(g, edge.src, :needed, 
            get(src, :needed, 0) + ep[:n_in] * ceil(dst[:needed] / ep[:n_out]))
        set_prop!(g, edge.src, :excess, 
            get(src, :excess, 0) + ep[:n_in] * (dst[:needed] % ep[:n_out]))

        append!(edges, setdiff(Edge.(inneighbors(g, edge.src), [edge.src]), edges))
    end
    Int(g.vprops[g["ORE",:name]][:needed])
end

println(calc_ore_to_make(g, 1))


# part 2
search = [5e11, 1e12, 0]
max_fuel = 0
while (search[2] / 2^search[3]) > 0.5
    ore_needed = calc_ore_to_make(g, search[1])
    diff = search[2] / 2^search[3]
    global max_fuel = Int(max(ore_needed > 1e12 ? 0 : search[1], max_fuel))
    global search[1] += ore_needed > 1e12 ? -ceil(diff) : floor(diff)
    if verbose
        println(Int.(search))
        println(ore_needed)
        print("Max: "); println(max_fuel)
    end
    search[3] += 1
end

println(max_fuel)

