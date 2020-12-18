input = readlines()

eval_replace(s, x::Pair...) = 
    eval(Meta.parse(reduce((l, r) -> replace(l, r), x; init = s)))

⨦(a,b) = a * b  # define "multiplication" with same precedence as "+"
println(sum(map(l -> eval_replace(l, "*" => "⨦"), input)))

⨱(a,b) = a + b  # define "addition" with precedence of "*"
println(sum(map(l -> eval_replace(l, "*" => "⨦", "+" => "⨱"), input)))
