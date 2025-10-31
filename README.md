# KeyHolders - A Social CPD Project

## Project Description

KeyHolders is a mobile application built with Flutter that allows users to securely store and request their physical keys. The application provides a convenient way to manage and retrieve keys, drawing inspiration from popular delivery services like Amazon, Zomato, and Swiggy.

## Features

### Screen 1: Login
- Users can log in using their user ID and password.
- Biometric authentication (if available on the device) for quick and secure login.

### Screen 2: Home
- Displays a list of keys the user has stored with the service.
- A prominent red button on the bottom right to initiate a key request.

### Screen 3: Key Selection
- If the user has multiple keys, this screen allows them to select which key they want to be delivered.
- If the user has only one key, this screen is skipped.

### Screen 4: Delivery Request
- Shows the user's current location using the phone's GPS.
- Option to request delivery to the current location or select a different address.
- Users can submit or cancel the request.
- On submission, the user is taken to the request status screen.
- On cancellation, the user is returned to the home screen.

### Screen 5: Request Status
- Displays the details of the raised request.
- Upon clicking the request, a delivery code is revealed, which needs to be shared with the delivery agent to receive the key.

## Tech Stack

- **Frontend:** Flutter
- **Backend:** Simple SQL tables for data storage.