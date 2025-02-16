# Load necessary libraries
library(tidyverse)

# Set seed for reproducibility
set.seed(42)

# Simulate a dataset
n <- 100  # Number of individuals
data <- tibble(
  Age = sample(18:70, n, replace = TRUE),
  Income = sample(20000:100000, n, replace = TRUE),
  TobaccoSmoking = rnorm(n, mean = 10, sd = 5),  # Simulated number of cigarettes smoked per day
  HealthOutcome = rnorm(n, mean = 50, sd = 10)   # Health outcome (e.g., lung function)
)

# Introduce missing values in TobaccoSmoking (e.g., some individuals have missing data)
data$TobaccoSmoking[sample(1:n, 20)] <- NA  # Introduce missing data in 20% of TobaccoSmoking

# View the data with missing values
head(data)
view(data)
# Exposure Model: Impute missing TobaccoSmoking using Age and Income as predictors
# Fit a linear regression model to predict TobaccoSmoking
model <- lm(TobaccoSmoking ~ Age + Income, data = data, na.action = na.exclude)
summary(model)

# Impute missing TobaccoSmoking values using the model
data$TobaccoSmoking <- ifelse(
  is.na(data$TobaccoSmoking),
  predict(model, newdata = data[is.na(data$TobaccoSmoking),]),
  data$TobaccoSmoking
)

# View the imputed data
head(data)
view(data)

# Check if any missing values remain
sum(is.na(data$TobaccoSmoking))