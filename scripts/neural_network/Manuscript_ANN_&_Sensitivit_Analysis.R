# Load necessary libraries
library(vegan)
library(tidyverse)
library(ggpubr)
library(reshape2)
library(viridis)
library(hrbrthemes)
library(ANN2)

# Function to scale data to a range
scale_data <- function(data) {
  decostand(data, method = "range")
}

# Function to train and evaluate the neural network model
train_evaluate_nn <- function(train_data, test_data, hidden_layers, n_epochs = 1000) {
  nn.model <- neuralnetwork(
    train_data[, 1:22],
    train_data[, 23:25],
    regression = TRUE,
    hidden.layers = hidden_layers,
    sgd.momentum = 0.9,
    learn.rates = 0.01,
    val.prop = 0.3,
    n.epochs = n_epochs,
    optim.type = "adam",
    loss.type = "squared",
    activ.functions = "relu"
  )
  
  # Predict and calculate MSE
  pred_val <- predict(nn.model, test_data[, 1:22]) %>% as.data.frame()
  mse_tot <- mean(c(
    mean((test_data$D_sfm - pred_val$predictions.D_sfm)^2),
    mean((test_data$R_sfm - pred_val$predictions.R_sfm)^2),
    mean((test_data$H_sfm - pred_val$predictions.H_sfm)^2)
  ))
  
  list(model = nn.model, predictions = pred_val, mse = mse_tot)
}

# Load and preprocess data
nn_data <- read.csv("pix_var_compiled.csv", header = TRUE)
reef_data <- read.csv("TOT_pix_values_merge_sorted.csv")
reef_data <- reef_data[, 3:24]
colnames(nn_data)[10:35] <- c('R_RGB', 'G_RGB', 'B_RGB', 'Y_YCrCb', 'Gray', 'H_HSV', 'L_LAB', 'L_LUV', 
                              'X_XYZ', 'Y_YUV', 'Cr_YCrCb', 'S_HSV', 'A_LAB', 'U_LUV', 'Y_XYZ', 
                              'U_YUV', 'Cb_YCrCb', 'V_HSV', 'B_LAB', 'V_LUV', 'Z_XYZ', 'V_YUV')

# Combine and scale data
combined_data <- rbind(nn_data[, 10:35], reef_data) %>% scale_data()

# Add SFM metrics
sfm_data <- data.frame(D_sfm = H_xdata$D_sfm, R_sfm = H_xdata$R_sfm, H_sfm = log10(H_xdata$H_sfm + 1))
nn_data <- cbind(combined_data[1:151, ], sfm_data)

# Add fold column for k-fold CV
nn_data$k <- rep(1:10, length.out = nrow(nn_data))

# K-fold cross-validation
results <- list()
folds <- 1:10

for (kf in 1:5) {
  for (i in folds) {
    if (i != 10) {
      test_data <- nn_data %>% filter(k == i | k == i + 1)
      train_data <- nn_data %>% filter(!(k == i | k == i + 1))
    } else {
      test_data <- nn_data %>% filter(k == i | k == 1)
      train_data <- nn_data %>% filter(!(k == i | k == 1))
    }
    
    eval_result <- train_evaluate_nn(train_data, test_data, hidden_layers = c(40, 40, 40))
    results[[length(results) + 1]] <- list(
      R2_D = R2(test_data$D_sfm, eval_result$predictions$predictions.D_sfm),
      R2_R = R2(test_data$R_sfm, eval_result$predictions$predictions.R_sfm),
      R2_H = R2(test_data$H_sfm, eval_result$predictions$predictions.H_sfm),
      MSE_tot = eval_result$mse,
      fold = kf
    )
  }
}

# Sensitivity analysis
sensitivity_analysis <- function(test_data, model, perturbations = seq(0.1, 0.5, by = 0.1)) {
  results <- matrix(nrow = ncol(test_data), ncol = length(perturbations))
  for (p in seq_along(perturbations)) {
    for (v in seq_len(ncol(test_data))) {
      perturbed_data <- test_data
      perturbed_data[, v] <- test_data[, v] + perturbations[p]
      mse_pos <- mean((test_data$D_sfm - predict(model, perturbed_data)[, 1])^2)
      
      perturbed_data[, v] <- test_data[, v] - perturbations[p]
      mse_neg <- mean((test_data$D_sfm - predict(model, perturbed_data)[, 1])^2)
      
      results[v, p] <- abs(mse_pos - mse_neg) / mean(c(mse_pos, mse_neg)) * 100
    }
  }
  colnames(results) <- paste0("p", perturbations)
  results
}

# Save results to CSV
results_df <- do.call(rbind, lapply(results, as.data.frame))
write.csv(results_df, "cross_validation_results.csv", row.names = FALSE)
sensitivity_results <- sensitivity_analysis(test_data, eval_result$model)
write.csv(sensitivity_results, "sensitivity_analysis_results.csv", row.names = FALSE)
