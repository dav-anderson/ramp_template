#ignore directores
.PHONY: android
.PHONY: ios

#variables
BIN = src/main.rs

#Build for android
android:
	rm -f $(BIN)
	cargo apk build

android_release:
	rm -f $(BIN)
	cargo apk build --release

#Build for IOS
ios:
	echo todo

#Build for Desktop
desktop:
	echo 'fn main() {' > $(BIN) && \
    echo '    main::desktop_main()' >> $(BIN) && \
    echo '}' >> $(BIN)
	echo todo

#Build for WASM
wasm:
	echo todo

#add binary file
add_bin:
	echo 'fn main() {' > $(BIN) && \
    echo '    main::desktop_main()' >> $(BIN) && \
    echo '}' >> $(BIN)

#Remove binary file
remove_bin:
	rm -f $(BIN)

