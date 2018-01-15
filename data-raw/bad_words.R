library(tidyverse)

url <- "https://www.cs.cmu.edu/~biglou/resources/bad-words.txt"
bad_words <- read_table(url, col_names = "words",
                        col_types = cols(words = col_character())) %>%
  pull(words)
