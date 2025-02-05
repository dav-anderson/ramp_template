#variables
BIN = src/main.rs

#Build for android
android:
	rm -f $(BIN)
	cargo apk build

#Build for IOS

#Build for Desktop
desktop:
	echo 'fn main() {' > $(BIN) && \
    echo '    main::desktop_main()' >> $(BIN) && \
    echo '}' >> $(BIN)

#Build for WASM
