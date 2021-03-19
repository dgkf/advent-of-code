x <- readLines("stdin")
cat(sum(nchar(x)) - sum(nchar(gsub("\\\\(\\\\|x..|\")", "X", x)) - 2L), "\n")
cat(sum(nchar(gsub("(\"|\\\\)", "\\\\\\1", x)) + 2L) - sum(nchar(x)), "\n")
