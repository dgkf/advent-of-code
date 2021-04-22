suppressPackageStartupMessages(library(combinat))

input <- readLines("stdin")

# parse text
m <- t(mapply(input, gregexpr("[A-Z][a-z]+|gain|lose|\\d+", input), FUN = function(i, m) {
  substring(i, m, m + attr(m, "match.length") - 1L)
}))

# tidy happiness
df <- as.data.frame(m, row.names = FALSE)
names(df) <- c("from", "dir", "val", "to")
df <- df[, c(1, 4, 2, 3)]
df$val <- as.numeric(df$val)
df$val <- ifelse(df$dir == "gain", df$val, -df$val)
df$dir <- NULL

# generate seating arrangements
arrangements <- do.call(rbind, lapply(permn(unique(df$from)), function(i) {
  data.frame(from = i, to = c(tail(i, -1L), head(i, 1L)))
}))
arrangements$n <- rep(1:factorial(length(unique(df$from))), each = length(unique(df$from)))

# bind happiness
df_hap <- merge(arrangements, df, by = c("from", "to"))
df_hap <- merge(df_hap, df, by.x = c("from", "to"), by.y = c("to", "from"))
df_hap <- df_hap[order(df_hap$n),]

happiness <- sapply(split(df_hap, df_hap$n), function(i) {
  sum(i$val.x + i$val.y)
})
cat(max(happiness), "\n")

happiness <- sapply(split(df_hap, df_hap$n), function(i) {
  sum(i$val.x + i$val.y) - min(i$val.x + i$val.y)
})
cat(max(happiness), "\n")
