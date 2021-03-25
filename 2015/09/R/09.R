suppressPackageStartupMessages({
  library(combinat)
})

input <- readLines("stdin")

# generate table of town-to-town distances
input <- as.data.frame(t(mapply(
  input,
  regexec("(\\w+) to (\\w+) = (\\d+)", input),
  FUN = function(i, m) {
    substring(i, m, m + attr(m, "match.length") - 1L)
  }
))[,2:4], row.names = FALSE)
names(input) <- c("x", "y", "d")
input$d <- as.numeric(input$d)
input <- rbind(input, data.frame(x = input$y, y = input$x, d = input$d))

# get unique towns
towns <- unique(input$x)

# generate table of trips
trips <- do.call(rbind, lapply(permn(towns), function(i) {
    data.frame(x = i[-length(i)], y = i[-1], leg = 1:(length(i)-1))
}))
trips$trip <- rep(1:factorial(length(towns)), each = length(towns) - 1L)
trips <- merge(trips, input, by = c("x", "y"))
trips <- trips[order(trips$trip, trips$leg),]

# aggregate trips by sum of leg distances
trip_dists <- aggregate(d ~ trip, data = trips, sum)
cat(min(trip_dists$d), "\n")
cat(max(trip_dists$d), "\n")
