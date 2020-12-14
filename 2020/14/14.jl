
input = readlines("utils/cache/2020/14/test02.txt")
input = readlines("utils/cache/2020/14/input.txt")

input = map(input) do line
    mask_re = match(r"mask = ([01X]+)", line)
    if mask_re isa RegexMatch
        return (:mask, (parse.(Int, replace(split(mask_re[1], ""), "X" => "-1")),))
    end

    mem_re = match(r"mem\[(\d+)\] = (\d+)", line)
    if mem_re isa RegexMatch
        return (:mem, (parse(Int, mem_re[1]), parse(Int, mem_re[2])))
    end
end


mask = digits(0, base=2, pad=35)
mem  = Dict()
for (op, args) = input
    if op == :mask
        mask = args[1]
    elseif op == :mem
        val = reverse(digits(args[2], base=2, pad=36))
        res = ifelse.(mask .== -1, val, mask) 
        mem[args[1]] = sum(reverse(res) .* (2 .^ (0:35)))
    end
end

println(sum(values(mem)))


using Combinatorics

function masked_addrs(mask, addr)
    maski = deepcopy(mask)

    addrs = []
    floats = findall(mask .== -1)

    maski[floats] .= 0
    val = reverse(digits(addr, base=2, pad=36))
    res = ifelse.(mask .== -1, maski, val) 
    println(res)
    push!(addrs, sum(reverse(res) .* (2 .^ (0:35))))

    for float1s = combinations(floats)
        float0s = setdiff(floats, float1s) 
        maski[float1s] .= 1
        maski[float0s] .= 0
        val = reverse(digits(addr, base=2, pad=36))
        res = ifelse.(mask .== -1, maski, val) 
        println(res)
        push!(addrs, sum(reverse(res) .* (2 .^ (0:35))))
    end

    return addrs
end

mask = []
mem  = Dict()
for (op, args) = input
    if op == :mask
        mask = deepcopy(args[1])
    elseif op == :mem
        println(mask)
        addrs = masked_addrs(mask, args[1])
        println(addrs)
        for addr = addrs
            mem[addr] = args[2]
        end
    end
end

println(sum(values(mem)))

