input = readlines()
@assert(length(input) > 0, "puzzle input must be passed to stdin.")

mem_in = parse.(Int64, split(input[1], ","))

access(mem, i, is_immediate) = is_immediate == 1 ? mem[i] : mem[mem[i]+1]

op_add! = function(m, i, modes)
    m[m[i+3]+1] = access(m, i+1, modes[1]) + access(m, i+2, modes[2])
    return i+4
end

op_mul! = function(m, i, modes)
    m[m[i+3]+1] = access(m, i+1, modes[1]) * access(m, i+2, modes[2])
    return i+4
end

op_store! = function(m, i, modes)
    m[m[i+1]+1] = op_stdin[1]
    return i+2
end

op_output! = function(m, i, modes)
    push!(op_stdout, access(m, i+1, modes[1]))
    return i+2
end

op_jump_if_true! = function(m, i, modes)
    access(m, i+1, modes[1]) == 0 ? i+3 : access(m, i+2, modes[2])+1
end

op_jump_if_false! = function(m, i, modes)
    access(m, i+1, modes[1]) == 0 ? access(m, i+2, modes[2])+1 : i+3
end

op_less_than! = function(m, i, modes)
    m[m[i+3]+1] = access(m, i+1, modes[1]) < access(m, i+2, modes[2]) ? 1 : 0
    return i+4
end

op_equals! = function(m, i, modes)
    m[m[i+3]+1] = access(m, i+1, modes[1]) == access(m, i+2, modes[2]) ? 1 : 0
    return i+4
end

insts = Dict(
    1 => op_add!, 
    2 => op_mul!, 
    3 => op_store!,
    4 => op_output!,
    5 => op_jump_if_true!,
    6 => op_jump_if_false!,
    7 => op_less_than!,
    8 => op_equals!
)

do_op! = function(m, i)
    modes = digits.(div(m[i], 100), base = 10, pad = 3)
    op = rem(m[i], 100)
    insts[op](m, i, modes)
end

run_program = function(mem)
    i = 1
    while rem(mem[i], 100) != 99; i = do_op!(mem, i); end
end

# part 1
op_stdin, op_stdout = [1], []
run_program(copy(mem_in))
println(last(op_stdout))

# part 2
op_stdin, op_stdout = [5], []
run_program(copy(mem_in))
println(last(op_stdout))