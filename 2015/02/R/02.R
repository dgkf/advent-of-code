library(microbenchmark)

input <- strsplit(readLines("stdin"), "x")
presents <- t(apply(do.call(rbind, input), 1L, as.numeric))


# individual present version
paper <- function(x, y, z) {
  sides <- c(x * y, y * z, x * z)
  2 * sum(sides) + min(sides) 
}

# for loop version
for_paper <- function(presents) {
  total_paper <- 0L
  for (i in seq_len(nrow(presents)))
    total_paper <- total_paper + paper(presents[i,1], presents[i,2], presents[i,3])
  return(total_paper)
}

# for loop version
for_paper2 <- function(presents) {
  total_paper <- 0L
  for (present in split(presents, seq_len(nrow(presents))))
    total_paper <- total_paper + paper(present[[1]], present[[2]], present[[3]])
  return(total_paper)
}

# vectorized version
total_paper <- function(arr) {
  side1 <- arr[,1] * arr[,2]
  side2 <- arr[,2] * arr[,3]
  side3 <- arr[,1] * arr[,3]
  sum(2 * (side1 + side2 + side3) + pmin(side1, side2, side3))
}

# individual present version
ribbon <- function(x, y, z) {
  around <- 2 * (x + y + z - max(x, y, z))
  bow <- x * y * z
  around + bow
}

# for loop version
for_ribbon <- function(presents) {
  total_ribbon <- 0L
  for (i in seq_len(nrow(presents)))
    total_ribbon <- total_ribbon + ribbon(presents[i,1], presents[i,2], presents[i,3])
  return(total_ribbon)
}

# for loop version
for_ribbon2 <- function(presents) {
  total_ribbon <- 0L
  for (present in split(presents, seq_len(nrow(presents))))
    total_ribbon <- total_ribbon + ribbon(present[[1]], present[[2]], present[[3]])
  return(total_ribbon)
}

# vectorized version
total_ribbon <- function(arr) {
  around <- 2 * (arr[,1] + arr[,2] + arr[,3] - pmax(arr[,1], arr[,2], arr[,3]))
  bow <- arr[,1] * arr[,2] * arr[,3]
  sum(around + bow)
}

cat("For Loop (By Index):\n")
print(microbenchmark::microbenchmark(
  "#1" = for_paper(presents),
  "#2" = for_ribbon(presents)
))
cat("\n")

cat("For Loop (By Destructuring):\n")
print(microbenchmark::microbenchmark(
  "#1" = for_paper2(presents),
  "#2" = for_ribbon2(presents)
))
cat("\n")

cat("Apply:\n")
print(microbenchmark::microbenchmark(
  "#1" = sum(apply(presents, 1L, function(r) do.call(paper, as.list(r)))),
  "#2" = sum(apply(presents, 1L, function(r) do.call(ribbon, as.list(r))))
))
cat("\n")

cat("Vectorized:\n")
print(microbenchmark::microbenchmark(
  "#1" = total_paper(presents),
  "#2" = total_ribbon(presents)
))
cat("\n")

cat(total_paper(presents), "\n")
cat(total_ribbon(presents), "\n")

