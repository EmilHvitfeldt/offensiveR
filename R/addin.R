#' Checks for offensive words in selection
#'
#' Call this function as an addin to check for offensive words in selection.
#' Example is shown at \url(https://github.com/EmilHvitfeldt/offensiveR).
#'
#' @export
offensive_addin <- function() {
  context <- rstudioapi::getActiveDocumentContext()

  # Set the default data to use based on the selection.
  text <- context$selection[[1]]$text

  offensive_check_string(text)
}
