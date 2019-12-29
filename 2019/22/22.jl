input = readlines("./utils/cache/2019-22.txt")

input = split("cut 6
deal with increment 7
deal into new stack", "\n")

# part 1
function cut!(deck, n)
    if n > 0
        cut = deck[1:n]
        deck[1:end-n] = deck[n+1:end]
        deck[end-n+1:end] = cut
    else
        cut = deck[end+n+1:end]
        deck[-n+1:end] = deck[1:end+n]
        deck[1:-n] = cut
    end
    deck
end

function deal_into_new_stack!(deck)
    reverse!(deck)
    deck
end

function deal_with_increment!(deck, n)
    deck[0:(length(deck)-1) .* n .% length(deck) .+ 1] .= deck
    deck
end

deck = [0:10006...]
for (i, line)=enumerate(input)
    m = match(r"cut (-?\d+)", line)
    if m != nothing
        cut!(deck, parse(Int, m.captures[1]))
        continue
    end
    m = match(r"deal with increment (\d+)", line)
    if m != nothing
        deal_with_increment!(deck, parse(Int, m.captures[1]))
        continue
    end
    m = match(r"deal into new stack", line)
    if m != nothing
        deal_into_new_stack!(deck)
        continue
    end
end

println(findfirst(==(2019), deck)-1)

# part 2
idx_at_i_after_cut(i, n_deck, n_cut) =
    (i + n_cut + n_deck) % n_deck

idx_at_i_after_cut(n_cut) = 
    (i, n_deck) -> idx_at_i_after_cut(i, n_deck, n_cut)

idx_at_i_after_new_stack(i, n_deck) = 
    abs(n_deck - i - 1) 

idx_at_i_after_deal(i, n_deck, n_inc) =
    invmod(n_inc, n_deck) * i % n_deck

idx_at_i_after_deal(n_inc) = 
    (i, n_deck) -> idx_at_i_after_deal(i, n_deck, n_inc)

fs = map(input) do line 
    m = match(r"cut (-?\d+)", line)
    if m != nothing; return(idx_at_i_after_cut(parse(Int, m.captures[1]))); end
    m = match(r"deal with increment (\d+)", line)
    if m != nothing; return(idx_at_i_after_deal(parse(Int, m.captures[1]))); end
    m = match(r"deal into new stack", line)
    if m != nothing; return(idx_at_i_after_new_stack); end
end

n_deck = 119315717514047
n_iter = 101741582076661

results = [2020]

for iter=1:1e4
    i = results[end]
    for (fi, f)=reverse([enumerate(fs)...])
        i = f(i, n_deck)
    end
    push!(results, i)
end

