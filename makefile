#Ignore directores
.PHONY: android
.PHONY: ios
.PHONY: windows

#Variables
AN_IC =assets/resources/icons/android_icon
FV_IC=assets/resources/icons/favicon.ico
AN_IC_TAR =android/app/src/main/res/
TODO=this feature is not yet fully implemented

#Functions

define copy_if_exists
	if [ -f "$(1)" ]; then \
		cp "$(1)" "$(2)"; \
		echo "Copied $(1) to $(2)"; \
	fi
endef

define android_icons
	$(call copy_if_exists,$(AN_IC)48.png,$(AN_IC_TAR)mipmap-mdpi/ic_launcher.png)
	$(call copy_if_exists,$(AN_IC)72.png,$(AN_IC_TAR)mipmap-hdpi/ic_launcher.png)
	$(call copy_if_exists,$(AN_IC)96.png,$(AN_IC_TAR)mipmap-xhdpi/ic_launcher.png)
	$(call copy_if_exists,$(AN_IC)144.png,$(AN_IC_TAR)mipmap-xxhdpi/ic_launcher.png)
	$(call copy_if_exists,$(AN_IC)192.png,$(AN_IC_TAR)mipmap-xxxhdpi/ic_launcher.png)
endef


#Make targets

#build for android
android:
	$(call android_icons)
	cargo apk build --lib

android_release:
	$(call android_icons)
	cargo apk build --release

#Build for IOS
ios:
	echo $(TODO)
	cargo build --target aarch64-apple-ios

ios_sim_intel:
	echo $(TODO)
	cargo build --target x86_64-apple-ios

ios_sim_sil:
	echo $(TODO)
	cargo build --target aarch64-apple-ios-sim

ios_release:
	echo $(TODO)
	cargo build --target aarch64-apple-ios --release


#Build for Desktop
macos:
	cargo build

macos_intel:
	cargo build --target x86_64-apple-darwin

macos_aarch:
	cargo build --target aarch64-apple-darwin

macos_release:
	$(call copy_if_exists,assets/resources/icons/macos_icon.icns,Webgpu.app/Contents/Resources/)
	cargo build --release --target x86_64-apple-darwin
	cargo build --release --target aarch64-apple-darwin
	lipo -create -output webgpu \
	target/x86_64-apple-darwin/release/webgpu \
	target/aarch64-apple-darwin/release/webgpu
	$(call copy_if_exists,webgpu,macos/Webgpu.app/Contents/MacOS/)

linux:
	cargo build

linux_release:
	cargo build --release

windows:
	cargo build --target x86_64-pc-windows-gnu

windows_release:
	cargo build --release --target x86_64-pc-windows-gnu


#Build for WASM
wasm:
	$(call copy_if_exists,$(FV_IC),web)
	cargo build --lib --target wasm32-unknown-unknown

wasm_release:
	$(call copy_if_exists,$(FV_IC),web)
	cargo build --lib --target wasm32-unknown-unknown --release


