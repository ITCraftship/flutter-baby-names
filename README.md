# name_voter

A new Flutter project to play around with Cloud Firestore, Firebase Auth, etc.

## Resouces used for inspiration for this project

- Baby Names app: https://codelabs.developers.google.com/codelabs/flutter-firebase/
- Firebase auth: https://www.youtube.com/watch?v=OlcYP6UXlm8

The rest is my own invention to experiment with:

- eventual consistency with the use of aggregates in Firebase Functions

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Android

### Opt-in for Google CodeSigning (one time)

Go to https://developer.android.com/studio/publish/app-signing and complete the form.

### Generate a key and keystore

1.  Use the following command to initiate keytore and certificate generation:  
    `keytool -genkey -v -keystore itc-release.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias itc`
1.  Backup your `itc.keystore` file and store passwords safely. If you loose this, then there's a painful process that includes contacting Google's support (see: [Create a new upload key](https://support.google.com/googleplay/android-developer/answer/7384423)).
1.  Get your SHA1 certificate fingerprint:
    `keytool -exportcert -list -v -alias itc -keystore itc-release.keystore`

### Generate a google_play.json for upload

As Google Play account owner follow these instructions to generate the JSON key for API upload to Google Play:
https://developers.google.com/android-publisher/getting_started
