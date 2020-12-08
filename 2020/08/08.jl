input = readlines("utils/cache/2020/8/input.txt")
input = map(input) do line
    inst, n = split(line, " ")
    (inst, parse(Int, n))
end

function run(inst)
    i = 1
    acc = 0
    evaled = Set()

    while i ∉ evaled && i <= length(inst)
        cmd, n = inst[i]
        evaled = union(evaled, i)
        if cmd == "acc"
            acc += n
            i += 1
        elseif cmd == "jmp"
            i += n
        elseif cmd == "nop"
            i += 1
        end
    end

    return (acc, i == length(inst) + 1)
end

println(run(input)[1])

for i = findall(first.(input) .== "nop")
    new_input = deepcopy(input)
    new_input[i] = ("jmp", input[i][2])
    acc, term = run(new_input)

    if term
        println(acc)
        break
    end
end

for i = findall(first.(input) .== "jmp")
    new_input = deepcopy(input)
    new_input[i] = ("nop", input[i][2])
    acc, term = run(new_input)

    if term
        println(acc)
        break
    end
end


