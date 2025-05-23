# Web GPU

Please note, these instructions are currently written primarily for a Unix operating system, with the exception of the IOS build which is written for MacOS.

### Prerequisites

-Rust toolchain

The easiest way to install the rust toolchain is with the following `rustup` script

`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`

Restart your terminal and verify that rust and cargo are installed with

`rustc --version`

`cargo --version`

### Configuring Fonts

In order to configure fonts, each file must be named `<font_name>.ttf` and must be placed within `resources/fonts/` directory. Sample fonts have been provided.

### Images

The path to the images directory is simply `assets/images`. Images placed here will be included in the apk, a sample image has been provided.

## Android

### Prerequisites

-Android NDK & SDK installed and manually configured in PATH

`sudo apt install android-sdk android-ndk`

Set your NDK path in your .bashrc or .zshrc

Note: this configuration is merely an example, your actual configuration will vary based on the path to your NDK

`export ANDROID_NDK_HOME=$HOME/Android/Sdk/ndk/YOUR_NDK_VERSION`

-Keystore

-Install the required build target for android devices

`rustup target add aarch64-linux-android`

-(Optional) Install the required build target for Android device emulators

`rustup target add i686-linux-android`

`rustup target add x86_64-linux-android`

### (Optional) Configuring App Icons

In order to configure icons, each file must be named "android_iconXX.png" where "XX" refers to the resolution of the icon. The file must be placed within the  `assets/resources/icons` directory. The required dimensions are as follows. Icons are handled automatically by the makefile. Sample icons have been provided.

`android_icon48.png` = 48 x 48

`android_icon72.png` = 72 x 72

`android_icon96.png` = 96 x 96

`android_icon144.png` = 144 x 144

`android_icon192.png` = 192 x 192

### Building for Android

To build for android you must first have `cargo-apk` installed on your system. 

```cargo install cargo-apk```

Once you have installed cargo-apk, then determine the permissions your app requires and specify them in `Cargo.toml`.

```
[[package.metadata.android.uses_permission]]
name = "android.permission.INTERNET"
```

By default, this template already enables internet permission as shown above, you may add as many additional permissions as your app requires.

After configuring the proper permissions you can build the apk with...

```make android```

By default, your build output will appear in `webgpu/target/debug/apk` . Here, you can verify that your permissions were set correctly by viewing the AndroidManifest.xml in the output directory.

If you wish to build for release, you must first configure a release key in your keystore and in the `Cargo.toml` as follows

```
[package.metadata.android.signing.<profile>]
path = "relative/or/absolute/path/to/my.keystore"
keystore_password = "password"
```

 and then run

```make android_release```

### Hot Loading APK on an Android Device:

If you wish to test your android apk on an android phone via usb tether, you will first need to install adb

 `sudo apt install android-tools-adb`

 Once you have installed adb you will need to unlock the device and put it into developer debugging mode in order to hotload your apk. To do this you will need to navigate to Settings > About Device, or Settings > About > Software Information, or something similar. You are looking for an "About Phone" section, which you should rapidly tap to enable developer mode. You may now connect your device via usb tether and be sure to enable access to phone data via the prompt on the device after connecting.

You can now run `adb devices` to verify that your device is recognized by your computer. You can now install your apk with 

`adb install -r /target/debug/apk/<projectname>.apk`

Once the streaming install has completed you can test your app in shell with (the package name will be something like org.packagename.example/android.app.NativeActivity). 

`adb shell am start -n <package_name/android:name>`

Alternatively you may search for your app on the phones application tab and tap to run like you would normally.

## IOS

### Prerequisites

-MacOS

-Homebrew

-Xcode

-IOS SDK with PATH properly configured

-Install the required build target for IOS devices

`rustup target add aarch64-apple-ios x86_64-apple-ios aarch64-apple-ios-sim`

### (Optional) Adding an App Icon

Add a `.png` to `assets/resources/icons` named `ios_icon.png` of 1024x1024


### Building the Binary for simulator

If the Mac you using to run the simulator has a Silicone chipset run:

`make ios_sim_sil`

Otherwise, if your mac uses an intel chipset run:

