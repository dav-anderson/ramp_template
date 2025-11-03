

#[cfg(any(target_os = "ios", target_os = "macos"))]
#[link(name = "PhotosUI", kind = "framework")]
extern "C" {}

#[cfg(target_os = "macos")]
#[link(name = "Cocoa", kind = "framework")]
extern "C" {}

#[cfg(target_os = "macos")]
#[link(name = "ApplicationServices", kind = "framework")]
extern "C" {}

#[cfg(target_os = "macos")]
#[link(name = "AppKit", kind = "framework")]
extern "C" {}

#[cfg(target_os = "macos")]
#[link(name = "Carbon", kind = "framework")]
extern "C" {}

#[cfg(target_os = "ios")]
#[link(name = "UIKit", kind = "framework")]
extern "C" {}

#[cfg(any(target_os = "ios", target_os = "macos"))]
#[link(name = "CoreGraphics", kind = "framework")]
extern "C" {}

#[cfg(any(target_os = "ios", target_os = "macos"))]
#[link(name = "Metal", kind = "framework")]
extern "C" {}

#[cfg(any(target_os = "ios", target_os = "macos"))]
#[link(name = "CoreVideo", kind = "framework")]
extern "C" {}

#[cfg(any(target_os = "ios", target_os = "macos"))]
#[link(name = "CoreMedia", kind = "framework")]
extern "C" {}

#[cfg(any(target_os = "ios", target_os = "macos"))]
#[link(name = "AVKit", kind = "framework")]
extern "C" {}

#[cfg(any(target_os = "ios", target_os = "macos"))]
#[link(name = "AVFoundation", kind = "framework")]
extern "C" {}

#[cfg(any(target_os = "ios", target_os = "macos"))]#[link(name = "Security", kind = "framework")]
extern "C" {}

#[cfg(any(target_os = "ios", target_os = "macos"))]
#[link(name = "QuartzCore", kind = "framework")]
extern "C" {}

#[cfg(any(target_os = "ios", target_os = "macos"))]
#[link(name = "c++")]
extern "C" {}

#[cfg(any(target_os = "ios", target_os = "macos"))]
#[link(name = "AudioToolbox", kind = "framework")]
extern "C" {}

#[cfg(any(target_os = "ios", target_os = "macos"))]
#[link(name = "Foundation", kind = "framework")]
extern "C" {}

use roost::start;

mod examples;
use examples::{
    ice_cream::IceCreamApp,
    plants::PlantGrowerApp,
    motorcycle::MotorcycleApp,
};

// change the struct here to start a different example.
start!(MotorcycleApp);
