# Memoro
## Your places, your emotions.
- - - -

### Preview 

<div>
    <img src="/doc/56.PNG" width="180px"</img>
    <img src="/doc/54.PNG" width="180px"</img>
    <img src="/doc/39.PNG" width="180px"</img>
    <img src="/doc/41.PNG" width="180px"</img>
    <img src="/doc/44.PNG" width="180px"</img>
</div>

- - - -

### What is?
Memoro is an iPhone application, written in **SwiftUI**, that allows you to save **places** in the world that have stirred up **positive emotions** for you so you can find them again in a time of need.
Think of Memoro as a kind of **diary** in which you can jot down a place by entering a **title** and its **level of positive emotion**. If you wish, you can also add a description and a picture of the place.

Supported languages: **English**, **Italian**.
- - - -

### App Structure

Navigate the application through a **tab** interface. 

- **World Map** tab: 
Here you will see a world map through which you can add a new place by centering it with the **crosshair** and tapping the **+** button.
From this map you can also tap on an already added place to see its details and possibly edit them.

- **Places** tab: 
It shows a beautiful and eye-catching **carousel** where you can browse the places you have added and filter them through the **search bar**.
Each place is shown with title and emotion assigned. By tapping on the place card you can view its details with the ability to edit them.

- **Settings** tab: 
From here you can customize your **user profile** , define your **security** settings, and choose your favorite **theme** for Memoro.
- - - -

### Security
In Memoro you can protect the places you have saved from prying eyes: from settings you can set a **password** that you will be asked for every time you open the app.
Memoro saves your chosen password securely to **Keychain**.
In addition, if your iPhone is equipped with Face ID or Touch ID, you can optionally enable **biometric authentication**.
- - - -

### Theme customization
Memoro allows you to set a light theme or a dark theme, regardless of what you chose from the iOS settings, to please your eyes.
Alternatively, you can choose to have the theme fit the one you chose from the iOS settings.
- - - -

### Features of interest (developer perspective)
- MapKit
- CoreLocation
- UserDefaults - @AppStorage
- Keychain
- LocalAuthentication - Face ID / Touch ID
- PhotosUI
- Camera - UIViewControllerRepresentable
- Save files on DocumentDirectory
- Manager class for places as unique source of truth declared as @StateObject and passed via .environmentObject()
- Permission management
- App translation: English, Italian
- - - -

### Credits
Snap Carousel: 
Code inspired by a YouTube channel named Kavsoft. Hear the link to the tutorial: https://www.youtube.com/watch?v=4Gw5lDXJ04g
- - - -
