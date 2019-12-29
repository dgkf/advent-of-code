include("../IntCodeVM.jl")
using .IntCodeVM

code = intcode()

# part 1
cpu = IntComp(IntCompState(code))

springscript = "
NOT C J
NOT B T
OR T J
NOT A T
OR T J
AND D J
WALK
"

while length(cpu.state.output.data) > 0
    popfirst!(cpu.state.output)
end

for char=Int.([Char(i) for i=lstrip(springscript)])
    push!(cpu.state.input, char)
end

try; print(join(Char.(cpu.state.output.data)))
catch e; println(last(cpu.state.output.data))
end


# part 2
cpu = IntComp(IntCompState(code))

springscript = "
NOT C J
NOT B T
OR T J
NOT A T
OR T J
AND D J
NOT E T
NOT T T
OR H T
AND T J
RUN
"

while length(cpu.state.output.data) > 0
    popfirst!(cpu.state.output)
end

for char=Int.([Char(i) for i=lstrip(springscript)])
    push!(cpu.state.input, char)
end

try; print(join(Char.(cpu.state.output.data))); println(cpu.state.time);
catch e; println(last(cpu.state.output.data))
end

