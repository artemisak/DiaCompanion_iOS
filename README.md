# DiaCompanion iOS

## General information

The multi-platform DiaCompanion suite is representative of the current generation of m-Health. The app allows you to keep an electronic diary of your meals, physical activity and sleep. A decision tree regression-based dietary recommendation system accompanies the process. If your blood sugar level exceeds the predicted value, it will provide both general and personalised recommendations on how to improve your food intake.

## Details

The app has been partially localised into English and supports iOS version 15 and higher. It can also be used on Mac computers running Mac OS Catalina. The development was carried out using the modern SwiftUI framework with the borrowing of some elements from UIKit.

The principle of giving blood glucouse (BG) prediction is based on the analysis of current and previous meals, as well as physical activity one hour before and current BG level. The model also incorporates many other parameters, such as BMI, week of pregnancy, number of abortions and contraceptive use, but their importance for prediction purposes is markedly lower. You can read more about the model development process in our [article](https://ieeexplore.ieee.org/document/9281297/metrics#metrics). 

We are now working to improve prediction accuracy by adding information about the composition and dynamics of the patient's gut microbiome. In addition, we have decided to drop the XGboost model in favour of CatBoost, as we have introduced many new categorical variables into the study.

The dietary recommendation system takes into account the predicted blood sugar levels and the many years of medical experience of leading clinicians at the Almazov National Research Medical Centre. Based on the decision rules, it describes almost any possible situation that could cause blood sugar levels to rise above the target level and provides a dietary recommendation. The app collects the data for a week to then send it to your assigned doctor by post as an XLSX file. In the reply email, the doctor leaves comments and issues the necessary appointments. The e-diary can be downloaded by the user on their own for information purposes.

## Screenshots
<div>
<img src="https://github.com/artemisak/DiaCompanion_iOS/blob/main/Screenshots/iPhone14%20Pro%20Deep%20Purple.png" style='height: 25rem;'>
<img src="https://github.com/artemisak/DiaCompanion_iOS/blob/main/Screenshots/iPhone14%20Pro%20Deep%20Purple-3.png" style='height: 25rem;'>
<img src="https://github.com/artemisak/DiaCompanion_iOS/blob/main/Screenshots/iPhone14%20Pro%20Deep%20Purple-1.png" style='height: 25rem;'>
<img src="https://github.com/artemisak/DiaCompanion_iOS/blob/main/Screenshots/iPhone14%20Pro%20Deep%20Purple-2.png" style='height: 25rem;'>
</div>
