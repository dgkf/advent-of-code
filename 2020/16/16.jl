# parse input
rule_re = r"([\w ]+): (\d+)-(\d+) or (\d+)-(\d+)"
rules = map(split(readuntil(stdin, "\n\n"), "\n")) do line
    m = match(rule_re, line)
    (m[1], parse(Int, m[2]):parse(Int, m[3]), parse(Int, m[4]):parse(Int, m[5]))
end

myticket = parse.(Int, split(split(readuntil(stdin, "\n\n"), "\n")[2], ","))

tickets  = map(readlines(stdin)[2:end]) do line
    parse.(Int, split(line, ","))
end

# part 1
invalid_tickets = []
invalid_values = []
for (i, ticket) in enumerate(tickets)
    for value in ticket
        if !any([value ∈ rule[2] || value ∈ rule[3] for rule in rules])
            push!(invalid_tickets, i)
            push!(invalid_values, value)
        end
    end
end

println(sum(invalid_values))

# part 2
deleteat!(tickets, invalid_tickets)

ruleidxs = Dict()
for (name, a, b) in rules
    for valueidx = 1:length(tickets[1])
        values = get.(tickets, valueidx, -1)
        if all(values .∈ [union(a, b)])
            current = get!(ruleidxs, name, [])
            ruleidxs[name] = [current; valueidx]
        end
    end
end

knownruleidxs = Dict()
while any(length.(values(ruleidxs)) .> 0)
    fixk, fixv = first((k, v) for (k, v) = ruleidxs if length(v) == 1)
    knownruleidxs[fixk] = only(fixv)
    setindex!.([ruleidxs], setdiff.(values(ruleidxs), [fixv]), keys(ruleidxs))
end

println(prod([myticket[v] for (k, v) in knownruleidxs if startswith(k, "departure")]))

