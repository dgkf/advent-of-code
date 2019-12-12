include("../IntCodeVM.jl")
using .IntCodeVM
using OffsetArrays
using Base.Iterators: flatten

mutable struct PaintingRobot
    loc::AbstractArray{Int}
    dir::AbstractArray{Int}
    cpu::IntComp
end

left = [0 1; -1 0]
right = [0 -1; 1 0]
turn = OffsetArray([left, right], -1)

function tick!(x::PaintingRobot, panels)
    push!(x.cpu.state.input, panels[x.loc...] < 1 ? 0 : 1)
    panels[x.loc...] = popfirst!(x.cpu.state.output)
    x.dir *= turn[popfirst!(x.cpu.state.output)]
    x.loc .+= x.dir
end

exec_robot!(robot, panels) = while running(robot.cpu); tick!(robot, panels); end

memory = intcode()

# part 1
robot = PaintingRobot([0 0], [0 1], IntComp(IntCompState(memory)))
panels = OffsetArray(-ones(Int, 201, 201), -101, -101)
exec_robot!(robot, panels)
println(sum(panels .>= 0))

# part 2
robot = PaintingRobot([0 0], [0 1], IntComp(IntCompState(memory)))
panels = OffsetArray(-ones(Int, 201, 201), -101, -101)
panels[0, 0] = 1
exec_robot!(robot, panels)

# find and print text within bounds of painted area
b = extrema(reshape(collect(flatten(Tuple.(findall(panels .==1 )))),2,:), dims=2)
println.(mapslices(join, 
    replace(panels[UnitRange(b[1]...), reverse(UnitRange(b[2]...))], 
        0 => " ", 
        1 => "#"), 
    dims = 1))

