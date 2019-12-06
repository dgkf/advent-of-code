# read memory from stdin
memory = parse.(Int64, split(readlines()[1], ","))

# create 0-indexed memory type
struct MemoryArray; vec :: AbstractArray; end
Base.getindex(m::MemoryArray, i) = get(m.vec, i .+ 1, 0)
Base.setindex!(m::MemoryArray, val, i) = setindex!(m.vec, val, i .+ 1)

# immediate and parameter mode memory reading with bounded indices
mem_access(m, i, immediate) = immediate ? m[i] : m[m[i]]

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
exec(memory; idx = 0) = while opcode(memory, idx) != 99
	idx = op!(memory, idx)
end

# part 1
op_stdin, op_stdout = [1], []
exec(MemoryArray(copy(memory)))
println(last(op_stdout))

# part 2
op_stdin, op_stdout = [5], []
exec(MemoryArray(copy(memory)))
println(last(op_stdout))

