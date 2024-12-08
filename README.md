# ai_coralcomplexity

# Project Description
This repository contains code and data for predicting coral reef structural complexity metrics (e.g., fractal dimension, rugosity, and height range) using pixel variability derived from multi-color-space image transformations. The project combines remote sensing, image processing, and artificial neural networks (ANNs) to scale predictions of coral complexity metrics to larger reef areas.


**Workflow**

The project follows these main steps:

**1. Image Processing**
   - Convert RGB images into various color spaces (e.g., grayscale, HSV, Lab).
   - Script: colorspace_transformations_CC.py.

**2. Pixel Variability Calculation**
  - Compute pixel variability metrics for each color space.
  - Script: PixelVariability_CC.py.

**3. Data Merging**
  - Combine pixel variability data from all color spaces into one CSV file.
  - Script: merge_csv_transformations.R.

**4. Neural Network Training**
  - Train an artificial neural network to predict coral complexity metrics using the merged dataset.
  - Script: Manuscript_ANN_&_Sensitivit_Analysis.R.

**Project Outputs**
  - Neural Network Model: Predicts coral complexity metrics (e.g., D_sfm, R_sfm, H_sfm).
  - Sensitivity Analysis: Identifies key features affecting ANN predictions.
  - Large-Scale Predictions: Coral complexity metrics scaled to larger reef areas.

**Data**
  - Training Data: Pixel variability metrics from multiple color spaces.
  - Prediction Data: Scaled metrics for applying the ANN to predict coral complexity across larger regions.
