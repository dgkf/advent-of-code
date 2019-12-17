include("../IntCodeVM.jl")
using .IntCodeVM

verbose = length(ARGS) && ARGS[1] == "--verbose"
program = intcode()


# part 1
cpu = IntComp(IntCompState(program))
data = cpu.state.output.data

if verbose; println(join(Char.(data))); end

mat = reshape(data[1:(length(data)-1)], findfirst(==(10), data), :)
sum_alignments = 0
for x=2:(size(mat,1)-1), y=2:(size(mat,2)-1)
    if all([mat[x,y], mat[x-1,y], mat[x+1,y], mat[x,y-1], mat[x,y+1]] .∈ [[35, 94]])
        println(x)
        global sum_alignments += (x-1) * (y-1)
    end
end
println(sum_alignments)


# part 2
# good old fashioned pen and paper
# A  R,12,L,10,L,10,
# B  L,6,L,12,R,12,L,4,
# A  R,12,L,10,L,10,
# B  L,6,L,12,R,12,L,4,
# C  L,12,R,12,L,6, 
# B  L,6,L,12,R,12,L,4
# C  L,12,R,12,L,6,
# A  R,12,L,10,L,10
# C  L,12,R,12,L,6,
# C  L,12,R,12,L,6

rout = "A,B,A,B,C,B,C,A,C,C\n"
Aseq = "R,12,L,10,L,10\n"
Bseq = "L,6,L,12,R,12,L,4\n"
Cseq = "L,12,R,12,L,6\n"
code = [Int(i) for i=join([rout, Aseq, Bseq, Cseq, "n\n"])]

program_movement = copy(program)
program_movement[0] = 2
cpu = IntComp(IntCompState(program_movement))
for i=code; push!(cpu.state.input, i); end
println(last(cpu.state.output.data))

