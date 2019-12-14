include("../IntCodeVM.jl")
using .IntCodeVM
using OffsetArrays


memory = intcode()

# part 1
cpu = IntComp(IntCompState(memory))
wait(cpu.state.output)
output = reshape(cpu.state.output.data, 3, :)'
println(count(output[:,3] .== 2))

# part 2
display_dim = maximum(output[:,[1,2]], dims=1) .+ 1
display = OffsetArray(zeros(Int8, display_dim...), -1, -1)

memory_w_quarters = copy(memory)
memory_w_quarters[0] = 2
cpu = IntComp(IntCompState(memory_w_quarters))
wait(cpu.state.output)

function render_display(display, x, score)
    # println("\33[2J") # clear console
    run(Sys.iswindows() ? `cmd /c cls` : `clear` )
    println(); print("SCORE: "); println(score)

    for row=eachrow(x)
        if row[1] == -1; continue; end
        display[row[1], row[2]] = row[3]
    end

    println(join(map(join, eachcol(replace(display,
        0 => " ",
        1 => "#",
        2 => "B",
        3 => "=",
        4 => "O"))), "\n"))
    println(join(div.([(0:(size(display, 1)) - 1)...], 10)))
    println(join([(0:(size(display, 1) - 1))...] .% 10))

    flush(stdout)
end

score = 0
render = length(ARGS) > 0 && ARGS[1] .== "--show"
paddle_loc = [0 0]
ball_loc = [0 0]
ball_vel = [0 0]
while length(cpu.state.output.data) > 0
    # read out all buffered output
    output = reshape([popfirst!(cpu.state.output) for i=1:length(cpu.state.output.data)], 3, :)'

    if any(output[:,1] .== -1)
        global score = output[output[:,1] .== -1, 3][1]
    end
    if any(output[:,3] .== 3)
        global paddle_loc = output[output[:,3] .== 3,[1,2]]
    end   
    if any(output[:,3] .== 4)
        new_ball_loc = output[output[:,3] .== 4,[1,2]]
        global ball_vel = new_ball_loc .- ball_loc
        global ball_loc = new_ball_loc
    end   
    
    ball_proj = ball_loc .+ ball_vel
    push!(cpu.state.input, cmp(ball_proj[2] >= paddle_loc[2] ? ball_loc[1] : ball_proj[1], paddle_loc[1]))
    
    if render; render_display(display, output, score); end
    sleep(1/60)
    
    if !running(cpu.state); break; end
    wait(cpu.state.output)
end

output = reshape([popfirst!(cpu.state.output) for i=1:length(cpu.state.output.data)], 3, :)'
println(output[output[:,1] .== -1, 3][1])

