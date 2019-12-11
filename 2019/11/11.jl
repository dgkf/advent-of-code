include("../IntCodeVM.jl")
using .IntCodeVM
using OffsetArrays

mutable struct PaintingRobot
    loc::AbstractArray{Int}
    dir::AbstractArray{Int}
    cpu::IntCompState
end
                            
turn_right!(x::PaintingRobot) = x.dir = [x.dir[2], -x.dir[1]]
turn_left!(x::PaintingRobot) = x.dir = [-x.dir[2], x.dir[1]]

function tick!(x::PaintingRobot, panels)
    push!(x.cpu.input, panels[x.loc...] < 1 ? 0 : 1)
    panels[x.loc...] = popfirst!(x.cpu.output)
    popfirst!(x.cpu.output) == 0 ? turn_left!(x) : turn_right!(x)
    x.loc .+= x.dir
end

function exec_robot!(robot, panels)
    while opcode(robot.cpu) != 99
        tick!(robot, panels)
    end
end

memory = intcode()

# part 1
state = IntCompState(copy(memory), 0, 0, Channel{Int}(Inf), Channel{Int}(Inf))
task = @async exec_intcode!(state)
robot = PaintingRobot([0, 0], [0, 1], state)
panels = OffsetArray(-ones(Int, 201, 201), -101, -101)
exec_robot!(robot, panels)
println(sum(panels .>= 0))

# part 2
state = IntCompState(copy(memory), 0, 0, Channel{Int}(Inf), Channel{Int}(Inf))
task = @async exec_intcode!(state)
robot = PaintingRobot([0, 0], [0, 1], state)
panels = OffsetArray(-ones(Int, 201, 201), -101, -101)
panels[0, 0] = 1
exec_robot!(robot, panels)

println.(mapslices(join, 
    replace(panels[0:50, 0:-1:(-5)], -1 => " ", 0 => " ", 1 => "#"), 
    dims = 1))


