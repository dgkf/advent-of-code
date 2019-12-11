include("../IntCodeVM.jl")
using .IntCodeVM

memory = intcode()

state = IntCompState(copy(memory), 0, 0, [1], [])
exec_intcode!(state)
println(first(state.output))

state = IntCompState(copy(memory), 0, 0, [2], [])
exec_intcode!(state)
println(first(state.output))
