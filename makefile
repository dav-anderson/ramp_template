#Ignore directores
.PHONY: android
.PHONY: ios
.PHONY: windows

#Variables
AN_IC =assets/resources/icons/android_icon
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

ios_release:
	echo $(TODO)

#Build for Desktop
macos:
	echo $(TODO)

macos_release:
	echo $(TODO)

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
	echo $(TODO)

wasm_release:
	echo $(TODO)

