input <- readLines("stdin")

Rinput <- input
Rinput <- gsub("^(\\w+) AND (\\w+)",    "bitwAnd(\\1, \\2)", Rinput)
Rinput <- gsub("^(\\w+) OR (\\w+)",     "bitwOr(\\1, \\2)", Rinput)
Rinput <- gsub("^(\\w+) LSHIFT (\\w+)", "bitwShiftL(\\1, \\2)", Rinput)
Rinput <- gsub("^(\\w+) RSHIFT (\\w+)", "bitwShiftR(\\1, \\2)", Rinput)
Rinput <- gsub("^NOT (\\w+)",           "bitwNot(\\1)", Rinput)
Rinput <- gsub("\\b([a-z]{1,2})\\b",    "var_\\1", Rinput)
Rexprs <- lapply(Rinput, function(Rinput_i) parse(text = Rinput_i))

# evaluate expressions until we've evaluated everything
exprs <- Rexprs
while (length(exprs)) {
  for (i in seq_along(exprs)) {
    rhs <- exprs[[i]][[1]][[3]]
    if (all(sapply(grep("var_", all.names(rhs), value = TRUE), exists))) {
      eval(exprs[[i]])
      exprs <- exprs[-i]      
      break
    }
  }
}

cat(var_a, "\n")

exprs <- lapply(Rexprs, function(i) {
  if (i[[1]][[2]] == quote(var_b)) {
    as.expression(bquote(var_b <- .(var_a)))
  } else i
})

rm(list = grep("^var_", ls(), value = TRUE))

while (length(exprs)) {
  for (i in seq_along(exprs)) {
    rhs <- exprs[[i]][[1]][[3]]
    if (all(sapply(grep("var_", all.names(rhs), value = TRUE), exists))) {
      eval(exprs[[i]])
      exprs <- exprs[-i]      
      break
    }
  }
}

cat(var_a, "\n")

