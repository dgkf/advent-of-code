input = readlines("utils/cache/2020/13/test01.txt")
n = parse(Int, input[1])
buses = parse.(Int, replace(split(input[2], ","), "x" => "-1"))

# part 1
buses_nums = filter(!=(-1), buses)
rems = buses_nums .- n .% buses_nums
buses_nums[findmin(rems)[2]] * findmin(rems)[1] 

# part 2
buses_offsets = (1:length(buses))[buses .!= -1] .- 1


# ex
n = 1068781
prod((((buses_nums .- buses_offsets) .% buses_nums) .* buses_nums)[2:end])

1e12 / 50
