input = readlines()
@assert(length(input) > 0, "puzzle input must be passed to stdin.")

# create 0-indexed memory type
struct MemoryArray; vec :: AbstractArray; end
Base.copy(m::MemoryArray) = MemoryArray(copy(m.vec))
Base.getindex(m::MemoryArray, i) = m.vec[i.+1]
Base.getindex(m::MemoryArray, i, memcode) = mem_access(m, i, memcode)
Base.setindex!(m::MemoryArray, val, i) = setindex!(m.vec, val, i+1)
access(m, i, imm) = (imm ? i : m[i])+1 > length(m.vec) ? 0 : imm ? m[i] : m[m[i]]

# define opcode behaviors
opcode(m, i) = rem(m[i], 100)
params(m, i) = BitArray(digits.(div(m[i], 100); base=10, pad=3))
op!(m, i) = op!(Val(opcode(m,i)), m, i, access.([m], i.+(1:3), params(m,i)))
op!(c::Val{1}, m, i, ps) = (i+4, setindex!(m, ps[1] + ps[2], m[i+3]))
op!(c::Val{2}, m, i, ps) = (i+4, setindex!(m, ps[1] * ps[2], m[i+3]))
op!(c::Val{3}, m, i, ps) = (i+2, setindex!(m, popfirst!(op_stdin), m[i+1]))
op!(c::Val{4}, m, i, ps) = (i+2, push!(op_stdout, ps[1]))
op!(c::Val{5}, m, i, ps) = (ps[1] != 0 ? ps[2] : i+3, nothing)
op!(c::Val{6}, m, i, ps) = (ps[1] == 0 ? ps[2] : i+3, nothing)
op!(c::Val{7}, m, i, ps) = (i+4, setindex!(m, ps[1] < ps[2], m[i+3]))
op!(c::Val{8}, m, i, ps) = (i+4, setindex!(m, ps[1] == ps[2], m[i+3]))
runprog(m; i=0) = while opcode(m, i) != 99; i, _ = op!(m, i); end

# read input as MemoryArray
mem = MemoryArray(parse.(Int64, split(input[1], ",")))

# part 1
op_stdin, op_stdout = [1], []
runprog(copy(mem))
println(last(op_stdout))

# part 2
op_stdin, op_stdout = [5], []
runprog(copy(mem))
println(last(op_stdout))

