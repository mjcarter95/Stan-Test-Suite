data {
  int<lower=0> N;
  vector[N] y;
  real<lower=0, upper=1> phi;
}

parameters {
  ordered[2] mu;
  array[2] real<lower=0> sigma;
  real<lower=0, upper=1> theta;
}

model {
 
  target += normal_lpdf(sigma | 0, 2);
  target += normal_lpdf(mu | 0, 2);
  target += beta_lpdf(theta | 2, 2);
  
  for (n in 1 : N) 
    target +=  log_mix(theta, phi*normal_lpdf(y[n] | mu[1], sigma[1]),
                      phi*normal_lpdf(y[n] | mu[2], sigma[2]));
}