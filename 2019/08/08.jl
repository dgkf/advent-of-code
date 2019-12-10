img = reshape(parse.(Int, split(readlines()[1], "")), 25, 6, :)

layer = argmin(sum(img .== 0, dims = [1,2])[3])
println(prod(count.(.==([1, 2]), [img[:,:,layer]])))            

output = img[findmax(img .!= 2, dims = 3)[2]]
println.(mapslices(join, replace(output, 0 => " ", 1 => "#"), dims = 1))

