data {
  int<lower=0> K;
  array[K] real df;
  array[K] real mu;
  real<lower=0, upper=1> phi;
}
parameters {
  array[K] real x;
}
model {
  for (k in 1 : K) {
    target += phi * normal_lpdf(x[k] | mu[k], df[k]);
  }
}

Warning in '/mnt/43d3396d-0fde-4593-b19b-56bfdcb2a927/University/stan/test_suite/benchmark-models/normal_5d/normal_5d.stan', line 3, column 4: Declaration
    of arrays by placing brackets after a variable name is deprecated and
    will be removed in Stan 2.32.0. Instead use the array keyword before the
    type. This can be changed automatically using the auto-format flag to
    stanc
Warning in '/mnt/43d3396d-0fde-4593-b19b-56bfdcb2a927/University/stan/test_suite/benchmark-models/normal_5d/normal_5d.stan', line 4, column 4: Declaration
    of arrays by placing brackets after a variable name is deprecated and
    will be removed in Stan 2.32.0. Instead use the array keyword before the
    type. This can be changed automatically using the auto-format flag to
    stanc
Warning in '/mnt/43d3396d-0fde-4593-b19b-56bfdcb2a927/University/stan/test_suite/benchmark-models/normal_5d/normal_5d.stan', line 8, column 4: Declaration
    of arrays by placing brackets after a variable name is deprecated and
    will be removed in Stan 2.32.0. Instead use the array keyword before the
    type. This can be changed automatically using the auto-format flag to
    stanc
