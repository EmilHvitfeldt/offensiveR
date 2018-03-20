padding <- function(x, n_words, n_output) {

  before <- seq(from = x - n_output, to = x - 1)
  before <- before[before > 0]

  after <- seq(from = x + 1, to = x + n_output)
  after <- after[after <= n_words]

  list(before = before,
       after = after,
       match = x)
}
