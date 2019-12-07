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
op!(c::Val{3}, m, i, params, si, so) = (m[m[i+1]] = take!(si); i+2)
op!(c::Val{4}, m, i, params, si, so) = (put!(so, params[1]); i+2)
op!(c::Val{5}, m, i, params, si, so) = (params[1] != 0 ? params[2] : i+3)
op!(c::Val{6}, m, i, params, si, so) = (params[1] == 0 ? params[2] : i+3)
op!(c::Val{7}, m, i, params, si, so) = (m[m[i+3]] = params[1] < params[2]; i+4)
op!(c::Val{8}, m, i, params, si, so) = (m[m[i+3]] = params[1] == params[2]; i+4)

# program execution
run!(m, si, so=[]; p=0) = while opcode(m, p) != 99; p = op!(m, p, si, so); end; 

# program execution with multiple processor feedback loop
function run_amps(m, init)
	n = length(init)
	cs = repeat([Channel{Int}(0)], n)
	tasks = [@async(run!(copy(m), cs[i], cs[rem(i,n)+1])) for i=1:n]
	put!.(cs, init)  # initialize with respective amp init
	put!(cs[1], 0)   # push 0 to first amp input
	take!(cs[1])     # await output on channel feeding amp 1
end

println(maximum(run_amps.([memory], permutations(0:4))))
println(maximum(run_amps.([memory], permutations(5:9))))

