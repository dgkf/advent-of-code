input <- sort(as.integer(readLines("stdin")))

n_container_combos <- function(sizes, vol = 150L) {
  if (!length(sizes)) return(0L)
  sum(sizes == vol) + sum(vapply(
    seq_along(sizes),
    function(i) n_container_combos(tail(sizes, -i), vol - sizes[[i]]),
    numeric(1L)
  ))
}

cat(n_container_combos(input), "\n")

container_combo_lengths <- function(sizes, vol = 150L, len = 0L) {
  if (!length(sizes)) return(c())
  c(rep(len, sum(sizes == vol)),
    unlist(lapply(seq_along(sizes), function(i) {
      container_combo_lengths(tail(sizes, -i), vol - sizes[[i]], len + 1L)
    })))
}

lens <- container_combo_lengths(input)
cat(sum(lens == min(lens)), "\n")
