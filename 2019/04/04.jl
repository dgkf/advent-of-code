input = readlines()
@assert(length(input) > 0, "puzzle input must be passed to stdin.")

lb, ub = parse.(Int, split(input, "-"))

n = 0
for i=lb:ub
    is_increasing = true
    sequential_count = 1
    has_sequential_pair = false
    d = reverse(digits(i, base = 10))
    for di=2:length(d)
        if (d[di] < d[di-1]) 
            is_increasing = false
            break
        elseif (d[di] == d[di-1]) 
            sequential_count += 1
        end

        if (d[di] != d[di-1]  || di == length(d)) && sequential_count == 2
            has_sequential_pair = true
            sequential_count = 1
        end

        if  d[di] != d[di-1]
            sequential_count = 1
        end
    end
    if is_increasing && has_sequential_pair
        println(i)
        global n += 1
    end
end
