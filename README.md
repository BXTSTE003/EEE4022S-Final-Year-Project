# EEE4022S-Final-Year-Project
This repository contains the MATLAB code used to obtain the results for my project.
The method is as follows:

1. Create 2 data variables to represent the first training video using ReadVidData and ReadFlowData.
2. Create 2 networks using GPUEncoder on the 2 data variables.
3. Create 2 data variables to represent the second training video using ReadVidData and ReadFlowData.
4. Use RetrainNet on the 2 data variables and the 2 networks, ensuring the data types of the variable and network match.
5. Repeat Steps 3 & 4 with the remaining training videos.
6. Use AnomalyDetection on a test video and the 2 trained networks to plot the anomalies in that video.
