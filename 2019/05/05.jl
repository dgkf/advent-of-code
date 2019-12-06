using OffsetArrays

# read memory from stdin
memory = OffsetArray(parse.(Int64, split(readlines()[1], ",")), -1)

# opcode interpretation 
opcode(m, i) = rem(m[i], 100)
modes(m, i) = BitArray(digits.(div(m[i], 100); base=10, pad=3))
param(m, i, immediate) = get(m, immediate ? i : m[i], 0)
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
run(m, si, so=[]; i=0) = (while opcode(m, i) != 99; i = op!(m, i, si, so); end; so)

# run part 1 & 2 inputs and print last stdout entries
println(last(run(copy(memory), [1])))
println(last(run(copy(memory), [5])))

