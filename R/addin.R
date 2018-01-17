offensive_addin <- function() {
  context <- rstudioapi::getActiveDocumentContext()

  # Set the default data to use based on the selection.
  text <- context$selection[[1]]$text

  offensive_check_string(text)
}
