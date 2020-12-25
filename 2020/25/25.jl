key1, key2 = parse.(Int, readlines("utils/cache/2020/25/input.txt"))

function transform_subject_number(subjnum = 7)
    Channel{Int}(1) do c while true
        x = 1
        while true
            x = (x * subjnum) % 20201227
            push!(c, x)
        end
    end
end

nloops1 = first(i for (i, v) = enumerate(transform_subject_number()) if v == key1)
println(first(v for (i, v) = enumerate(transform_subject_number(key2)) if i == nloops1))
