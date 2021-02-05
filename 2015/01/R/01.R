input <- strsplit(scan("stdin", "character", quiet = TRUE), "")[[1]] == "("
cat(diff(unname(table(input))), "\n")
cat(which.max(cumsum(input * 2 - 1) < 0), "\n")
