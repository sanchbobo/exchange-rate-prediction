# exchange-rate-prediction

This project aims to predict exchange rates using machine learning models. It utilizes historical exchange rate data and employs neural networks for forecasting.

## Project Structure

- `data/`
  - `raw/`: Contains raw data files.
    - `ExchangeUSD.xlsx`: Historical exchange rate data.
  - `processed/`: Contains processed data files (e.g., cleaned data, feature-engineered datasets).
- `scripts/`: Contains R scripts for data processing and model training.
  - `Exchange_Currency_Prediction.R`: Main script for data preprocessing, feature engineering, and model training.
- `results/`: Directory for storing results such as plots and model outputs.
- `docs/`: Documentation and reports.
- `.gitignore`: Specifies files and directories to ignore in the repository.
- `README.md`: Overview and instructions for the project.
- `requirements.txt`: List of R packages required for the project.
- `LICENSE`: License for the project.

## Getting Started

### Prerequisites

Make sure you have R installed on your system. You will also need to install the following R packages:

```r
install.packages(c("readxl", "dplyr", "ggplot2", "reshape2", "gridExtra", "neuralnet", "grid", "MASS", "Metrics"))
