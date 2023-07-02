import json
import numpy as np

from tqdm import tqdm
from pathlib import Path

np.seterr(all="raise")


def valid_stan_output(output_file):
    with open(output_file, "r") as f:
        for line in f:
            if "#  Elapsed Time:" in line:
                return True
    return False


def find_stepsize(gold_standard_path):
    # Check for model configuration
    model_config =  str(gold_standard_path).replace(".csv", "_config.json")
    output_file = gold_standard_path.with_suffix(".csv")
    step_size = None
    if step_size is None and Path(gold_standard_path).is_file():
        with open(gold_standard_path, "r") as f:
            lines = f.readlines()
            mass_matrix = False
            for line in lines:
                if "Step size =" in line:
                    step_size = float(line.split("= ")[-1].strip())
                if "# Diagonal elements of inverse mass matrix:" in line:
                    mass_matrix = True
                    continue
                if mass_matrix:
                    mass_matrix = line.replace("# ", "").replace("\n", "").split(",")[6:]
                    mass_matrix = np.array([float(x.replace(" ", "")) for x in mass_matrix])
                    break
        if mass_matrix is False:
            step_size = 0.5
        else:
            step_size = np.mean(step_size * mass_matrix)

    if (step_size is None or np.isinf(step_size) or np.isneginf(step_size) or np.isnan(step_size)) and Path(model_config).is_file():
        with open(model_config, "r") as f:
            config = json.load(f)
        step_size = config["step_size"]

    if step_size is None or np.isinf(step_size) or np.isneginf(step_size) or np.isnan(step_size):
        step_size = 0.5
    
    return step_size


def main():
    stan_models = Path("/mnt/large_storage/big_hypotheses/stan_gold_standards/stan_models")
    example_models = Path("/mnt/large_storage/big_hypotheses/stan_gold_standards/example-models")

    # Find the path of all Stan models
    model_paths = list(stan_models.glob("**/*.stan"))
    model_paths += list(example_models.glob("**/*.stan"))

    # Find the path of the MCMC gold standard samples
    gold_standards = []
    for model_path in model_paths:
        gold_standard_path = model_path.with_suffix(".csv")
        if gold_standard_path.exists():
            gold_standards.append(gold_standard_path)

    # Filter Stan models that have a gold standard
    models = [model_path for model_path in model_paths if model_path.with_suffix(".csv") in gold_standards]

    print(f"Found {len(models)} Stan models with gold standards")

    # Extract the step-size, mean, standard deviation, skew and kurtosis of the gold standard samples
    for gold_standard_path in tqdm(gold_standards):
        if not valid_stan_output(gold_standard_path):
            print(f"Invalid Stan output: {gold_standard_path}")
            continue

        # Extract parameter names        
        with open(gold_standard_path, "r") as f:
            for line in f:
                if line.startswith("lp__"):
                    param_names = line.strip("# ").strip().split(",")[7:]
                    break

        # Load samples
        stan_samples = np.loadtxt(gold_standard_path, comments=["#", "lp__"], delimiter=",", skiprows=1)[:, 7:]

        try:
            # Calculate moments about the origin
            e1 = np.mean(stan_samples, axis=0)
            e2 = np.mean(stan_samples ** 2, axis=0)
            e3 = np.mean(stan_samples ** 3, axis=0)
            e4 = np.mean(stan_samples ** 4, axis=0)

            # Calculate moments about the mean
            m1 = e1
            m2 = e2 - e1 ** 2
            m3 = e3 - 3 * e1 * e2 + 2 * e1 ** 3
            m4 = e4 - 4 * e1 * e3 + 6 * e1 ** 2 * e2 - 3 * e1 ** 4

            # Calculate skewness and kurtosis
            mean = e1
            std = np.sqrt(e2 - e1 ** 2)
            skew = m3 / m2 ** 1.5
            kurt = m4 / m2 ** 2
        except:
            print(f"Failed to extract moments: {gold_standard_path}")
            continue

        try:
            # Determine step-size
            step_size = find_stepsize(gold_standard_path)
        except:
            step_size = 0.5

        output_path = str(gold_standard_path).replace(".csv", "_gold_standard.json")
        if "stan_models" in output_path:
            output_path = output_path.replace("stan_models", "gold_standards/benchmark-models")
        elif "example-models" in output_path:
            output_path = output_path.replace("example-models", "gold_standards/example-models")

        # Make sure the output directory exists
        Path(output_path).parent.mkdir(parents=True, exist_ok=True)

        with open(output_path, "w") as f:
            json.dump(
                {
                    "param_names": param_names,
                    "mean": mean.tolist(),
                    "std": std.tolist(),
                    "skew": skew.tolist(),
                    "kurt": kurt.tolist(),
                    "step_size": step_size
                },
            f)


if __name__ == "__main__":
    main()
