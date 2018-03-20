#' Checks for offensive words in tokenized vector
#'
#' @param text A vector of tokenized words.
#' @param words_add Character. Words to look for.
#' @param words_ignore Character. Words to ignore.
#' @return Logical indicator.
#' @examples
#' text <- c("this", "will", "be", "hard", "to", "asses", "butt", "i", "think",
#'           "we", "will", "manage")
#' offensive_check_token(text)
#' @export
offensive_check_token <- function(text, words_add = character(),
                                  words_ignore = character()) {

  bad_words_updated <- setdiff(union(offensiveR::bad_words, words_add), words_ignore)

  purrr::map_lgl(tolower(text), ~ .x %in% tolower(bad_words_updated))
}
