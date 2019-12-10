module IntCodeVM

export intcode, exec_intcode!

using OffsetArrays

struct IntCompState
    mem::AbstractArray{Int}
    i::Int
    rb::Int
    input::AbstractArray{Int}
    output::AbstractArray{Int}
end

getindex(x::IntCompState, i, offset=0) = x.mem[i + offset]
setindex!(x::IntCompState, val, i) = x.mem[i] = val

# intcode instantiation helpers
intcode() = intcode(stdin)
intcode(x::AbstractArray{<:Int}) = _intcode(x)
intcode(x::AbstractArray{<:AbstractString}) = _intcode(parse.(Int64, x))
intcode(x::Union{String,IO}) = intcode(split(readlines(x)[1], ","))
_intcode(x) = OffsetArray(vcat(x, zeros(Int, 1000)), -1)

# opcode interpretation 
opcode(x::IntCompState) = opcode(x.mem, x.i)
opcode(m, i) = rem(m[i], 100)
modes(m, i) = [1, digits.(div(m[i], 100); base = 10, pad = 3)...]
paramidx(::Val{0}, rb, m, i) = get(m, i, -1)       # positional
paramidx(::Val{1}, rb, m, i) = i                   # immediate
paramidx(::Val{2}, rb, m, i) = rb + get(m, i, -1)  # relative base
paramidices(x::IntCompState) = paramidices(x.m, x.rb, x.i)
paramidices(m, rb, i) = paramidx.(Val.(modes(m, i)), rb, [m], i .+ (0:3))

# opcode implementations
op!(x::IntCompState) = op!(Val(opcode(x)), x, paramidices(x))
op!(m, i, rb, si, so) = op!(Val(opcode(m,i)), m, paramidices(m, rb, i)...)
op!(::Val{1}, x, a, b, c, d) = (x[d] = x[b] + x[c]; (a+4, x.rb))
op!(::Val{2}, x, a, b, c, d) = (x[d] = x[b] * x[c]; (a+4, x.rb))
op!(::Val{3}, x, a, b, c, d) = (x[b]] = pop!(x.si); (a+2, x.rb))
op!(::Val{4}, x, a, b, c, d) = (push!(x.so, x[b]); (a+2, x.rb))
op!(::Val{5}, x, a, b, c, d) = (x[b] != 0 ? x[c] : a+3, x.rb)
op!(::Val{6}, x, a, b, c, d) = (x[b] == 0 ? x[c] : a+3, x.rb)
op!(::Val{7}, x, a, b, c, d) = (x[d] = x[b] < x[c]; (a+4, x.rb))
op!(::Val{8}, x, a, b, c, d) = (x[d] = x[b] == x[c]; (a+4, x.rb))
op!(::Val{9}, x, a, b, c, d) = (a+2, x.rb + x[b])

# program execution
tick!(x::IntCompState) = x.i, x.rb = op!(x)

exec_intcode!(m, si, so=[]; i=0, rb=0) = while opcode(m, i) != 99; 
    i, rb = op!(m, i, rb, si, so); 
end

end
