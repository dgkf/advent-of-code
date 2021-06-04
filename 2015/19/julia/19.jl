using Memoization

replacements = map(split(readuntil(stdin, "\n\n"), "\n")) do line
  from, to = split(line, " => ")
  from => to
end

medicine = String(strip(read(stdin, String)))


# extend some base functions
Base.replace(s::String, p::Pair{<:RegexMatch,<:AbstractString}) = 
    s[1:p.first.offset-1] * p.second * s[p.first.offset+length(p.first.match):end]
Base.replace(s::String, p::Pair{<:UnitRange,<:AbstractString}) = 
    s[1:p.first.start-1] * p.second * s[p.first.stop+1:end]



new_molecules = Set()
for (from, to) in replacements
    for fromi in eachmatch(Regex(from), medicine)
        push!(new_molecules, replace(medicine, fromi => to))
    end
end

println(length(new_molecules))



@memoize function find_origin_molecules(molecule, replacements; n = 0)
    length(findall(r"[A-Z]", molecule)) == 1 && return([(n, molecule)])
    repls = [m => from for (from, to) in replacements for m in eachmatch(Regex(to), molecule)]
    length(repls) == 0 && return([(n, molecule)])
    n_mols = unique([find_origin_molecules.(replace.([molecule], repls), [replacements]; n = n + 1)...;])
end

function min_steps_to_create(molecule, replacements; start = "e")
    length_valid_paths = []
    n_mols = [(0, molecule)]

    for (n, molecule) in n_mols
        # break off next part of molecule until the next "Ar" 
        if occursin("Ar", molecule)
            mol_split = String.(split(molecule, r"(?<=Ar)"; limit = 2))
            mol_head, mol_tail = length(mol_split) > 1 ? mol_split : (mol_split, "")
        else
            mol_head = molecule
        end

        # calculate reduced form of the "head" of the molecule, until "Ar"
        new_mol_heads = find_origin_molecules(mol_head, replacements)

        # if reduced forms exist, recombine them with the tail and continue
        for (ni, mol_head_i) in new_mol_heads
            if mol_head_i == start
                push!(length_valid_paths, n + ni)
            elseif mol_head_i != mol_head
                push!(n_mols, (n + ni, mol_head_i * mol_tail))
            end
        end
    end
    minimum(length_valid_paths)
end

println(@time min_steps_to_create(medicine, replacements))
