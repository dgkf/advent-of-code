raw_input = readlines()

log_regex = r"(?<min>\d+)-(?<max>\d+) (?<l>\w): (?<pw>\w+)"
input = map(match.([log_regex], raw_input)) do i
    Dict(:min => parse(Int, i[:min]),
         :max => parse(Int, i[:max]),
         :l   => i[:l][1],
         :pw  => i[:pw])
end

# part 1
println(sum(i[:min] <= count(==(i[:l]), i[:pw]) <= i[:max] for i = input))

# part 2
println(sum(xor(i[:pw][i[:min]] == i[:l], i[:pw][i[:max]] == i[:l]) for i in input))

