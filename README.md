# ESP32 LED Control Application

This project is an iOS application that can control LED through an ESP32 microcontroller. It is developed using SwiftUI and sends HTTP requests to ESP32 to control the LED status and mode.

## 🚀 Features

- **LED Control**: Turn LED on/off
- **3 Different Modes**: Different operating modes for LED
- **Real-time Visual Feedback**: Background color change based on LED status
- **Debounced Requests**: Delayed request system that optimizes network traffic
- **Modern UI**: User-friendly interface developed with SwiftUI
- **Data Persistence**: Mode selection is saved with SwiftData

## 🛠️ Technical Details

### Technologies Used
- **SwiftUI**: Modern iOS interface development
- **SwiftData**: Data persistence
- **URLSession**: HTTP requests
- **DispatchWorkItem**: Debounced operations

### Network Communication
The application sends HTTP GET requests to ESP32 in the following format:
```
http://***/?turnOn=on&mode=1
http://***/?turnOn=off&mode=2
```

**Parameters:**
- `turnOn`: "on" or "off" (LED status)
- `mode`: 1, 2, or 3 (LED mode)

## 🔧 Installation

### Requirements
- Xcode 15.0+
- iOS 17.0+
- ESP32 microcontroller
- WiFi network connection

### Steps
1. Clone the project
2. Open `esp32.xcodeproj` with Xcode
3. Update ESP32's IP address in `ContentView.swift` file
4. Run the application on iOS simulator or device

## 📡 ESP32 Side

You need to implement the following endpoint on ESP32:
- **Endpoint**: `/`
- **Method**: GET
- **Query Parameters**: `turnOn`, `mode`
- **Response**: JSON format with `LedResponse` structure

## 🎯 Usage

1. Open the application
2. Tap the large circular button in the center to turn LED on/off
3. Select one of the mode buttons at the bottom (1, 2, 3)
4. LED status and mode are automatically sent to ESP32
