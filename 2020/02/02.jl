raw_input = readlines()

struct PasswordLog
    min::Int
    max::Int
    l::Char
    pw::AbstractString
end

log_regex = r"(?<min>\d+)-(?<max>\d+) (?<l>\w): (?<pw>\w+)"
input = map(match.([log_regex], raw_input)) do i
    PasswordLog(parse(Int, i[:min]), parse(Int, i[:max]), i[:l][1], i[:pw])
end

# part 1
println(sum(i.min ≤ count(==(i.l), i.pw) ≥ i.max for i = input))

# part 2
println(sum(xor(i.pw[i.min] == i.l, i.pw[i.max] == i.l) for i in input))

