use bevy::prelude::*;
use plugins::world::WorldPlugin;

#[allow(non_snake_case)]
pub fn RunEngine()
{
    App::new()
    // Built ins
    .add_plugins(DefaultPlugins)
    // Custom plugins
    .add_plugins(WorldPlugin)
    //
    .run();
}
