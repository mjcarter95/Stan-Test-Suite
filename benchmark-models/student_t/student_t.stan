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
  real lpdf = 0;
  for (k in 1 : K) {
    target += lgamma((df[k] + 1) / 2);
    target += -lgamma(df[k] / 2);
    target += -log(sqrt(df[k] * pi()));
    target += -((df[k] + 1) / 2)
              * log(1 + (1 / df[k]) * (x[k] - mu[k]) * (x[k] - mu[k])) * phi;
  }
}

