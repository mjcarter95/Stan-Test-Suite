data {
  int<lower=0> N;
  vector[N] y;
  real<lower=0, upper=1> phi;
}
parameters {
  vector[2] mu;
  array[2] real<lower=0> sigma;
  real<lower=0, upper=1> theta;
}
model {
  //  sigma ~ normal(0, 2);
  //  mu ~ normal(0, 2);
  //  theta ~ beta(5, 5);
  
  target += normal_lpdf(sigma[1] | 0, 2);
  target += normal_lpdf(sigma[2] | 0, 2);
  target += normal_lpdf(mu[1] | 0, 2);
  
  for (n in 1 : N) {
    target += log_mix(theta, phi * normal_lpdf(y[n] | mu[1], sigma[1]),
                      phi * normal_lpdf(y[n] | mu[2], sigma[2]));
  }
}

