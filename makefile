#Ignore directores
.PHONY: android
.PHONY: ios

#Variables
BIN =src/main.rs
AN_IC =assets/icons/android_icon
AN_IC_TAR =android/app/src/main/res/

#Functions
define create_binary
	echo 'fn main() {' > $(BIN) && \
    echo '    main::desktop_main()' >> $(BIN) && \
    echo '}' >> $(BIN)
endef

define remove_binary
	rm -f $(BIN)
endef

define copy_if_exists
	if [ -f "$(1)" ]; then \
		cp "$(1)" "$(2)"; \
		echo "Copied $(1) to $(2)"; \
	fi
endef

define android_icons
	$(call copy_if_exists, $(AN_IC)48.png, $(AN_IC_TAR)mipmap-mdpi/xc_launcher.png)
	$(call copy_if_exists, $(AN_IC)72.png, $(AN_IC_TAR)mipmap-hdpi/xc_launcher.png)
	$(call copy_if_exists, $(AN_IC)96.png, $(AN_IC_TAR)mipmap-xhdpi/xc_launcher.png)
	$(call copy_if_exists, $(AN_IC)144.png, $(AN_IC_TAR)mipmap-xxhdpi/xc_launcher.png)
	$(call copy_if_exists, $(AN_IC)192.png, $(AN_IC_TAR)mipmap-xxxhdpi/xc_launcher.png)
endef


#Make targets

#build for android
android:
	$(call remove_binary)
	$(call android_icons)
	cargo apk build

android_release:
	$(call remove_binary)
	$(call android_icons)
	cargo apk build --release

#Build for IOS
ios:
	echo todo

#Build for Desktop
desktop:
	$(call create_binary)
	echo todo
	cargo build

desktop_release:
	$(call create_binary)
	echo todo
	cargo build --release

#Build for WASM
wasm:
	echo todo

#add binary file
add_bin:
	$(call create_binary)

#Remove binary file
remove_bin:
	$(call remove_binary)

