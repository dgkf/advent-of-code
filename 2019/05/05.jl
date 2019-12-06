using OffsetArrays

# read memory from stdin
memory = OffsetArray(parse.(Int64, split(readlines()[1], ",")), -1)

# immediate and parameter mode memory reading with bounded indices
mem_access(m, i, immediate) = immediate ? get(m, i, 0) : get(m, m[i], 0)

# define opcode behaviors
opcode(m, i) = rem(m[i], 100)
params(m, i) = BitArray(digits.(div(m[i], 100); base=10, pad=3))
op!(m, i) = op!(Val(opcode(m,i)), m, i, mem_access.([m], i.+(1:3), params(m,i)))
op!(c::Val{1}, m, i, params) = (m[m[i+3]] = params[1] + params[2]; i+4)
op!(c::Val{2}, m, i, params) = (m[m[i+3]] = params[1] * params[2]; i+4)
op!(c::Val{3}, m, i, params) = (m[m[i+1]] = popfirst!(op_stdin); i+2)
op!(c::Val{4}, m, i, params) = (push!(op_stdout, params[1]); i+2)
op!(c::Val{5}, m, i, params) = (params[1] != 0 ? params[2] : i+3)
op!(c::Val{6}, m, i, params) = (params[1] == 0 ? params[2] : i+3)
op!(c::Val{7}, m, i, params) = (m[m[i+3]] = params[1] < params[2]; i+4)
op!(c::Val{8}, m, i, params) = (m[m[i+3]] = params[1] == params[2]; i+4)

# program execution
run(memory; i=0) = while opcode(memory, i) != 99; i = op!(memory, i); end

# part 1
op_stdin, op_stdout = [1], []
run(copy(memory))
println(last(op_stdout))

# part 2
op_stdin, op_stdout = [5], []
run(copy(memory))
println(last(op_stdout))

