# Inventory Assistant
Inventory assistant is an app to manage inventory. The app uses the barcodes that already exist on products, instead of a seperate asset tag.<br>

# Table of Contents

* [Plugins](#plugins)
    * [Go Router](#go-router)
    * [Flutter secure storage](#flutter-secure-storage)
    * [http](#http)
    * [Barcode scan2](#barcode-scan2)
    * [Dropdown search](#dropdown-search)
    * [Flutter launcher icons](#flutter-launcher-icons)
* [Conventions](#conventions)
* [Guide](#guide)
    * [Setup](#setup)

# Plugins

### [Go Router](https://pub.dev/packages/go_router)

A declarative router for Flutter based on Navigation 2 supporting deep linking, data-driven routes and more

### [Flutter secure storage](https://pub.dev/packages/flutter_secure_storage)

Flutter Secure Storage provides API to store data in secure storage. Keychain is used in iOS, KeyStore based solution is used in Android.

### [http](https://pub.dev/packages/http)
A composable, multi-platform, Future-based API for HTTP requests.

### [Barcode scan2](https://pub.dev/packages/barcode_scan2)
A flutter plugin for scanning 2D barcodes and QRCodes via camera.

### [Dropdown search](https://pub.dev/packages/dropdown_search)
Simple and robust Searchable Dropdown with item search feature, making it possible to use an offline item list or filtering URL for easy customization.

### [Flutter launcher icons](https://pub.dev/packages/flutter_launcher_icons)
A package which simplifies the task of updating your Flutter app's launcher icon.


[[To Top](#inventory-assistant)]
# Conventions

It's important to have some conventions to follow, to make our code more readable and less confusing.<br/>
To help follow these conventions we use the linter that comes with flutter. You can read the official code style for dart [here](https://dart.dev/guides/language/effective-dart/style)

[[To Top](#inventory-assistant)]
# Guide

## Setup

To setup flutter follow their guide [here](https://docs.flutter.dev/get-started/install)<br/>
After installing Flutter you are almost ready to go, but since our server is hosted internally on the school, you will need to change the ip for the variable `ipAddress` in `api_url.dart` to the one matching your [server](https://github.com/InventoryAssistant).<br>
After this you should now be ready to run the application. <br>
To do so simply use the command `flutter run --release` inside your project directory.<br>
Alternatively you can use Android studio, here there should be a run button at the top of the IDE.<br>

[[To Top](#inventory-assistant)]
# Development

Inventory Assistant is a flutter cross-platform application, tested to work on web(Chrome/Firefox) and Android. It should also work on iOS.<br>
The backend is a Laravel project tracked in a seperate github repository [here](https://github.com/InventoryAssistant).

[[To Top](#inventory-assistant)]
