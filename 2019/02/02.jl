include("../IntCodeVM.jl")
using .IntCodeVM

memory = intcode()

# part 1
mem = copy(memory)
mem[[1, 2]] .= [12, 2]
cpu = IntComp(IntCompState(mem))
wait(cpu.task)
println(cpu.state.mem[0])

# part 2
for noun = 0:99, verb = 0:99
    mem = copy(memory)
    mem[[1,2]] .= [noun, verb]
    cpu = IntComp(IntCompState(mem))
    wait(cpu.task)
    if cpu.state.mem[0] == 19690720
        println(noun * 100 + verb)
        break
    end
end

