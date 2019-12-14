using MetaGraphs

input = readlines("./utils/cache/2019-14.txt") 

input = split("157 ORE => 5 NZVS
165 ORE => 6 DCFZ
44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
179 ORE => 7 PSHF
177 ORE => 5 HKGWZ
7 DCFZ, 7 PSHF => 2 XJWVT
165 ORE => 2 GPVTF
3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT", "\n")

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

edges = Edge.(inneighbors(g, g["FUEL", :name]), [g["FUEL", :name]])
set_prop!(g, g["FUEL", :name], :needed, 1)

while length(edges) > 0
    edge = popfirst!(edges)
    
    if !(edge in keys(g.eprops)); continue; end
    if length(outneighbors(g, edge.dst)) > 0
        append!(edges, Edge.([edge.dst], outneighbors(g, edge.dst)))
        continue
    end

    ep = g.eprops[edge]
    println("$(ep[:n_in]) $(g.vprops[edge.src][:name]) -> $(ep[:n_out]) $(g.vprops[edge.dst][:name]) ($(g.vprops[edge.dst][:needed]))")

    set_prop!(g, edge.src, :needed, 
        get(g.vprops[edge.src], :needed, 0) + 
        ep[:n_in] * ceil(g.vprops[edge.dst][:needed] / ep[:n_out]))

    set_prop!(g, edge.src, :excess, 
        get(g.vprops[edge.src], :excess, 0) + 
        ep[:n_in] * (g.vprops[edge.dst][:needed] % ep[:n_out]))
    
    append!(edges, Edge.(inneighbors(g, edge.src), [edge.src]))
    rem_edge!(g, edge.src, edge.dst)
end

println(Int(g.vprops[g["ORE", :name]][:needed]))


# part 2
