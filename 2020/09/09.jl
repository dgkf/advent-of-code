using Combinatorics

input = parse.(Int, readlines())

function p1(input, n_preamble = 25)
    for i = (n_preamble+1):length(input)
        pre = input[i-n_preamble:i-1]
        !any(input[i] == x+y for (x,y) = combinations(pre, 2)) && return input[i]
    end
end

n = p1(input)
println(n)

function p2(input, n)
    i = j = 1
    while j <= length(input)
        s = sum(input[i:j])
        s > n ? i += 1 : s < n ? j += 1 : return sum(extrema(input[i:j]))
    end
end

println(p2(input, n))
