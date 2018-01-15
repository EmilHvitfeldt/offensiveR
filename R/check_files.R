#' Offensive check
#'
#' Perform a check for offensive works on document files or plain text.
#'
#' @rdname offensive_check_files
#' @param path path to file or to offensive check
#' @param words_add Character. Words to look for.
#' @param words_ignore Character. Words to ignore.
#' @export
#' @examples # Example files
#' files <- list.files(system.file("examples", package = "knitr"),
#'   pattern = "\\.(Rnw|Rmd|html)$", full.names = TRUE)
#' offensive_check_files(files)
offensive_check_files <- function(path, words_add = character(),
                                  words_ignore = character()){
  stopifnot(is.character(words_add))
  stopifnot(is.character(words_ignore))
  path <- normalizePath(path, mustWork = TRUE)
  lines <- lapply(sort(path), offensive_check_file_one, words_add = words_add,
                  words_ignore = words_ignore)
  summarize_words(path, lines)
}

offensive_check_file_one <- function(path, words_add = character(),
                                     words_ignore = character()){
  if(grepl("\\.r?md$",path, ignore.case = TRUE))
    return(offensive_check_file_md(path, words_add = words_add,
                                   words_ignore = words_ignore))
  if(grepl("\\.(rnw|snw)$",path, ignore.case = TRUE))
    return(offensive_check_file_knitr(path = path, format = "latex", words_add = words_add,
                                      words_ignore = words_ignore))
  if(grepl("\\.(tex)$",path, ignore.case = TRUE))
    return(offensive_check_file_plain(path = path, format = "latex", words_add = words_add,
                                      words_ignore = words_ignore))
  if(grepl("\\.(html?)$",path, ignore.case = TRUE))
    return(offensive_check_file_plain(path = path, format = "html", words_add = words_add,
                                      words_ignore = words_ignore))
  if(grepl("\\.(xml)$",path, ignore.case = TRUE))
    return(offensive_check_file_plain(path = path, format = "xml", words_add = words_add,
                                      words_ignore = words_ignore))
  if(grepl("\\.(pdf)$",path, ignore.case = TRUE))
    return(offensive_check_file_pdf(path = path, format = "text", words_add = words_add,
                                    words_ignore = words_ignore))
  return(offensive_check_file_plain(path = path, format = "text", words_add = words_add,
                                    words_ignore = words_ignore))
}

#' @rdname offensive_check_files
#' @export
#' @param text character vector with plain text
offensive_check_text <- function(text, words_add = character(),
                                 words_ignore = character()){
  stopifnot(is.character(words_add))
  stopifnot(is.character(words_ignore))
  wrong_words <- word_checker(text, words_add = words_add,
                              words_ignore = words_ignore)
  words <- sort(unique(unlist(wrong_words)))
  out <- data.frame(word = words, stringsAsFactors = FALSE)
  out$found <- lapply(words, function(word) {
    which(vapply(wrong_words, `%in%`, x = word, logical(1)))
  })
  out
}

offensive_check_plain <- function(text, words_add = character(),
                                  words_ignore = character()){
  wrong_words <- word_checker(text, words_add = words_add,
                              words_ignore = words_ignore)
  vapply(sort(unique(unlist(wrong_words))), function(word) {
    line_numbers <- which(vapply(wrong_words, `%in%`, x = word, logical(1)))
    paste(line_numbers, collapse = ",")
  }, character(1))
}

offensive_check_file_text <- function(file, words_add = character(),
                                      words_ignore = character()){
  offensive_check_plain(readLines(file), words_add = words_add,
                        words_ignore = words_ignore)
}

offensive_check_file_rd <- function(rdfile, words_add = character(),
                                    words_ignore = character()){
  text <- tools::RdTextFilter(rdfile)
  offensive_check_plain(text, words_add = words_add,
                        words_ignore = words_ignore)
}

offensive_check_file_md <- function(path, words_add = character(),
                                    words_ignore = character()){
  words <- parse_text_md(path)
  words$startline <- vapply(strsplit(words$position, ":", fixed = TRUE), `[[`, character(1), 1)
  wrong_words <- word_checker(words$text, words_add = words_add,
                              words_ignore = words_ignore)
  vapply(sort(unique(unlist(wrong_words))), function(word) {
    line_numbers <- which(vapply(wrong_words, `%in%`, x = word, logical(1)))
    paste(words$startline[line_numbers], collapse = ",")
  }, character(1))
}

offensive_check_file_knitr <- function(path, format, words_add = character(),
                                       words_ignore = character()){
  latex <- remove_chunks(path)
  words <- hunspell::hunspell_parse(latex, format = format)
  text <- vapply(words, paste, character(1), collapse = " ")
  offensive_check_plain(text, words_add = words_add,
                        words_ignore = words_ignore)
}

offensive_check_file_plain <- function(path, format, words_add = character(),
                                       words_ignore = character()){
  lines <- readLines(path, warn = FALSE)
  words <- hunspell::hunspell_parse(lines, format = format)
  text <- vapply(words, paste, character(1), collapse = " ")
  offensive_check_plain(text, words_add = words_add,
                        words_ignore = words_ignore)
}

offensive_check_file_pdf <- function(path, format, words_add = character(),
                                     words_ignore = character()){
  lines <- pdftools::pdf_text(path)
  words <- hunspell::hunspell_parse(lines, format = format)
  text <- vapply(words, paste, character(1), collapse = " ")
  offensive_check_plain(text, words_add = words_add,
                        words_ignore = words_ignore)
}
