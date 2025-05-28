# gro_one_app

Gro One App

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


@override
void initState() {
// TODO: implement initState
initFunction();
super.initState();
}

@override
void dispose() {
// TODO: implement dispose
disposeFunction();
super.dispose();
}

void initFunction() => addPostFrameCallback(() {
//  Call your init methods
});

void disposeFunction() => addPostFrameCallback(() {

});