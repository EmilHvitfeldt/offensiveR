#' Checks for offensive words in strings
#'
#' @param text A string of words.
#' @param n_output Number of surrounding words to display.
#' @param words_add Character. Words to look for.
#' @param words_ignore Character. Words to ignore.
#' @return Displays offensive words and their surrounding words.
#' @examples
#' text <- "This will be hard to asses, butt I think we will manage."
#' offensive_check_string(text)
#'
#' offensive_check_string(text, n_output = 4)
#'
#' offensive_check_string(text, words_add = "will")
#'
#' offensive_check_string(text, words_ignore = "butt")
#' @export
offensive_check_string <- function(text, n_output = 2, words_add = character(),
                                   words_ignore = character()) {

  padding <- function(x, n_words, n_output) {

    before <- seq(from = x - n_output, to = x - 1)
    before <- before[before > 0]

    after <- seq(from = x + 1, to = x + n_output)
    after <- after[after <= n_words]

    list(before = before,
         after = after,
         match = x)
  }

  what <- word_checker(text, words_add = words_add,
                       words_ignore = words_ignore)[[1]]
  all_words <- tokenizers::tokenize_words(text)[[1]]

  n_words <- length(all_words)

  for(i in what) {
    index <- which(i == all_words)

    for (j in index) {
      index_words <- padding(j, n_words = n_words, n_output = n_output)

      cat(all_words[index_words$before],
          crayon::red(all_words[index_words$match]),
          all_words[index_words$after], "\n")
    }
  }
}
