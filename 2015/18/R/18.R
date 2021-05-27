input <- readLines("stdin")
inputmat <- strsplit(paste0(input, collapse = ""), "")[[1L]]
d <- sqrt(length(inputmat))
lights <- matrix(0L, nrow = d + 2L, ncol = d + 2L)
lights[1:d+1,1:d+1] <- matrix(inputmat == "#", nrow = d, ncol = d)

step <- function(lights) {
  n_neighbors <- lights[1:d,1:d] + 
    lights[1:d,1:d+1] + 
    lights[1:d,1:d+2] + 
    lights[1:d+1,1:d] + 
    lights[1:d+1,1:d+2] +
    lights[1:d+2,1:d] + 
    lights[1:d+2,1:d+1] + 
    lights[1:d+2,1:d+2]

  lights[1:d+1,1:d+1] <- ifelse(
    lights[1:d+1,1:d+1],
    n_neighbors == 2 | n_neighbors == 3,
    n_neighbors == 3)

  lights
}

run <- function(lights, steps = 100L) {
  for (i in seq_len(steps)) lights <- step(lights)
  sum(lights)
}

cat(run(lights), "\n")

run_with_fixed_corners <- function(lights, steps = 100L) {
  lights[1+1,1+1] <- lights[d+1,1+1] <- lights[1+1,d+1] <- lights[d+1,d+1] <- 1L
  for (i in seq_len(steps)) {
    lights <- step(lights)
    lights[1+1,1+1] <- lights[d+1,1+1] <- lights[1+1,d+1] <- lights[d+1,d+1] <- 1L
  }
  sum(lights)
}

cat(run_with_fixed_corners(lights), "\n")
