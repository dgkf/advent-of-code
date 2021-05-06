input <- readLines("stdin")
X <- matrix(
  as.numeric(unlist(regmatches(input, gregexpr("-?\\d+", input)))),
  nrow = 4,
  byrow = TRUE
)

coefs <- expand.grid(1:100, 1:100, 1:100, 1:100)
coefs <- coefs[rowSums(coefs) == 100L,]
vals <- t(apply(coefs, 1L, `%*%`, X[,-5L]))
vals[vals < 0] <- 0
cat(max(apply(vals, 1L, prod)), "\n")

coefs <- coefs[rowSums(t(apply(coefs, 1L, `*`, X[,5L]))) == 500L,]
vals <- t(apply(coefs, 1L, `%*%`, X[,-5L]))
vals[vals < 0] <- 0
cat(max(apply(vals, 1L, prod)), "\n")
