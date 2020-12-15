input = readlines()
nums = parse.(Int, split(input[1], ","))

function play_game(starting_nums, toN)
    last_obs = Dict(v => idx for (idx, v) = enumerate(starting_nums))
    last_num = last(starting_nums)
    nums_len = length(starting_nums)
    while nums_len < toN
        if last_num ∉ keys(last_obs)
            last_num = 0
        else
            n = last_num
            last_num = nums_len - last_obs[last_num]
            last_obs[n] = nums_len
            last_obs[last_num] = get(last_obs, last_num, nums_len + 1)
        end
        nums_len += 1
    end

    return last_num
end

prinltn(play_game(nums, 2020))
println(play_game(nums, 30_000_000))

