using Combinatorics

struct Item
    cost :: Int
    damage :: Int
    armor :: Int
end

mutable struct Entity
    hp :: Int
    items :: Array{Item}
end

damage(x::Entity) = sum(getfield.(x.items, :damage))
armor(x::Entity) = sum(getfield.(x.items, :armor))
cost(x::Entity) = sum(getfield.(x.items, :cost))

weapons = [
    Item(8, 4, 0),
    Item(10, 5, 0),
    Item(26, 6, 0),
    Item(40, 7, 0),
    Item(74, 8, 0)
]

armors = [
    Item(13, 0, 1),
    Item(31, 0, 2),
    Item(53, 0, 3), 
    Item(75, 0, 4),
    Item(102, 0, 5)
]

rings = [
    Item(25, 1, 0),
    Item(50, 2, 0),
    Item(100, 3, 0),
    Item(20, 0, 1),
    Item(40, 0, 2),
    Item(80, 0, 3)
]


input = Dict(map(readlines(stdin)) do line
    name, val = split(line, ": ")
    name => parse(Int, val)
end)

boss = Entity(input["Hit Points"], [Item(0, input["Damage"], input["Armor"])])


battle_cost_extrema = function(boss)
    min_cost_to_win = Inf
    max_cost_to_lose = -Inf

    for w in weapons, 
        as in Iterators.flatten(combinations.([armors], [0, 1])), 
        rs in Iterators.flatten(combinations.([rings], [0, 1, 2]))

        player_i = Entity(100, [w, as..., rs...])
        boss_i = deepcopy(boss)

        while player_i.hp > 0 && boss_i.hp > 0
            boss_i.hp -= damage(player_i) - armor(boss_i)
            player_i.hp -= damage(boss_i) - armor(player_i)
        end

        player_i.hp > 0 && (min_cost_to_win = min(min_cost_to_win, cost(player_i)))
        boss_i.hp > 0 && (max_cost_to_lose = max(max_cost_to_lose, cost(player_i)))
    end

    min_cost_to_win, max_cost_to_lose
end

min_cost_to_win, max_cost_to_lose = battle_cost_extrema(boss)

println(min_cost_to_win)
println(max_cost_to_lose)
