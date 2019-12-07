module IntCodeVM

export intcode, exec_intcode!

using OffsetArrays

# intcode instantiation helpers
intcode(x::AbstractArray{<:Int}) = OffsetArray(x, -1)
intcode(x::AbstractArray{<:AbstractString}) = intcode(parse.(Int64, x))
intcode(x::Union{String,IO}) = intcode(split(readlines(x)[1], ","))

# opcode interpretation 
opcode(m, i) = rem(m[i], 100)
modes(m, i) = BitArray(digits.(div(m[i], 100); base=10, pad=3))
param(m, i, immediate) = get(m, immediate ? i : get(m, i, -1), 0)
params(m, i) = param.([m], i .+ (1:3), modes(m, i))

# opcode implementations
op!(m, i, si, so) = op!(Val(opcode(m,i)), m, i, params(m, i), si, so)
op!(::Val{1}, m, i, params, si, so) = (m[m[i+3]] = params[1] + params[2]; i+4)
op!(::Val{2}, m, i, params, si, so) = (m[m[i+3]] = params[1] * params[2]; i+4)
op!(::Val{3}, m, i, params, si, so) = (m[m[i+1]] = take!(si); i+2)
op!(::Val{4}, m, i, params, si, so) = (put!(so, params[1]); i+2)
op!(::Val{5}, m, i, params, si, so) = (params[1] != 0 ? params[2] : i+3)
op!(::Val{6}, m, i, params, si, so) = (params[1] == 0 ? params[2] : i+3)
op!(::Val{7}, m, i, params, si, so) = (m[m[i+3]] = params[1] < params[2]; i+4)
op!(::Val{8}, m, i, params, si, so) = (m[m[i+3]] = params[1] == params[2]; i+4)

# program execution
exec_intcode!(m,si,so=[];p=0) = while opcode(m,p) != 99; p = op!(m,p,si,so); end

end
