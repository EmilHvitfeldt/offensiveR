# Find all occurences for each word
summarize_words <- function(file_names, found_line){
  words_by_file <- lapply(found_line, names)
  bad_words <- sort(unique(unlist(words_by_file)))
  out <- data.frame(
    word = bad_words,
    stringsAsFactors = FALSE
  )
  out$found <- lapply(bad_words, function(word) {
    index <- which(vapply(words_by_file, `%in%`, x = word, logical(1)))
    reports <- vapply(index, function(i){
      paste0(basename(file_names[i]), ":", found_line[[i]][word])
    }, character(1))
  })
  structure(out, class = c("summary_spellcheck", "data.frame"))
}

#' @export
print.summary_spellcheck <- function(x, ...){
  if(!nrow(x)){
    cat("No spelling errors found.\n")
    return(invisible())
  }
  words <- x$word
  fmt <- paste0("%-", max(nchar(words), 0) + 3, "s")
  pretty_names <- sprintf(fmt, words)
  cat(sprintf(fmt, "  WORD"), "  FOUND IN\n", sep = "")
  for(i in seq_len(nrow(x))){
    cat(pretty_names[i])
    cat(paste(x$found[[i]], collapse = paste0("\n", sprintf(fmt, ""))))
    cat("\n")
  }
  invisible(x)
}
