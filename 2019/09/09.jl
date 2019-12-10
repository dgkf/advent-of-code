include("../IntCodeVM.jl")
using .IntCodeVM

code = intcode()

si = [1]
so = []
exec_intcode!(copy(code), si, so)
println(first(so))

si = [2]
so = []
exec_intcode!(copy(code), si, so)
println(first(so))
