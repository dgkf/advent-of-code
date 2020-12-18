input = readlines()

⨦(a,b) = a * b  # define "multiplication" with same precedence as "+"
println(sum(l -> eval(Meta.parse(replace(l, "*" => "⨦"))), input))

⨱(a,b) = a + b  # define "addition" with precedence of "*"
println(sum(l -> eval(Meta.parse(replace(replace(l, "*" => "⨦"), "+" => "⨱"))), input))
