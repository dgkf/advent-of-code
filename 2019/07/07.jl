include("../IntCodeVM.jl")
using .IntCodeVM
using Combinatorics

# program execution with multiple processor feedback loop
function run_amps(m, init)
	n = length(init)
	cs = [Channel{Int}(Inf) for i=1:n]
	tasks = [@async(IntCodeVM.exec_intcode!(copy(m), cs[i], cs[rem(i,n)+1])) for i=1:n]
	put!.(cs, init) # initialize with respective amp init
	put!(cs[1], 0)  # push 0 to first amp input
	wait.(tasks)    # wait for all tasks to complete
	take!(cs[1])
end

code = intcode(stdin)
println(maximum(run_amps.([code], permutations(0:4))))
println(maximum(run_amps.([code], permutations(5:9))))

