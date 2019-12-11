include("../IntCodeVM.jl")
using .IntCodeVM
using Combinatorics

code = intcode()

# program execution with multiple processor feedback loop
function run_amps(m, init)
    n = length(init)
    cs = [Channel{Int}(Inf) for i=1:n]
    push!.(cs, init)
    push!(cs[1], 0)
    states = [IntCompState(copy(m), 0, 0, cs[i], cs[rem(i,n)+1]) for i=1:n]
    @sync [@async(exec_intcode!(states[i])) for i=1:n]
    take!(states[1].input)
end

println(maximum(run_amps.([code], permutations(0:4))))
println(maximum(run_amps.([code], permutations(5:9))))

