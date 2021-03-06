context("Fitting 'bicop' models")

set.seed(0)
dist <- bicop_dist("gumbel", 90, 3)
u <- rbicop(20, dist)
fit <- bicop(u, keep_data = TRUE)

test_that("returns proper 'bicop' object", {
  expect_s3_class(fit, "bicop")
  expect_s3_class(fit, "bicop_dist")
  expect_identical(
    names(fit),
    c("family", "rotation", "parameters", "var_types",
      "npars", "loglik", "data", "controls", "nobs")
  )

  fit <- bicop(u, family = "tll", keep_data = FALSE)
  expect_s3_class(fit, "bicop")
  expect_s3_class(fit, "bicop_dist")
  expect_identical(
    names(fit),
    c("family", "rotation", "parameters", "var_types",
      "npars", "loglik", "controls", "nobs")
  )

  colnames(u) <- paste(1:2)
  expect_identical(
    names(bicop(u, family = "indep")),
    c("family", "rotation", "parameters", "var_types",
      "npars", "loglik", "names", "controls", "nobs")
  )
})

test_that("family sets (w/ partial matching)", {
  bicop(u, family = "arch")
  bicop(u, family = "nonp")
  bicop(u, family = "elli")
  bicop(u, family = "onep")
  bicop(u, family = "two")
  bicop(u, family = "bbs")
  bicop(u, family = "itau")
  expect_warning(bicop(u, par_method = "itau"))
  expect_error(bicop(u, family = "asdf"))
})

test_that("S3 generics work", {
  expect_equal(predict(fit, u, what = "pdf"), fitted(fit, what = "pdf"))
  expect_equal(predict(fit, u, what = "cdf"), fitted(fit, what = "cdf"))
  expect_equal(predict(fit, u, what = "hfunc1"), fitted(fit, what = "hfunc1"))
  expect_equal(predict(fit, u, what = "hfunc2"), fitted(fit, what = "hfunc2"))
  expect_equal(predict(fit, u, what = "hinv1"), fitted(fit, what = "hinv1"))
  expect_equal(predict(fit, u, what = "hinv2"), fitted(fit, what = "hinv2"))
  u <- as.data.frame(u)
  expect_equivalent(logLik(fit), sum(log(predict(fit, u, what = "pdf"))))
  expect_output(print(fit))
  expect_output(summary(fit))
  expect_output(print(bicop(u, family = "nonp")))
})
