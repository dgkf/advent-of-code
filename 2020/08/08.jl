input = readlines("utils/cache/2020/8/input.txt")
input = map(input) do line
    inst, n = split(line, " ")
    (Symbol(inst), parse(Int, n))
end

exec_cmd(s::Symbol, n) = exec_cmd(Val(s), n)
exec_cmd(::Val{:acc}, n) = [1, n]
exec_cmd(::Val{:jmp}, n) = [n, 0]
exec_cmd(::Val{:nop}, n) = [1, 0]

function run(inst)
    mem = [1, 0]  # i, acc
    evaled = Set()
    while mem[1] ∉ evaled && mem[1] <= length(inst)
        evaled = union(evaled, mem[1])
        mem += exec_cmd(inst[mem[1]]...)
    end
    return (mem[2], mem[1] > length(inst))
end

println(run(input)[1])

for (fixfrom, fixto) = [:nop => :jmp, :jmp => :nop], 
    fixidx = findall(first.(input) .== fixfrom)

    new_input = deepcopy(input)
    new_input[fixidx] = (fixto, new_input[fixidx][2])
    acc, success = run(new_input)
    success && println(acc) isa Nothing && break
end


