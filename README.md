# Web GPU

Please note, these instructions are currently written primarily for a Unix operating system, with the exception of the IOS build which is written for MacOS.

## Android

### Prerequisites

-Rust toolchain

-Android NDK & SDK installed and configured in PATH

-Keystore

### Build APK

To build for android you must first have `cargo-apk` installed on your system. 

```cargo install cargo-apk```

Once you have installed cargo-apk, then determine the permissions your app requires and specify them in `android/app/src/main/AndroidManifest.xml`.

```
<uses-permission android:name="android.permission.INTERNET"/>
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

### Configuring Icons

In order to configure icons, each file must be named "ic_launcher.png" and must be placed within the appropriate directories located in `/android/app/src/main/res/`. The respective dimensions for each directory is as follows.

`/midmap-mdpi` = 48 x 48

`/mipmap-hdpi` = 72 x 72

`/mipmap-xhdpi` = 96 x 96

`/mipmap-xxhdpi` = 144 x 144

`/mipmap-xxxhdpi` = 192 x 192

### Configuring Fonts

In order to configure fonts, each file must be named `<font_name>.ttf` and must be placed within `/android/app/src/main/res/font/`. In addition, each font should be added to the .xml file within the `/font` directory. 

### Assets

The path to the assets directory is simply `/assets`. Anything placed here will be included in the apk, this path is configured in the `Cargo.toml`


## IOS

### Prerequisites

-Rust Toolchain

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

## IOS Updated

cd ios

make clean

make run

## Desktop

`make desktop`

## Housekeeping

Because we cannot build apk bundles with a main.rs file present (cargo always attempts to build a binary in this case), but main.rs is required when building a binary for a desktop environment, a makefile has been created to handle insertion and removal of the main.rs and it's contents where appropriate.

If you wish to manually add or remove the main function from your project for some reason, you can do so with...

`make add_bin`

or

`make remove_bin`

However, this is not necessary for you to manually add or remove main.rs with these commands before building for your target environment as long as you use the `make <target>` processes outlined above. Please keep in mind, because of this automated process, users are strongly discouraged from attempt to edit the contents of main.rs, as these changes will be lost when building with makefile unless you were to edit the shell script contained in `makefile` as well.