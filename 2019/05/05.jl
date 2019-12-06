input = readlines()
@assert(length(input) > 0, "puzzle input must be passed to stdin.")

memory = parse.(Int64, split(input[1], ","))

# create 0-indexed memory type
struct MemoryArray; vec :: AbstractArray; end
Base.getindex(m::MemoryArray, i) = get(m.vec, i .+ 1, 0)
Base.setindex!(m::MemoryArray, val, i) = setindex!(m.vec, val, i+1)

# immediate and parameter mode memory reading with bounded indices
mem_access(m, i, immediate) = immediate ? m[i] : m[m[i]]

# define opcode behaviors
opcode(m, i) = rem(m[i], 100)
params(m, i) = BitArray(digits.(div(m[i], 100); base=10, pad=3))
op!(m, i) = op!(Val(opcode(m,i)), m, i, mem_access.([m], i.+(1:3), params(m,i)))
op!(c::Val{1}, m, i, ps) = (setindex!(m, ps[1] + ps[2], m[i+3]); i+4)
op!(c::Val{2}, m, i, ps) = (setindex!(m, ps[1] * ps[2], m[i+3]); i+4)
op!(c::Val{3}, m, i, ps) = (setindex!(m, popfirst!(op_stdin), m[i+1]); i+2)
op!(c::Val{4}, m, i, ps) = (push!(op_stdout, ps[1]); i+2)
op!(c::Val{5}, m, i, ps) = (ps[1] != 0 ? ps[2] : i+3)
op!(c::Val{6}, m, i, ps) = (ps[1] == 0 ? ps[2] : i+3)
op!(c::Val{7}, m, i, ps) = (setindex!(m, ps[1] < ps[2], m[i+3]); i+4)
op!(c::Val{8}, m, i, ps) = (setindex!(m, ps[1] == ps[2], m[i+3]); i+4)

# program execution
exec(m; i=0) = while opcode(m, i) != 99
	i = op!(m, i)
end

# part 1
op_stdin, op_stdout = [1], []
exec(MemoryArray(copy(memory)))
println(last(op_stdout))

# part 2
op_stdin, op_stdout = [5], []
exec(MemoryArray(copy(memory)))
println(last(op_stdout))

