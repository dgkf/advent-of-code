

using OffsetArrays

# intcode instantiation helpers
intcode(x::AbstractArray{<:Int}) = _intcode(x)
intcode(x::AbstractArray{<:AbstractString}) = _intcode(parse.(Int64, x))
intcode(x::Union{String,IO}) = _intcode(split(readlines(x)[1], ","))
_intcode(x) = OffsetArray(vcat(x, zeros(Int, 1000)), -1)

# opcode interpretation 
opcode(m, i) = rem(m[i], 100)
modes(m, i) = digits.(div(m[i], 100); base=10, pad=3)
paramidx(::Val{0}, rb, m, i) = get(m, i, -1)
paramidx(::Val{1}, rb, m, i) = i
paramidx(::Val{2}, rb, m, i) = rb + get(m, i, -1)
paramidices(m, rb, i) = paramidx.(Val.(modes(m, i)), rb, [m], i .+ (1:3))
params(m, rb, i) = get.([m], paramidices(m, rb, i), 0)

# opcode implementations
op!(m, i, rb, si, so) = op!(Val(opcode(m,i)), m, i, paramidices(m, rb, i), rb, si, so)
op!(::Val{1}, m, i, pi, rb, si, so) = (m[pi[3]] = m[pi[1]] + m[pi[2]]; (i+4, rb))
op!(::Val{2}, m, i, pi, rb, si, so) = (m[pi[3]] = m[pi[1]] * m[pi[2]]; (i+4, rb))
op!(::Val{3}, m, i, pi, rb, si, so) = (m[pi[1]] = pop!(si); (i+2, rb))
op!(::Val{4}, m, i, pi, rb, si, so) = (push!(so, m[pi[1]]); (i+2, rb))
op!(::Val{5}, m, i, pi, rb, si, so) = (m[pi[1]] != 0 ? m[pi[2]] : i+3, rb)
op!(::Val{6}, m, i, pi, rb, si, so) = (m[pi[1]] == 0 ? m[pi[2]] : i+3, rb)
op!(::Val{7}, m, i, pi, rb, si, so) = (m[pi[3]] = m[pi[1]] < m[pi[2]]; (i+4, rb))
op!(::Val{8}, m, i, pi, rb, si, so) = (m[pi[3]] = m[pi[1]] == m[pi[2]]; (i+4, rb))
op!(::Val{9}, m, i, pi, rb, si, so) = (i+2, rb + m[pi[1]])

# program execution
exec_intcode!(m, si, so=[]; p=0, rb=0) = while opcode(m, p) != 99; 
    p, rb = op!(m, p, rb, si, so); 
end

input = "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"
input = readlines("./utils/cache/2019-9.txt")[1]

code = parse.(Int, split(input, ","))
code = Dict(zip(0:(length(code)-1), code))

si = [2]
so = []
mem = copy(code)
exec_intcode!(mem, si, so)
println(so)
