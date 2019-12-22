include("../IntCodeVM.jl")
using .IntCodeVM
using OffsetArrays

verbose = get(ARGS, "--verbose", false)

# part 1
code = intcode()
points = OffsetArray(zeros(Bool, 50, 50), (-1,-1))

for (x, y)=Tuple.(CartesianIndices(points))
    println((x, y))
    cpu = IntComp(IntCompState(code))
    push!(cpu.state.input, x)
    push!(cpu.state.input, y)
    points[x, y] = popfirst!(cpu.state.output)
end

if verbose
    println(join(mapslices(
        join, 
        replace(points, 0 => ".", 1 => "#"), 
        dims=1), "\n"))
end

println(sum(points))

# part 2
idxs = Tuple.(CartesianIndices(points))
slope = ifelse.(points .== 1, last.(idxs) ./ first.(idxs), [missing])
slope_lb, slope_ub = [filter(!isnan, skipmissing(slope))] .|> (minimum, maximum)

y_ubs = OffsetArray([1], -1)
y_lbs = OffsetArray([1], -1)
for x=1:2e3
    println(x)

    ly = last(y_ubs)
    ny = ly
    for y=ly .+ (0:5)
        cpu = IntComp(IntCompState(code))
        push!(cpu.state.input, x)
        push!(cpu.state.input, y)
        ret = popfirst!(cpu.state.output)
        if ret == 1; ny = y; break; end
    end
    append!(y_ubs, [ny])

    ly = last(y_lbs)
    ny = ly
    found_y = false
    for (i, y)=enumerate(ly .+ (0:5))
        cpu = IntComp(IntCompState(code))
        push!(cpu.state.input, x)
        push!(cpu.state.input, y)
        ret = popfirst!(cpu.state.output)
        if ret == 1; found_y = true; end
        if ret == 0 && found_y; ny = y - 1; break; end
    end
    append!(y_lbs, [ny])
end

Ox = 0
Oy = 0
n = 100
for x=Int.(0:(2e3 - 100))
    if y_ubs[x + (n-1)] == y_lbs[x] - (n-1) 
        global Ox, Oy = x, y_lbs[x] - (n-1)
        break
    end
end

println("$Ox$Oy")

