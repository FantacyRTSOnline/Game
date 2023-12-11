use bevy::prelude::*;
use plugins::camera::CameraPlugin;

#[allow(non_snake_case)]
pub fn RunEngine()
{
    App::new().add_plugins(CameraPlugin).add_plugins(DefaultPlugins).run();
}
