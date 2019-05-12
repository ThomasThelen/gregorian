context("add_days")

test_that("add_days cases", {
  expect_equivalent(
     add_days(gregorian_date(3114, 8, 11, TRUE), 1)$astronomical, 
     "-3113-08-12"
     )
  expect_equivalent(
     add_days(gregorian_date(3114, 8, 11, TRUE), 30)$astronomical, 
     "-3113-09-10"
     )
  expect_equivalent(
     add_days(gregorian_date(3114, 8, 11, TRUE), 1872000)$astronomical, 
     "2012-12-21"
     )
  expect_equivalent(
     add_days(as.Date("2012-01-01"), 1)$astronomical, 
     "2012-01-02"
     )
  expect_equivalent(
     add_days("2012-01-01", 1)$astronomical, 
     "2012-01-02"
  )
})
