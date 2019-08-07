######## CmdStan diagnose example  ###########

using StanDiagnose

ProjDir = dirname(@__FILE__)

bernoulli_model = "
data { 
  int<lower=0> N; 
  int<lower=0,upper=1> y[N];
} 
parameters {
  real<lower=0,upper=1> theta;
} 
model {
  theta ~ beta(1,1);
    y ~ bernoulli(theta);
}
"
bernoulli_data = Dict("N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1])

tmpdir = joinpath(@__DIR__, "tmp")

stanmodel = DiagnoseModel("bernoulli", bernoulli_model;
  method=StanDiagnose.Diagnose(StanDiagnose.Gradient(epsilon=1e-6)),
  tmpdir = tmpdir);

(sample_file, log_file) = stan_diagnose(stanmodel; data=bernoulli_data);

if sample_file !== Nothing
  diags = read_diagnose(stanmodel)
  println()
  display(diags)
end
