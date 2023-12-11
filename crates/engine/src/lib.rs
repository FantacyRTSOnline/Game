use bevy::prelude::*;
use plugins::camera::CameraPlugin;

#[allow(non_snake_case)]
pub fn RunEngine()
{
    App::new()
    // Built ins
    .add_plugins(DefaultPlugins)
    // Custom plugins
    .add_plugins(CameraPlugin)
    //
    .run();
}
