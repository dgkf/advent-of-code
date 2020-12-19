rules = Dict(map(split(readuntil(stdin, "\n\n"), "\n")) do line
    m = match(r"^(\d+): (\"(\w+)\"|([^|]+)|(.+))$", line) 
    m[1] => something(m[3], m[4], "(?:$(m[5]))")
end)
input = readlines(stdin)

function resolve(rs, i)
    matches = [i.match for i=eachmatch(r"\b\d+\b", rs[i])] 
    oldnews = [Regex("\\b$m\\b") => resolve(rs, m) for m=matches]
    replace(reduce(replace, oldnews; init=rs[i]), " " => "")
end

# part 1
rule0 = resolve(rules, "0")
println(count(contains(Regex("^$rule0\$")), input))

# part 2
rule42 = resolve(rules, "42")
rule31 = resolve(rules, "31")
println(count(contains(Regex("^$rule42+($rule42(?1)?$rule31)\$")), input))
