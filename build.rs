extern crate winresource;


fn main() {
    if std::env::var("CARGO_CFG_TARGET_OS").unwrap() == "windows" && std::path::Path::new("assets/resources/icons/windows_icon.ico").exists(){
        let mut res = winresource::WindowsResource::new();
        res.set_icon("assets/resources/icons/windows_icon.ico");
        res.compile().unwrap();
    }
}