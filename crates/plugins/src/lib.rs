mod camera;

// Setup the game world and its systems
pub mod world
{
    use bevy::prelude::*;

    use crate::camera;

    pub struct WorldPlugin;

    impl Plugin for WorldPlugin
    {
        fn build(&self, app: &mut App)
        {
            app.add_systems(Startup, setup);
            app.add_plugins(camera::CameraPlugin);
        }
    }

    /// set up a simple 3D scene
    fn setup(mut commands: Commands, mut meshes: ResMut<Assets<Mesh>>, mut materials: ResMut<Assets<StandardMaterial>>)
    {
        // Ground
        commands.spawn(PbrBundle {
            mesh: meshes.add(shape::Plane::from_size(5.0).into()),
            material: materials.add(Color::rgb(0.3, 0.5, 0.3).into()),
            ..default()
        });
        // Cube
        commands.spawn(PbrBundle {
            mesh: meshes.add(Mesh::from(shape::Cube { size: 1.0 })),
            material: materials.add(Color::rgb(0.8, 0.7, 0.6).into()),
            transform: Transform::from_xyz(0.0, 0.5, 0.0),
            ..default()
        });
        // Light
        commands.spawn(PointLightBundle {
            point_light: PointLight {
                intensity: 1500.0,
                shadows_enabled: true,
                ..default()
            },
            transform: Transform::from_xyz(4.0, 8.0, 4.0),
            ..default()
        });
    }
}
