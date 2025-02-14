extern crate winres;


fn main() {
    if cfg!(target_os = "windows") {
        if std::path::Path::new("assets/resources/icons/windows_icon.ico").exists(){
            let mut res = winres::WindowsResource::new();
            res.set_icon("assets/resources/icons/windows_icon.ico");
            res.compile().unwrap();
        }
    }
}