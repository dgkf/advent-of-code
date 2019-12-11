include("../IntCodeVM.jl")
using .IntCodeVM
using OffsetArrays

# read memory from stdin
memory = OffsetArray(parse.(Int64, split(readlines()[1], ",")), -1)

# run part 1 & 2 inputs and print last stdout entries
state = IntCompState(copy(memory), 0, 0, [1], [])
exec_intcode!(state)
println(last(state.output))

state = IntCompState(copy(memory), 0, 0, [5], [])
exec_intcode!(state)
println(last(state.output))

