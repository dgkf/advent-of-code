input <- readLines("utils/cache/2015/14/input.txt")

# parse text
df <- as.data.frame(row.names = FALSE, t(mapply(
  input,
  gregexpr("[A-Z][a-z]+|\\d+", input),
  FUN = function(i, m) {
    substring(i, m, m + attr(m, "match.length") - 1L)
  }
)))
names(df) <- c("reindeer", "speed", "fly_dur", "rest_dur")
df[2:4] <- lapply(df[2:4], as.numeric)

traveled <- function(speed, fly_dur, rest_dur, time = 2503) {
  cycle_n <- time %/% (fly_dur + rest_dur)      
  cycle_rem <- time %% (fly_dur + rest_dur)
  ifelse(
    cycle_rem <= fly_dur,
    (cycle_n * fly_dur + cycle_rem) * speed,
    (cycle_n + 1) * fly_dur * speed
  )
}

df$traveled <- traveled(df$speed, df$fly_dur, df$rest_dur)
cat(max(df$traveled), "\n")

df$score <- 0L
for (t in seq_len(2503)) {
  dists <- traveled(df$speed, df$fly_dur, df$rest_dur, time = t)
  df$score <- df$score + (dists == max(dists))
}
cat(max(df$score), "\n")
