module IntCodeVM

export intcode, exec_intcode!

using OffsetArrays

# intcode instantiation helpers
intcode(x::AbstractArray{<:Int}) = _intcode(x)
intcode(x::AbstractArray{<:AbstractString}) = _intcode(parse.(Int64, x))
intcode(x::Union{String,IO}) = _intcode(split(readlines(x)[1], ","))
_intcode(x) = OffsetArray(vcat(x, zeros(Int, 1000)), -1)

# opcode interpretation 
opcode(m, i) = rem(m[i], 100)
modes(m, i) = digits.(div(m[i], 100); base=10, pad=3)
param(::Val{0}, rb, m, i) = get(m, get(m, i, -1), 0)
param(::Val{1}, rb, m, i) = get(m, i, 0)
param(::Val{2}, rb, m, i) = get(m, rb + get(m, i, 0), 0)
params(m, rb, i) = param.(Val.(modes(m, i)), rb, [m], i .+ (1:3))

# opcode implementations
op!(m, i, rb, si, so) = op!(Val(opcode(m,i)), m, i, params(m, rb, i), rb, si, so)
op!(::Val{1}, m, i, params, rb, si, so) = (m[m[i+3]] = params[1] + params[2]; i+4)
op!(::Val{2}, m, i, params, rb, si, so) = (m[m[i+3]] = params[1] * params[2]; i+4)
op!(::Val{3}, m, i, params, rb, si, so) = (m[m[i+1]] = pop!(si); i+2)
op!(::Val{4}, m, i, params, rb, si, so) = (push!(so, params[1]); i+2)
op!(::Val{5}, m, i, params, rb, si, so) = (params[1] != 0 ? params[2] : i+3)
op!(::Val{6}, m, i, params, rb, si, so) = (params[1] == 0 ? params[2] : i+3)
op!(::Val{7}, m, i, params, rb, si, so) = (m[m[i+3]] = params[1] < params[2]; i+4)
op!(::Val{8}, m, i, params, rb, si, so) = (m[m[i+3]] = params[1] == params[2]; i+4)
op!(::Val{9}, m, i, params, rb, si, so) = (rb += params[1]; i+2)

# program execution
function exec_intcode!(m,si,so=[];p=0,rb=0) 
    while opcode(m,p) != 99; p = op!(m,p,rb,si,so); end
end

end
