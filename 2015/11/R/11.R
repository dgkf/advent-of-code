input <- readLines("stdin")[[1L]]

password_to_vector <- function(pw) {
  vapply(strsplit(pw, "")[[1L]], utf8ToInt, numeric(1L)) - 96L
}

vector_to_password <- function(v) {
  paste(vapply(v + 96L, intToUtf8, character(1L)), collapse = "")
}

increment_vector <- function(v) {
  vi_inc <- Position(function(vi) vi < 26L, v, right = TRUE)
  if (is.na(vi_inc)) return(rep(1L, length(v)))
  v[vi_inc] <- v[vi_inc] + 1L
  if (vi_inc < length(v)) v[seq(from = vi_inc + 1L, to = length(v))] <- 1L
  v
}

skip_disallowed <- function(v) {
  dis <- which(v %in% password_to_vector(c("i", "o", "l")))
  if (length(dis)) {
    dis_i <- head(dis, 1L)
    v[dis_i] <- v[dis_i] + 1L
    if (dis_i < length(v)) v[seq(dis_i + 1L, length(v))] <- 1L
  }
  v
}

is_valid_vector <- function(v) {
  dv <- diff(v)
  any(head(dv, -1L) == 1L & tail(dv, -1L) == 1L) &&
  !any(v %in% password_to_vector(c("i", "o", "l"))) &&
  sum(dv == 0L) > 1L && 
  length(unique(v[which(dv == 0L)])) > 1L
}

next_password_after <- function(pw = input, n = 1L, verbose = FALSE) {
  v <- password_to_vector(pw)
  i <- 1L
  repeat {
    if (is_valid_vector(v)) {
      n <- n - 1L
      if (n <= 0L) break
    }
    v <- skip_disallowed(v)
    v <- increment_vector(v)
    i <- i + 1L
    if (verbose && i %% (if (is.logical(verbose)) 100 else verbose) == 0L) {
      cat("[", i, "] ", vector_to_password(v), "\n", sep = "")
    }
  }
  vector_to_password(v)
}

cat(next_password_after(), "\n")
cat(next_password_after(n = 2L), "\n")

