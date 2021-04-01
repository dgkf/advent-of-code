input <- readLines("stdin")
sequence <- as.integer(strsplit(input, "")[[1]])

step <- function(x) {
  as.vector(vapply(
    split(x, c(0, cumsum(diff(x) != 0))),
    function(xi) c(length(xi), xi[[1]]),
    integer(2L)
  ))
}

for (i in seq_len(50)) {
  sequence <- step(sequence)
  if (i %in% c(40, 50)) cat(length(sequence), "\n")
}

