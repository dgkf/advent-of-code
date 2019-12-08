img = reshape(parse.(Int, split(readlines()[1], "")), 25, 6, :)

layer = argmin(reshape(sum(img .== 0, dims=[1,2]),:))
println(prod(count.(.==([1, 2]), [img[:,:,layer]])))            

output = transpose(img[findmax(img .!= 2, dims=3)[2]][:,:,1])
println.(mapslices(x -> join([" ", "#"][(x.==1).+1]), output, dims=2))

