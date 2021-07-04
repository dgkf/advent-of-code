struct Instruction
    name::Symbol
    args::Vector{Any}
end

mutable struct Computer
    reg::Dict{Symbol,Real}
    tape::Vector{Instruction}
    i::Int
end

inst!(comp::Computer, ::Val{:hlf}, reg) = (comp.reg[reg] /= 2; comp.i += 1)
inst!(comp::Computer, ::Val{:tpl}, reg) = (comp.reg[reg] *= 3; comp.i += 1)
inst!(comp::Computer, ::Val{:inc}, reg) = (comp.reg[reg] += 1; comp.i += 1)
inst!(comp::Computer, ::Val{:inc}, reg) = (comp.reg[reg] += 1; comp.i += 1)
inst!(comp::Computer, ::Val{:jmp}, off) = comp.i += off
inst!(comp::Computer, ::Val{:jie}, reg, off) = comp.reg[reg] % 2 == 0 ? comp.i += off : comp.i += 1
inst!(comp::Computer, ::Val{:jio}, reg, off) = comp.reg[reg] == 1 ? comp.i += off : comp.i += 1

function run!(comp::Computer)
    while checkbounds(Bool, comp.tape, comp.i) 
       inst!(comp, Val(comp.tape[comp.i].name), comp.tape[comp.i].args...) 
    end
    comp.reg[:b]
end

instructions = map(readlines(stdin)) do line
    inst, args... = split(line, r",? ")
    inst = Symbol(inst)
    args = [tryparse(Int, arg) isa Nothing ? Symbol(arg) : parse(Int, arg) for arg in args]
    Instruction(inst, args)
end

println(run!(Computer(Dict(:a => 0, :b => 0), instructions, 1)))
println(run!(Computer(Dict(:a => 1, :b => 0), instructions, 1)))

