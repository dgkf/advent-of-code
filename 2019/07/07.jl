include("../IntCodeVM.jl")
using .IntCodeVM
using Combinatorics

# program execution with multiple processor feedback loop
function run_amps(m, init)
    n = length(init)
    cs = [Channel{Int}(Inf) for i=1:init]
    push!.(cs, init)
    push!(cs[1], 0)
    @sync [@async(exec_intcode!(copy(m), cs[i], cs[rem(i,n)+1])) for i=1:n]
    take!(cs[1])
end

code = intcode(stdin)

println(maximum(run_amps.([code], permutations(0:4))))
println(maximum(run_amps.([code], permutations(5:9))))

