y, x = (parse(Int, m.match) for m in eachmatch(r"\d+", readline(stdin)))

function magic_number(x, y)
  n = 20151125
  for i in 2:(sum(1:(x+y-2))+x)
    n = rem(n * 252533, 33554393)
  end
  n
end

println(magic_number(x, y))
