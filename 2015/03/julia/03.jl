input = split(readlines(stdin)[1], "")

data = vcat([[0, 0]], map(input) do char
    char == ">" && return [1, 0]
    char == "v" && return [0, -1]
    char == "<" && return [-1, 0]
    char == "^" && return [0, 1]
end)

println(length(unique(cumsum(data))))
println(length(unique([cumsum(data[1:2:end]); cumsum(data[2:2:end])])))

