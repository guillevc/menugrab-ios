![Xcode build](https://github.com/guillevc/menugrab-ios/workflows/Xcode%20build/badge.svg?branch=master)

# Menugrab

Menugrab is an app that can be used to order from restaurants. It allows users to order food from a restaurant table with their phone. It's also possible to make pick-up orders remotely.

It features a list of restaurants and menus that users can choose from.

The app is also usable through an [App Clip](https://developer.apple.com/app-clips/), that is launched after scanning a table identifier provided by the restaurant (e.g. an NFC tag or a QR label) and allows the customer to start making an order without the need of installing the app.

# iOS App

This repository contains the source code of the iPhone app component of Menugrab.

It' built completely using SwiftUI and Combine, reducing to almost zero the use of callbacks and delegates.

## UI design

Overall, it consisted on the following steps:

- Research and high level analysis. Definition of user stories.
- UX design (concrete functionalities and user flows)
- Wireframes: https://www.figma.com/file/hKtCUhLgBMmh2IZvE6JENS/Wireframe?node-id=0%3A1
- Selection of color palette and fonts
- Definitive designs: https://www.figma.com/file/zHZoGCuCigH3fqq0QYCMPL/Design-v2?node-id=0%3A1

## Architecture

It's based off of [Alexey Naumov](https://github.com/nalexn)'s [Clean Architecture for SwiftUI](https://nalexn.github.io/clean-architecture-swiftui/?utm_source=nalexn_github) article and his MVVM version implementation ([clean-architecture-swiftui](https://github.com/nalexn/clean-architecture-swiftui/tree/mvvm)).

## Requirements

- Xcode 10.15+
- iOS 14+
- Firebase projects for Firebase Authentication.

## Quick start

- Add your `GoogleService-Info.plist` files to `Menugrab` and `MenugrabAppClip` folders.
- Point to working [menugrab-server](https://github.com/guillevc/menugrab-server) instance with populated restaurant data.
