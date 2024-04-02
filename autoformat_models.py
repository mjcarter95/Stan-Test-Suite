import subprocess
from pathlib import Path

MODEL_DIR = Path("/mnt/43d3396d-0fde-4593-b19b-56bfdcb2a927/University/stan/test_suite/benchmark-models")
CONDA_ENV = Path("/mnt/43d3396d-0fde-4593-b19b-56bfdcb2a927/conda_envs/cmdstan_env")
STANC_ENV = Path(CONDA_ENV, "bin/cmdstan/bin/stanc")


def main():
    stan_models = list(MODEL_DIR.rglob("*.stan"))
    for stan_model in stan_models:
        print(f"Formatting Stan model: {stan_model}")
        # Read Stan model
        with open(stan_model, "r") as f:
            model = f.read()
        
        # Autoformat Stan code
        stanc_command = f"{STANC_ENV} {stan_model} --auto-format"
        try:
            output = subprocess.check_output(stanc_command, shell=True, stderr=subprocess.STDOUT, universal_newlines=True)
        except subprocess.CalledProcessError as e:
            print("Error:", e)

        # Save updated Stan code
        with open(stan_model, "w") as f:
            f.write(output)

        print("Done")

if __name__ == "__main__":
    main()
