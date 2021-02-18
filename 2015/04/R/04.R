input <- scan("stdin", "character", quiet = TRUE)[[1L]]

find_first_hash <- function(input, n = 5, inc = 1e6, verbose = FALSE) {
  ans <- hash <- character(1L)
  zeros <- strrep("0", n)
  index <- 1L
  repeat {
    # create a bulk vector of indices to pass to md5, this reduces compute time
    # dratsically because vectors of data can be more easily shared to C library
    # compute without interop overhead
    indices <- index:(index+inc-1L)
    if (verbose) cat(sprintf("%d to %d\n", index, index + inc - 1L))
    hashes <- openssl::md5(paste0(input, indices))
    if (length(ans <- which(startsWith(hashes, zeros)))) {
      cat(indices[head(ans, 1L)], "\n")
      break
    }
    index <- index + inc
  }
}

find_first_hash(input)
find_first_hash(input, 6L)

