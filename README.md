# Currency Exchange Rate Prediction

## Overview
This project focuses on predicting the USD to EUR exchange rates using historical data. It employs a neural network model to forecast future values based on previous days' rates.

## Data
The dataset used in this project includes daily exchange rates from USD to EUR over a specified period. The data is structured with the following columns:
- `YYYY/MM/DD`: The date of the exchange rate.
- `Wdy`: The day of the week.
- `USD/EUR`: The exchange rate of USD to EUR for the specified date.

## Requirements
To run this project, you need R and the following R packages:
- `readxl`
- `dplyr`
- `ggplot2`
- `reshape2`
- `gridExtra`
- `neuralnet`
- `grid`
- `MASS`
- `Metrics`

## Files
- `Exchange_Currency_Prediction.R`: The R script that contains all the preprocessing, model training, and evaluation code.
- `ExchangeUSD.xlsx`: Excel file containing the historical exchange rate data.

## Setup and Execution
1. Ensure that R and all required libraries are installed.
2. Load the R script in your R environment.
3. Run the script to train the model and make predictions.

## Methodology
The project uses a neural network model trained on features derived from lagging the `USD/EUR` exchange rate data. The data is normalized to improve model performance and to ensure fair feature scaling. Various performance metrics such as MAE (Mean Absolute Error) are calculated to evaluate the model's predictions.

## Contact
- Oleksandr Bondarenko
- oleksandr.vol.bo@gmail.com
