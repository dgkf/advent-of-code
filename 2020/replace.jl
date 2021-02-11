import Base.findall, Base.replace

findall(t::Char, s::AbstractString) = findall([s[i] == t for i = eachindex(s)])

function replace(x::AbstractString, old_new::Pair...; count::Union{Int, Nothing} = nothing)
    count isa Nothing && (count = Inf)

    # find all matches of "old" within x; Array of "new" => replacement range
    locs = vcat([new .=> findall(old, x) for (old, new) = old_new]...)

    # sort replacement locations by start and length
    locs = sort(locs, by = i -> (first(i.second), -last(i.second)))
    
    # reduce replacement locations, only applies replacement if the match
    #   - is found in the original string "x"
    #   - starts before any other overlapping matches
    #   - is the longest of any other overlapping matches
    str, n = reduce(locs; init = ("", 1)) do (str, n), (new, loc)
        if count > 0 && first(loc) >= n
            count -= 1
            !isempty(methods(new)) && (new = new(x[first(loc):last(loc)]))
            (str * x[n:first(loc)-1] * new, last(loc) + 1)
        else
            (str, n)
        end
    end

    return convert(typeof(x), str * x[n:end])
end

