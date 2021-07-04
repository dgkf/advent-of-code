boss_hp = parse(Int, match(r"\d+", readline(stdin)).match)
boss_dmg = parse(Int, match(r"\d+", readline(stdin)).match)

mutable struct Entity
    hp :: Int
    mana :: Int
    damage :: Int
end

mutable struct BattleState
    hero   :: Entity
    boss   :: Entity
    spells :: Dict{Symbol,Int}
end

spells = [:MagicMissile, :Drain, :Shield, :Poison, :Recharge]
cast(x::Symbol, p::Pair) = cast(Val{x}(), deepcopy(p.first), deepcopy(p.second))
function cast(::Val{:MagicMissile}, hero, boss)
    hero.mana -= 53
    boss.hp -= 4
    hero, boss, 53, Dict()
end
function cast(::Val{:Drain}, hero, boss)
    hero.mana -= 73
    hero.hp += 2
    boss.hp -= 2
    hero, boss, 73, Dict()
end
function cast(::Val{:Shield}, hero, boss)
    hero.mana -= 113
    hero, boss, 113, Dict(:Shield => 6)
end
function cast(::Val{:Poison}, hero, boss)
    hero.mana -= 173
    hero, boss, 173, Dict(:Poison => 6)
end
function cast(::Val{:Recharge}, hero, boss)
    hero.mana -= 229
    hero, boss, 229, Dict(:Recharge => 5)
end

function next_battle_states(state; spells = spells, mana_spent = 0, spells_cast = [], hard_mode = false)
    state = deepcopy(state)

    # hero's turn

    # apply spell effects
    hard_mode && state.hero.hp -= 1
    state.hero.mana += (:Recharge in keys(state.spells)) * 101
    state.boss.hp -= (:Poison in keys(state.spells)) * 3
    state.spells = Dict(k => v - 1 for (k, v) in state.spells if v > 1)

    collect(skipmissing(map(setdiff(spells, keys(state.spells))) do spell
        nstate = deepcopy(state)

        # cast spell
        hero, boss, mana, effects = cast(spell, nstate.hero => nstate.boss)
        nstate = BattleState(hero, boss, Dict(union(nstate.spells, effects)))
        nstate.hero.mana < 0 && return(missing)  # hero can't afford this spell
        nstate.boss.hp <= 0 && return((nstate, mana_spent + mana, [spells_cast; spell]))

        # boss's turn

        # apply spell effects
        nstate.hero.mana += (:Recharge in keys(nstate.spells)) * 101
        nstate.boss.hp -= (:Poison in keys(nstate.spells)) * 3
        nstate.spells = Dict(k => v - 1 for (k, v) in nstate.spells if v > 1)
        nstate.boss.hp <= 0 && return((nstate, mana_spent + mana, [spells_cast; spell]))

        # boss attack
        nstate.hero.hp -= max(nstate.boss.damage - (:Shield in keys(nstate.spells)) * 7, 0)
        nstate.hero.hp <= 0 && return(missing)  # hero defeated

        (nstate, mana_spent + mana, [spells_cast; spell])
    end))
end

function least_mana_victory(state)
    least_mana = Inf
    spells_cast = []
    nstate_costs = [(state, 0, [])]

    while length(nstate_costs) > 0
        nstate_costs = collect(Iterators.flatten(map(nstate_costs) do (state, mana, spells)
            next_battle_states(state; mana_spent = mana, spells_cast = spells)
        end))

        for (state, mana, spells) in nstate_costs
            if state.boss.hp <= 0 && mana < least_mana
                least_mana = mana
                spells_cast = spells
            end
        end

        nstate_costs = [(s, m, sp) for (s, m, sp) in nstate_costs if s.boss.hp > 0 && m < least_mana]
    end

    least_mana, spells_cast
end

hero = Entity(50, 500, 0)
boss = Entity(boss_hp, 0, boss_dmg)
println(least_mana_victory(BattleState(hero, boss, Dict())))
println(least_mana_victory(BattleState(hero, boss, Dict()); hard_mode = true))
