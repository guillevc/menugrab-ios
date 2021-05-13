![Xcode build](https://github.com/guillevc/menugrab-ios/workflows/Xcode%20build/badge.svg?branch=master)

# Menugrab

Menugrab is an app that can be used to order from restaurants. It allows users to order food from a restaurant table with their phone. It's also possible to make pick-up orders remotely.

It features a list of restaurants and menus that users can choose from.

The app is also usable through an [App Clip](https://developer.apple.com/app-clips/), that launches itself after scanning a table identifier provided by the restaurant (e.g. an NFC tag or a QR label) and allows the customer to start making an order without the need of installing the app.

# iOS App

This repository contains the source code of the iPhone app component of the application.

It' built completely using SwiftUI and Combine, reducing to almost zero the use of callbacks and delegates.

## UI design

Figma: https://www.figma.com/file/zHZoGCuCigH3fqq0QYCMPL/Design-v2?node-id=0%3A1

## Architecture

It's based off of [Alexey Naumov](https://github.com/nalexn)'s [Clean Architecture for SwiftUI](https://nalexn.github.io/clean-architecture-swiftui/?utm_source=nalexn_github) article and his MVVM version implementation ([clean-architecture-swiftui](https://github.com/nalexn/clean-architecture-swiftui/tree/mvvm)).
