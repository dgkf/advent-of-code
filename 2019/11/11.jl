include("../IntCodeVM.jl")
using .IntCodeVM
using OffsetArrays
using Base.Iterators: flatten

mutable struct PaintingRobot
    loc::AbstractArray{Int}
    dir::AbstractArray{Int}
    cpu::IntCompState
end
                            
turn!(x::PaintingRobot, cw::Bool=true) = turn!(x, (cw * 2) - 1)
turn!(x::PaintingRobot, cw::Int=1) = x.dir = [cw * x.dir[2], -cw * x.dir[1]]

function tick!(x::PaintingRobot, panels)
    push!(x.cpu.input, panels[x.loc...] < 1 ? 0 : 1)
    panels[x.loc...] = popfirst!(x.cpu.output)
    turn!(x, popfirst!(x.cpu.output) == 1)
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

# find and print text within bounds of painted area
b = extrema(reshape(collect(flatten(Tuple.(findall(panels .==1 )))),2,:), dims=2)
println.(mapslices(join, 
    replace(panels[reverse(UnitRange(b[1]...)), UnitRange(b[2]...)], 
        0 => " ", 
        1 => "#"), 
    dims = 1))


