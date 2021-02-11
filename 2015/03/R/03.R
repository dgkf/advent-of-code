input <- as.character(strsplit(scan("stdin", "character", quiet = TRUE), "")[[1L]])

dirs <- list(
  "^" = c(0, 1),
  "v" = c(0, -1),
  "<" = c(-1, 0),
  ">" = c(1, 0)
)

coords <- rbind(c(0, 0), do.call(rbind, dirs[input]))

cat(nrow(unique(apply(coords, 2L, cumsum))), "\n")

cat(nrow(unique(rbind(
  apply(coords[c(TRUE, FALSE),], 2L, cumsum), 
  apply(coords[c(FALSE, TRUE),], 2L, cumsum)))), "\n")

