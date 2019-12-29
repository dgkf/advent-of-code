include("../IntCodeVM.jl")
using .IntCodeVM

verbose = "--verbose" in ARGS

firmware = intcode()

struct Packet
    addr::Int
    x::Int
    y::Int
end

struct NIC
    addr::Int
    cpu::IntComp
    queue::Array{Packet,1}
end

nics_init = Dict()
for i=[0:49..., 255]
    cpu = IntComp(IntCompState(firmware))
    push!(cpu.state.input, i)
    nics_init[i] = NIC(i, cpu, Packet[])
end

# part 1
nics = copy(nics_init)
while isempty(nics[255].queue)
    # for some reason my code doesn't run without this?
    print("")
    # add new packets from outputs
    for (i, nic)=nics
        while length(nic.cpu.state.output.data) > 0
            out = Packet((popfirst!(nic.cpu.state.output) for i=1:3)...)
            push!(nics[out.addr].queue, out)
            if verbose
                println("sending packet from computer $i => $(out.addr)")
            end
        end
    end
    # distribute queued packets
    for (i, nic)=nics
        if i == 255; continue; end
        if length(nic.queue) > 0
            while length(nic.queue) > 0
                packet = popfirst!(nic.queue)
                if verbose
                    println("receiving packet $packet at nic $(nic.addr)")
                end
                push!(nic.cpu.state.input, packet.x)
                push!(nic.cpu.state.input, packet.y)
            end
        else
            push!(nic.cpu.state.input, -1)
        end
    end
end

println(first(nics[255].queue).y)

# part 2
nics = copy(nics_init)
ys_to_addr_zero = []
while length(ys_to_addr_zero) < 2 || length(unique(ys_to_addr_zero[end-1:end])) > 1
    # for some reason my code doesn't run without this?
    print("")
    # add new packets from outputs
    for (i, nic)=nics
        while length(nic.cpu.state.output.data) > 0
            out = Packet((popfirst!(nic.cpu.state.output) for i=1:3)...)
            if out.addr == 255
                while !isempty(nics[out.addr].queue)
                    pop!(nics[out.addr].queue)
                end
            end
            push!(nics[out.addr].queue, out)
            if verbose
                println("sending packet from computer $i => $(out.addr)")
            end
        end
    end
    # distribute queued packets
    is_idle = true
    for (i, nic)=nics
        if i == 255; continue; end
        if length(nic.queue) > 0
            while length(nic.queue) > 0
                packet = popfirst!(nic.queue)
                if verbose
                    println("receiving packet $packet at nic $(nic.addr)")
                end
                push!(nic.cpu.state.input, packet.x)
                push!(nic.cpu.state.input, packet.y)
            end
            is_idle = false
        else
            push!(nic.cpu.state.input, -1)
        end
    end
    # send idle packet to addr 0
    if is_idle
        packet = popfirst!(nics[255].queue)
        push!(nics[0].cpu.state.input, packet.x)
        push!(nics[0].cpu.state.input, packet.y)
        push!(ys_to_addr_zero, packet.y)
    end
end

println(last(ys_to_addr_zero))

