# Web GPU

Please note, these instructions are currently written primarily for a Unix operating system, with the exception of the IOS build which is written for MacOS.

### Prerequisites

-Rust toolchain

The easiest way to install the rust toolchain is with the following `rustup` script

`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`

Restart your terminal and verify that rust and cargo are installed with

`rustc --version`

`cargo --version`

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

### Build APK

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

### Configuring App Icons

In order to configure icons, each file must be named "android_iconXX.png" where "XX" refers to the resolution of the icon. The file must be placed within the  `assets/resources/icons` directory. The required dimensions are as follows. Icons are handled automatically by the makefile. Sample icons have been provided.

`android_icon48.png` = 48 x 48

`android_icon72.png` = 72 x 72

`android_icon96.png` = 96 x 96

`android_icon144.png` = 144 x 144

`android_icon192.png` = 192 x 192

### Configuring Fonts

In order to configure fonts, each file must be named `<font_name>.ttf` and must be placed within `resources/fonts/` directory. Sample fonts have been provided.

### Images

The path to the images directory is simply `assets/images`. Images placed here will be included in the apk, a sample image has been provided.


## IOS - WIP

### Prerequisites

-MacOS

-Homebrew

-Xcode

To build for IOS you must first have `cargo-lipo` installed on your system.

```cargo install cargo-lipo```

Next you must install `cbindgen`.

```cargo install cbindgen```

Add IOS targets to rustup

```rustup target add aarch64-apple-ios x86_64-apple-ios```

(Optional) Add simulator targets to rustup if desired

```rustup target add aarch64-apple-ios-sim x86_64-apple-ios```

Ensure the `Cargo.toml` specifies the a lib section (this has been provided by default)

```
[lib]
name = "library_name"
crate-type = ["cdylib"] # or "staticlib" if you want a static library rather than dynamic
```

Build your library with cargo lipo (specify a release build with the proper flag: `--release`)

```cargo lipo```

This will compile your rust library into `library_name.a` output at `target/universal/debug` or `target/universal/release`

Create a C header using the library name you have specificed in the lib section of the `Cargo.toml`

```cbindgen --config cbindgen.toml --output include/<library_name>.h```

Create an Xcode project in which you wish to use your Rust Library

Copy the dynamic or static library into your Xcode's project library folder

Add the library to your target's "Link Binary With Libraries" in the build phases

Include your C header and ensure Xcode can find it

Make sure to link any dependencies required for your library or framework with Xcode project

Update the "Header Search Paths" to include the directory where your C headers are located

Update "Library Search Paths" to include where your .a file is located

Build and run your app on an IOS device or IOS simulator

### IOS Updated - WIP

cd ios

make clean

make run

## Desktop for MacOS - WIP

### Prerequisites

-MacOS

-Homebrew

-Xcode

WIP

### Building the Binary

WIP

`make desktop_macos`

`make desktop_macos_release`

## Desktop for Linux

### Building the Binary

To build for desktop on Unix systems

`make desktop_linux`

To build for desktop release on Unix Systems

`make desktop_linux_release`

In either case, you will find your binary at `/target/<release>/<project_name>`. Where `<release>` corresponds to either `'debug'` or `'release'` depending on which makefile commmand you run, and `<project_name>` corresponds to the package name in the `Cargo.toml`. 

By default, running `make_desktop_linux` would output your binary at `/target/debug/webgpu`

### Configuring Desktop Icon

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

## Desktop for Windows - WIP

### Prerequisites

-Install the required rustup build target

`rustup target add x86_64-pc-windows-gnu`

### Building the Binary

To compile the binary you must run the following command.

`make desktop_windows`

If you wish to compile a release version use this command instead.

`make_desktop_windows_release`

Once you have finished compiling your binary will be available at the following path: `/target/x86_64-pc-windows-gnu/<debug or release>/<project_name>.exe` 

### Adding a Desktop Icon to your .EXE

Determine what image you would like to use as your icon, this will typically be a .png file. You then must convert the `.png` to a `.ico` file type. Doing this requires you first install `imagemagick`.

`sudo apt install imagemagick`

Once you finish the installation place your png of choice in `assets/resources/icons` and run the following script from within the icons directory where `<target_image_file>` refers to the `.png` you wish to convert. 

`convert <target_image_file>.png -define icon::auto-resize=256,128,64,48,32,16 windows_icon.ico`

Install `mingw-w64`:

`sudo apt install mingw-w64`

Compile the windows `app.rc` file:

`x86_64-w64-mingw32-windres app.rc -O coff -o app.res`



## Web Assembly - WIP

### Prerequisites

WIP

### Building the Binary

WIP

`make wasm`

`make wasm_release`



