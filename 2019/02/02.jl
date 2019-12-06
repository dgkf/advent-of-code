mem_in = parse.(Int64, split(readlines()[1], ","))

inst_add! = function(mem, i)
    mem[mem[i+3]+1] = mem[mem[i+1]+1] + mem[mem[i+2]+1]
    return 4
end

inst_mul! = function(mem, i)
    mem[mem[i+3]+1] = mem[mem[i+1]+1] * mem[mem[i+2]+1]
    return 4
end

insts = Dict(
    1 => inst_add!, 
    2 => inst_mul!
)

run_program = function(mem)
    idx = 1
    while mem[idx] != 99
        if !(mem[idx] in keys(insts))
            return (nothing, 1)
        end
        idx += insts[mem[idx]](mem, idx)
    end
    return (mem[1], 0)
end

# part 1
mem = copy(mem_in)
mem[[2,3]] .= [12,2]
out, exit_code = run_program(mem)
println(out)

# part 2
for noun = 0:99
    for verb = 0:99
        mem = copy(mem_in)
        mem[[2,3]] .= [noun,verb]
        out, exit_code = run_program(mem)
        
        if out == 19690720
            println(noun * 100 + verb)
            break
        end
    end
end