`make ios_sim_intel`

Sign the app bundle

`codesign --force --deep --sign - ios/Webgpu.app`

Open the simulator

`open -a simulator`

Load the app into the simulator

`xcrun simctl install booted ios/Webgpu.app`

Launch the loaded app according to the CFBundleIdentifier provided in the `ios/Webgpu.app/Info.plist`

`xcrun simctl launch booted com.example.webgpu`

### Building and deploying IOS binary

Build and run your app on an IOS device

`make ios`

or

`make_ios_release`

Generate a signing certificate. Open `Keychain Access` for MacOS. Go to `Certificate Assistant > Request a Certificate from a Certificate Authority`.

Use your Apple ID email and save the `.certSigningRequest`

Add the APP ID from `ios/Webgpu.app/Info.plist` to your `developer.apple.com` account. By default this ID is set to `com.example.webgpu`

Upload your `.certSigningRequest`, download the `.cer` file and double click it to install it to your keychain

Register your device UDID (try `idevice_id -l`)

Create a provisioning profile (Development, link your Apple ID, certificate, and device;) download it (something like `dev.mobileprovision`)

Place the mobile provision within your `.app`

`cp dev.mobileprovision ios/Webgpu.app/embedded.mobileprovision`

Sign the binary with your developer certificate

`codesign -f -s "iphone developer: Your Name (ID)" ios/Webgpu.app`

verify your signature

`codesign -vvv ios/Webgpu.app`

You may now install and launch your `.app` bundle to a device tethered via USB with 

`ios-deploy --bundle ios/Webgpu.app`

## Desktop for MacOS

### Prerequisites

-MacOS

-Homebrew

-Xcode & Xcode build tools

-Install the required build targets for both MacOS device chipsets

`rustup target add x86_64-apple-darwin aarch64-apple-darwin`

### (Optional) Configuring Desktop Icon

Determine what image you would like to use as your icon, this will typically be a `.png` file. If you already have your `.icns` rename it to `"macos_icon.icns"` and place it inside of `assets/resources/icons`. If you first need to convert a `.png` to a `.icns` filetype, add your desktop icon `.png` to `assets/resources/icons`, rename it to `macos_icon.png` and then run the following script from within the `assets/resources/icons` directory

`sips -s format icns macos_icon.png --out macos_icon.icns`

The path to this icon is configured in your `macos/Webgpu.app/Contents/Info.plist`. If you wish to rename this app, you will need to create your own `.app` directory with the appropriate changes and also modify the makefile & plist appropriately.


### Building for MacOS

When building for MacOS you have a couple of different options. If you just want to build a binary that will run on the computer you are compiling on, you can simply do the following.

To compile the binary you must run the following command.

`make macos`

This output will appear at the following path `target/debug/webgpu` and will only work on your native chipset.

If you wish to compile a release version use this command instead.

`make macos_release`

Apple uses two different chipset architectures for devices created before 2020 and after 2020. If you are building for release as shown above, your completed output will be `Webgpu.app` in the `macos` directory and will work on either chipset.

You can test this output by running the following while in the macos directory, you should also see the desktop icon here in a file explorer if you configured it properly:

`open Webgpu.app`

### (Optional - Debug Only) Creating a Universal Binary

Note: if you have run `make macos_release` the universal binary will have been handled for you.

If you for some reason want to build for a specific architecture (Note that `make macos` automatically builds for your current chipset) see the following:

(Debug only) To build for apple intel chipset (pre 2020):

`make macos_intel`

This output will be available at `target/debug/webgpu`

(Debug only) To build for apple silicon chipsets (M1, M2, M3):

`make macos_aarch`

This output will be available at `target/debug/webgpu`

once you have manually compiled both `make macos_aarch` and `make macos_intel` debug binaries you must combine them into a universal binary.

A universal MacOS binary will run on both Intel and Apple Silicon chipsets. In order to do this you will need to first compile for both architectures as shown above.

Then you can use `lipo` to merge the binaries. The path will be dependent on whether or not you are merging either debug or release binaries but you should only need to do this when releasing a binary.

