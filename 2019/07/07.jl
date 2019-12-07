using OffsetArrays
using Combinatorics

# read memory from stdin
memory = OffsetArray(parse.(Int64, split(readlines()[1], ",")), -1)

# opcode interpretation 
opcode(m, i) = rem(m[i], 100)
modes(m, i) = BitArray(digits.(div(m[i], 100); base=10, pad=3))
param(m, i, immediate) = get(m, immediate ? i : get(m, i, -1), 0)
params(m, i) = param.([m], i .+ (1:3), modes(m, i))

# opcode implementations
op!(m, i, si, so) = op!(Val(opcode(m,i)), m, i, params(m, i), si, so)
op!(c::Val{1}, m, i, params, si, so) = (m[m[i+3]] = params[1] + params[2]; i+4)
op!(c::Val{2}, m, i, params, si, so) = (m[m[i+3]] = params[1] * params[2]; i+4)
op!(c::Val{3}, m, i, params, si, so) = (m[m[i+1]] = popfirst!(si); i+2)
op!(c::Val{4}, m, i, params, si, so) = (push!(so, params[1]); i+2)
op!(c::Val{5}, m, i, params, si, so) = (params[1] != 0 ? params[2] : i+3)
op!(c::Val{6}, m, i, params, si, so) = (params[1] == 0 ? params[2] : i+3)
op!(c::Val{7}, m, i, params, si, so) = (m[m[i+3]] = params[1] < params[2]; i+4)
op!(c::Val{8}, m, i, params, si, so) = (m[m[i+3]] = params[1] == params[2]; i+4)

# program execution
function run(m, si, so=[]; p=0) 
    while opcode(m, p) != 99
        if opcode(m, p) == 3 && length(si) < 1; return (p, false); end
        p = op!(m, p, si, so)
    end
    (p, true)
end

# program execution with multiple processor feedback loop
function run_feedback(m, n, si=repeat([[]], n); p=repeat([0], n))
    ms = [copy(m) for i=1:n]
    term = repeat([false], n)
    i = 1
    while !all(term)
        (p[i], term[i]) = run(ms[i], si[i], si[rem(i,n)+1]; p=p[i])
        i = rem(i,n)+1
    end
    return last(si[i])
end

# part 1
max_signal = 0
for stdins=permutations(0:4)
    stdins = [[i] for i=stdins]
    append!(stdins[1], 0)
    global max_signal = max(max_signal, run_feedback(memory, 5, stdins))
end

println(max_signal)


# part 2
max_signal = 0
for stdins=permutations(5:9)
    stdins = [[i] for i=stdins]
    append!(stdins[1], 0)
    global max_signal = max(max_signal, run_feedback(memory, 5, stdins))
end

println(max_signal)
