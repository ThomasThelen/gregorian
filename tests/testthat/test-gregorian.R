context("gregorian")

test_that("Special diff_days cases", {
  expect_equal(
    capture.output(as_gregorian("2012-1-1")),
    "Sunday January 1, 2012 CE"
  )
})