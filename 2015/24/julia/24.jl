using Combinatorics

items = parse.(Int, readlines(stdin))

function items_max_legroom_min_entanglement(items; n=3)
  group_sum = sum(items) / n
  max_n_items = findfirst(cumsum(sort(items)) .> group_sum)
  min_n_items = findfirst(cumsum(sort(items, rev = true)) .> group_sum)
  n_items = min_n_items
  possible_group_items = []

  while length(possible_group_items) == 0
    for group_items in combinations(items, n_items)
      sum(group_items) != group_sum && continue
      rem_items = setdiff(items, group_items)
      any_rem_group_sum = any(sum(c) == group_sum 
        for n in div(length(rem_items), 2):-1:min_n_items 
        for c in combinations(rem_items,n))
      any_rem_group_sum && push!(possible_group_items, group_items)
    end
    n_items += 1
  end

  minimum(prod.(possible_group_items))
end

println(items_max_legroom_min_entanglement(items))
println(items_max_legroom_min_entanglement(items, n=4))
