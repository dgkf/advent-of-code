rules = Dict(map(split(readuntil(stdin, "\n\n"), "\n")) do line
    m = match(r"^(\d+): (\"(\w+)\"|([^|]+)|(.+))$", line) 
    m[1] => m[3] isa Nothing ? (m[4] isa Nothing ? "(?:$(m[5]))" : m[4]) : m[3]
end)
input = readlines(stdin)

function resolve(rule)
    ns = [nsi.match for nsi = eachmatch(r"\b\d+\b", rule)]
    n_res = [Regex("\\b$nsi\\b") for nsi = ns]  
    n_rep = [resolve(rules[nsi]) for nsi=ns]
    replace(reduce(replace, n_res .=> n_rep, init = rule), " " => "")
end

# part 1
println(count(contains(Regex("^$(resolve(rules["0"]))\$")), input))

# part 2
rule42 = resolve(rules["42"])
rule31 = resolve(rules["31"])
println(count(contains(Regex("^$rule42+($rule42(?1)?$rule31)\$")), input))
