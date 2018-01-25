word_checker <- function(text, words_add = character(),
                         words_ignore = character()) {

  bad_words <- setdiff(union(offensiveR::bad_words, words_add), words_ignore)

  text %>% purrr::map(~ .x %>%
                        tokenizers::tokenize_words() %>%
                        unlist() %>%
                        intersect(offensiveR::bad_words))
}
