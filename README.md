# swiftDia

## General information

The multi-platform DiaCompanion suite is representative of the current generation of m-Health. The app allows you to keep an electronic diary of your meals, physical activity and sleep. A decision tree regression-based dietary recommendation system accompanies the process. If your blood sugar level exceeds the predicted value, it will provide both general and personalised recommendations on how to improve your food intake.

![table mockup](https://github.com/artemisak/DiaCompanion_iOS/blob/main/Screenshots/mockuuups-top-view-of-phone-mockup-on-the-dinning-table.jpeg)

## Details
The app has been partially localised into English and supports iOS version 15 and higher. It can also be used on Mac computers running Mac OS Catalina.
The principle of giving recommendations is based on the analysis of current and previous meals, as well as physical activity one hour before a meal and current sugar levels. The model also incorporates many other parameters, such as BMI, week of pregnancy, number of abortions and contraceptive use, but their importance for prediction purposes is markedly lower. You can read more about the model development process in our [article](https://ieeexplore.ieee.org/document/9281297/metrics#metrics). 

We are now working to improve prediction accuracy by adding information about the composition and dynamics of the patient's gut microbiome. In addition, we have decided to drop the XGboost model in favour of CatBoost, as we have introduced many new categorical variables into the study.
<img src="[drawing.jpg](https://github.com/artemisak/DiaCompanion_iOS/blob/main/Screenshots/iPhone14%20Pro%20Deep%20Purple.png)" alt="drawing" height="500"/>
![base screen](https://github.com/artemisak/DiaCompanion_iOS/blob/main/Screenshots/iPhone14%20Pro%20Deep%20Purple.png)
![danger screen_1](https://github.com/artemisak/DiaCompanion_iOS/blob/main/Screenshots/iPhone14%20Pro%20Deep%20Purple-1.png)
![dander_screen_2](https://github.com/artemisak/DiaCompanion_iOS/blob/main/Screenshots/iPhone14%20Pro%20Deep%20Purple-2.png)
![normal_screen](https://github.com/artemisak/DiaCompanion_iOS/blob/main/Screenshots/iPhone14%20Pro%20Deep%20Purple-3.png)
