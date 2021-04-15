library(jsonlite)

input <- readLines("stdin")
j <- jsonlite::parse_json(input)

extract_nums <- function(x) {
  if (is.list(x)) unlist(sapply(x, function(i) unlist(extract_nums(i))))
  else if (is.numeric(x)) x
  else c()
}

cat(sum(extract_nums(j)), "\n")

extract_nonred_nums <- function(x) {
  if (is.list(x) & !is.null(names(x))) { # objects
    if (any(x == "red")) return(0L)
    unlist(sapply(x, function(i) unlist(extract_nonred_nums(i))))
  } else if (is.list(x)) # arrays
    unlist(sapply(x, function(i) unlist(extract_nonred_nums(i))))
  else if (is.numeric(x)) x
  else c()
}

cat(sum(extract_nonred_nums(j)), "\n")

