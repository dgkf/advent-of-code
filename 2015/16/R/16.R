input <- readLines("utils/cache/2015/16/input.txt")

sues <- lapply(input, function(sue_data) {
  # this is nasty... only for AoC!!
  code <- paste0("list(", gsub(":", "=", gsub("Sue \\d+:", "", sue_data)), ")")
  as.data.frame(eval(parse(text = code)))
})

# fill col names
all_cols <- unique(unlist(lapply(sues, names)))
sues <- lapply(sues, function(df) { df[setdiff(all_cols, names(df))] <- NA; df })
sues <- do.call(rbind, sues)

# part 1
which_maybe_my_sues <- with(sues,
  children == 3L & 
  cats == 7L & 
  samoyeds == 2L & 
  pomeranians == 3L & 
  akitas == 0L &
  vizslas == 0L &
  goldfish == 5L &
  trees == 3L & 
  cars == 2L & 
  perfumes == 1L)

cat(which(is.na(which_maybe_my_sues)), "\n")

# part 2
which_maybe_my_sues <- with(sues,
  children == 3L & 
  cats > 7L & 
  samoyeds == 2L & 
  pomeranians < 3L & 
  akitas == 0L &
  vizslas == 0L &
  goldfish < 5L &
  trees > 3L & 
  cars == 2L & 
  perfumes == 1L)

cat(which(is.na(which_maybe_my_sues)), "\n")
