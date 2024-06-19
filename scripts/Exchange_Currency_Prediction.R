# Load necessary libraries for data manipulation, modeling, and visualization
library(readxl)    # to read Excel files
library(dplyr)     # for data manipulation
library(ggplot2)   # for plotting
library(reshape2)  # for data reshaping
library(gridExtra) # for arranging ggplot2 graphs on a grid
library(neuralnet) # for neural network training
library(grid)      # for grid graphics
library(MASS)      # for statistical functions
library(Metrics)   # for calculating performance metrics such as MAE

# Read exchange rate data from Excel file and display its structure
exchange_rates <- read_excel("/Users/sanch_bo/Desktop/ML_CW_w1936916/ExchangeUSD.xlsx")
str(exchange_rates)  # Display structure of exchange rates data
exchange_rates[, 3]  # Access and show the third column, assuming it contains the relevant rate data

# Create a dataframe with lagged exchange rate values to be used as features for forecasting
time_series_rates <- bind_cols(
  G_previous2 = lag(exchange_rates[, 3], 3), # Exchange rate from three days prior
  G_previous = lag(exchange_rates[, 3], 2),  # Exchange rate from two days prior
  G_current = lag(exchange_rates[, 3], 1),   # Exchange rate from one day prior
  G_pred = exchange_rates[, 3]               # Current day's exchange rate, to be predicted
)
time_series_rates <- time_series_rates[complete.cases(time_series_rates),]  # Remove any rows with NA values
head(time_series_rates)  # Display the first few rows to check the data
str(time_series_rates)   # Show structure of the prepared time series data
summary(time_series_rates$`USD/EUR...1`)  # Summary statistics of the predicted column

# Normalize the feature columns to ensure they are on a similar scale
normalize <- function(x) {
  (x - min(x)) / (max(x) - min(x))  # Scale transformation to [0, 1]
}
time_series_rates_norm <- as.data.frame(lapply(time_series_rates, normalize))  # Apply normalization
summary(time_series_rates_norm)  # Display summary statistics of normalized data

# Split the normalized data into training and testing sets for model building and evaluation
time_series_rates_train <- time_series_rates_norm[1:373,]  # First 373 days as training data
time_series_rates_test <- time_series_rates_norm[374:497,]  # Remaining days as testing data

# Model training using a neural network with a single hidden layer consisting of six neurons
time_series_rates_model <- neuralnet(
  USD.EUR...4  ~ USD.EUR...3 + USD.EUR...2 + USD.EUR...1,  # Model formula: predict current rate from two lags
  hidden = c(10, 7, 3),  # Hidden layer with 6 neurons
  data = time_series_rates_train,  # Training data
  linear.output = FALSE  # Non-linear activation function in the output layer
)
plot(time_series_rates_model)  # Visualize the neural network structure

# Compute the neural network's predictions on the test set and display them
model_results <- compute(time_series_rates_model, time_series_rates_test[1:3])
model_results$net.result  # Display the network's output
time_series_rates_test  # Show the test data

print(dim(time_series_rates_test))  # Print dimensions of the test data
print(dim(model_results$net.result))  # Print dimensions of the prediction results

# Convert predictions back to their original scale (unnormalize)
predicted_rate <- model_results$net.result
rate_train_original <- time_series_rates[1:373, "USD/EUR...3"]  # Original training data rates
rate_test_original <- time_series_rates[374:497, "USD/EUR...3"]  # Original testing data rates
rate_min <- min(rate_train_original)  # Minimum rate in the training data
rate_max <- max(rate_train_original)  # Maximum rate in the training data
rate_pred <- unnormalize(predicted_rate, rate_min, rate_max)  # Apply unnormalization

# Calculate error metrics: RMSE, MAE, MAPE, and sMAPE for model evaluation
rate_test_original_vec <- as.numeric(rate_test_original$`USD/EUR...3`)  # Convert to numeric vector
rate_pred_vec <- as.numeric(rate_pred[, 1])  # Convert predicted rates to numeric vector

error <- rate_test_original_vec - rate_pred_vec  # Calculate error between actual and predicted
pred_RMSE <- sqrt(mean(error^2))  # Root Mean Square Error
pred_MAE <- mae(rate_test_original_vec, rate_pred_vec)  # Mean Absolute Error

# Define and calculate Mean Absolute Percentage Error and Symmetric Mean Absolute Percentage Error
mape <- function(actual, predicted) {
  mean(abs((actual - predicted) / actual)) * 100  # MAPE formula
}
smape <- function(actual, predicted) {
  100 / length(actual) * sum(2 * abs(predicted - actual) / (abs(actual) + abs(predicted)))  # sMAPE formula
}
pred_MAPE <- mape(rate_test_original_vec, rate_pred_vec)  # Calculate MAPE
pred_sMAPE <- smape(rate_test_original_vec, rate_pred_vec)  # Calculate sMAPE

# Print calculated performance metrics
print(paste("RMSE:", pred_RMSE))
print(paste("MAE:", pred_MAE))
print(paste("MAPE:", pred_MAPE))
print(paste("sMAPE:", pred_sMAPE))

# Plot the actual vs. predicted exchange rates and show a scatter plot for real vs. predicted comparison
x = 1:length(rate_test_original_vec)
plot(x, rate_test_original_vec, col = "red", type = "l", lwd=2,
     main = "Exchange Rate Prediction")
lines(x, rate_pred_vec, col="blue", lwd=2)
legend("topright", legend = c("Original Rate", "Predicted Rate"),
       fill = c("red", "blue"), col = 2:3, adj = c(0, 1))
grid()

par(mfrow=c(1,1))
plot(rate_test_original_vec, rate_pred_vec, col='red', main='Real vs Predicted', pch=18, cex=0.7)
abline(a=0, b=1, h=90, v=90)  # Add a line at 45 degrees to show perfect prediction alignment
