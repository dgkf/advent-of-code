input <- scan("stdin", "character", quiet = TRUE)

part1 <- function(x) {
  grepl("([aeiou].*){3,}", x) & 
  grepl("(.)\\1", x) & 
  !grepl("ab|cd|pq|xy", x)
}

part2 <- function(x) {
  grepl(".*(..).*\\1", x) & 
  grepl("(.).\\1", x)
}

cat(sum(part1(input)), "\n")
cat(sum(part2(input)), "\n")
