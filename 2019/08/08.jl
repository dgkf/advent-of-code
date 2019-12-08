img = reshape(parse.(Int, split(readlines()[1], "")), 25, 6, :)

println(prod(
    count.(.==([1, 2]), 
    [img[:,:,findmin(sum(img .== 0, dims=[1,2]))[2][3]]])))

println(transpose(
    img[findmax(img .!= 2, dims=3)[2]][:,:,1]))

