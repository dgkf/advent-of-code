input = readlines()

input = map(input) do line
    mask_re = match(r"mask = (?<mask>[01X]+)", line)
    if mask_re isa RegexMatch
        return (op = :mask, mask = parse.(Int, replace(split(mask_re["mask"], ""), "X" => "-1")))
    end

    mem_re = match(r"mem\[(?<address>\d+)\] = (?<value>\d+)", line)
    if mem_re isa RegexMatch
        return (op = :mem, address = parse(Int, mem_re["address"]), value = parse(Int, mem_re["value"]))
    end
end


# part 1
function run_with_masked_values(input)
    mask = digits(0, base=2, pad=35)
    mem  = Dict()
    for i = input
        if i[:op] == :mask
            mask = i[:mask]
        elseif i[:op] == :mem
            val = reverse(digits(i[:value], base=2, pad=36))
            res = ifelse.(mask .== -1, val, mask) 
            mem[i[:address]] = sum(reverse(res) .* (2 .^ (0:35)))
        end
    end
    return mem
end

println(sum(values(run_with_masked_values(input))))


# part 2
using Combinatorics

function masked_addrs(mask, addr)
    maskedbits = sum((mask .== -1) .* (2 .^ (35:-1:0)))
    basemask = sum(ifelse.(mask .== -1, 0, mask) .* (2 .^ (35:-1:0)))
    baseaddr = (basemask | addr) & ~maskedbits
    floats = combinations(36 .- findall(mask .== -1))
    return [baseaddr; [baseaddr | sum(2 .^ f) for f = floats]]
end

function run_with_masked_addrs(input)
    mask = []
    mem  = Dict()
    for i = input
        if i[:op] == :mask
            mask = i[:mask]
        elseif i[:op] == :mem
            setindex!.([mem], [i[:value]], masked_addrs(mask, i[:address]))
        end
    end
    return mem
end

println(sum(values(run_with_masked_addrs(input))))

