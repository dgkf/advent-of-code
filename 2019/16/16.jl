using Base.Iterators: flatten

data = parse.(Int, split(readlines()[1], ""))

# part 1
function filter_transmission(data, n)
    data = copy(data)
    seq = [0, 1, 0, -1] 
    filter = reshape(collect(flatten(map(enumerate(data)) do (i, d)
        filter_i = repeat(seq, inner=i, outer=Int(ceil(length(data)/length(seq)/i)+1))
        filter_i[(1:length(data)).+1]
    end)), length(data), length(data))

    for i=1:n
        data = map(i -> abs(digits(i)[1]), filter' * data)
    end

    data
end

println(join(filter_transmission(data, 100)[1:8]))

# part 2
function hacky_filter_transmission(data, n, offset)
    data = copy(data)[(offset+1):end]
    for i=1:n
        data = reverse(abs.(cumsum(reverse(data)) .% 10))
    end
    data
end

offset = parse(Int, join(string.(data[1:7])))
println(join(hacky_filter_transmission(repeat(data, Int(1e4)), 100, offset)[1:8]))


