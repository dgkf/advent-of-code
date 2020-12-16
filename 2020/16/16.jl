# parse input
rule_re = r"([\w ]+): (\d+)-(\d+) or (\d+)-(\d+)"
rules = map(split(readuntil(stdin, "\n\n"), "\n")) do line
    rule = match(rule_re, line)
    (rule[1], parse(Int, rule[2]):parse(Int, rule[3]), parse(Int, rule[4]):parse(Int, rule[5]))
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
    setindex!.([ruleidxs], [setdiff(v, fixv) for (k, v) = ruleidxs], keys(ruleidxs))
end

println(prod([myticket[only(v)] for (k, v) in knownruleidxs if startswith(k, "departure")]))

