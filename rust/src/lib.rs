use godot::prelude::*;

pub mod cosmic;
pub mod world;

struct Main;

#[gdextension]
unsafe impl ExtensionLibrary for Main {}
