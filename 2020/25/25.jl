key1, key2 = parse.(Int, readlines(stdin))

function transform_subject_number(x = 1, subjnum = 7)
    x = (x * subjnum) % 20201227
end

val1 = 1
nloops1 = 0
while key1 != val1
    nloops1 += 1
    val1 = transform_subject_number(val1)
end


val2 = 1
nloops2 = 0
while key2 != val2
    nloops2 += 1
    val2 = transform_subject_number(val2)
end


x = 1
for i = 1:nloops2
    x = transform_subject_number(x, key1)
end

println(x)

