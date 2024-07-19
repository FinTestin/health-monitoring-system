# health-monitoring-system
ESP32+LM35+MAX30102+Firebase-database+Flutter

ESP32 as the main board controller, getting the sensor data and sending out to Firebase.

After receive the data, the Apps can get the firebase data using the firbase API.

![data flow drawio (2)](https://user-images.githubusercontent.com/72807493/183589016-bedf411c-9ad0-483f-a516-dde9e8345550.png)

Arduino path

LM35 as a low cost temperature detection, which can detect the temperature change in the surrounding environment.

The MAX30102 acts as a heart rate sensor, that can senor the heart rate date by skin contact with the vascular light reflection.

The sensor data needs to be adjusted for some Settings so that it meets the normal range

![data flow drawio](https://user-images.githubusercontent.com/72807493/183588981-30bb1f7e-2651-4ee0-878f-d76771c2bb2b.png)

Firebase

Firebase acts as an iot data relay point, receive all the data come form controller senor or the Apps data.

physical devices

Put all the hardware parts in the box

![box with produce](https://user-images.githubusercontent.com/72807493/183590740-ee8902e8-6292-46db-b626-3f60d7d2c1bf.jpg)

The Application

The Apps will display firebase data in two boxes, the boxes image will also different with the values changing.
![WhatsApp Image 2022-04-30 at 3 43 23 PM (2)](https://user-images.githubusercontent.com/72807493/183590234-3f80bc7e-732d-47db-a6bf-972233559c00.jpeg)
![WhatsApp Image 2022-04-30 at 3 43 23 PM (1)](https://user-images.githubusercontent.com/72807493/183590248-8785c06d-2203-44ef-b397-761751f751a6.jpeg)
![WhatsApp Image 2022-04-30 at 3 43 23 PM](https://user-images.githubusercontent.com/72807493/183590431-05dd4c5e-875c-4bb8-944d-c297fa6b541b.jpeg)

The Apps is also including the base setting function for user including text size, Apps theme and language.

![WhatsApp Image 2022-04-30 at 3 43 24 PM (2)](https://user-images.githubusercontent.com/72807493/183590354-7c8e60d2-ff59-4ddb-b682-6fc347fc85be.jpeg)