release:
```
lipo -create -output <project_name> \
target/x86_64-apple-darwin/release/<project_name> \
target/aarch64-apple-darwin/release/<project_name>
```

The output binary will appear in the root of the project directory as `<project_name>` provided in the above script. By default this will be named `webgpu`.

## Desktop for Linux

### Building for Linux

To build for desktop on Unix systems

`make linux`

To build for desktop release on Unix Systems

`make linux_release`

In either case, you will find your binary at `/target/<release>/<project_name>`. Where `<release>` corresponds to either `'debug'` or `'release'` depending on which makefile commmand you run, and `<project_name>` corresponds to the package name in the `Cargo.toml`. 

By default, running `make linux` would output your binary at `/target/debug/webgpu`

### (Optional) Configuring Desktop Icon

Linux Desktop Icons must be configured locally with a `.png` file. This file should be placed within `~/.local/share/icons`. 

You will then need to create a `.desktop` file at `~/.local/share/applications/<project_name>.desktop` where `<project_name>` corresponds to the name you've chosen for your binary, by default this will be `webgpu`.

The `.desktop` file should look similar to as follows, ensure you fill in the proper details:

```
[Desktop Entry]
Name=<project_name>
Exec=/path/to/binary
Icon=<icon_name>
Type=Application
Categories=Utility
```
Once you have done this, run the following command in your terminal to link the desktop icon with your binary. 
`update-desktop-database ~/.local/share/applications`

## Desktop for Windows

### Prerequisites

-Install the required rustup build target

`rustup target add x86_64-pc-windows-gnu`

-Install `mingw-w64`:

`sudo apt install mingw-w64`

### (Optional) Adding a Desktop Icon to your .EXE

Determine what image you would like to use as your icon, this will typically be a `.png` file. If you already have your `.ico` rename it to `"windows_icon.ico"` and place it inside of `assets/resources/icons`. If you first need to convert a `.png` to a `.ico` filetype, this requires you first install `imagemagick`. 

`sudo apt install imagemagick`

Once you finish the installation place your png of choice in `assets/resources/icons` and run the following script from within the icons directory where `<target_image_file>` refers to the `.png` you wish to convert. 

`convert <target_image_file>.png -define icon::auto-resize=256,128,64,48,32,16 windows_icon.ico`

If you followed these steps correctly, you will now have a windows_icon.ico file located within `assets/resources/icons`


Return to the project root and compile the windows `app.rc` file:

`x86_64-w64-mingw32-windres app.rc -O coff -o app.res`


### Building for Windows

To compile the binary you must run the following command.

`make windows`

If you wish to compile a release version use this command instead.

`make windows_release`

Once you have finished compiling your binary will be available at the following path: `/target/x86_64-pc-windows-gnu/<debug or release>/<project_name>.exe` 

## Web Assembly

### Prerequisites

-Install the required rustup build target
`rustup target add wasm32-unknown-unknown`

### (Optional) Adding a Favicon

Determine what image you would like to use as your icon, this will typically be a .png file. If you already have your `.ico` rename it to `"favicon.ico"` and place it inside of `assets/resources/icons`. If you first need to convert a `.png` to a `.ico` filetype, this requires you first install `imagemagick`. 

`sudo apt install imagemagick`

Once you finish the installation place your png of choice in `assets/resources/icons` and run the following script from within the icons directory where `<target_image_file>` refers to the `.png` you wish to convert. 

`convert <target_image_file>.png -define icon::auto-resize=256,128,64,48,32,16 favicon.ico`

If you followed these steps correctly, you will now have a favicon.ico file located within `assets/resources/icons`

Note: Your favicon may not load properly if you have a stale cache. You can try force reloading your browsers cache memory (Firefox: ctr + shift + R; Chrome: ctrl + right reload button; Edge: ctrl + F5)

### Building for WASM

To compile the library you must run the following command.

`make wasm`

If you wish to compile a release version use this command instead.

`make wasm_release`

To test your build cd into `web` and run your `index.html` in localhost with something like

`busybox httpd -f -p 8080`

This command should make the contents of `/web/index.html` viewable at `localhost::8080` in your browser.



