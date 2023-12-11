use std::f32::consts::TAU;

use bevy::prelude::*;
use bevy_panorbit_camera::{PanOrbitCamera, PanOrbitCameraPlugin};

pub struct CameraPlugin;

impl Plugin for CameraPlugin
{
    fn build(&self, app: &mut App)
    {
        app.add_plugins(PanOrbitCameraPlugin);
        app.add_systems(Startup, spawn_camera);
        app.add_systems(Update, toggle_camera_controls_system);
    }
}

fn spawn_camera(mut commands: Commands)
{
    commands.spawn((
        // Note we're setting the initial position below with alpha, beta, and radius, hence
        // we don't set transform on the camera.
        Camera3dBundle::default(),
        PanOrbitCamera {
            // Set focal point (what the camera should look at)
            focus: Vec3::new(0.0, 1.0, 0.0),
            // Set the starting position, relative to focus (overrides camera's transform).
            alpha: Some(TAU / 8.0),
            beta: Some(TAU / 8.0),
            radius: Some(5.0),
            // Set limits on rotation and zoom
            alpha_upper_limit: Some(TAU / 4.0),
            alpha_lower_limit: Some(-TAU / 4.0),
            beta_upper_limit: Some(TAU / 3.0),
            beta_lower_limit: Some(-TAU / 3.0),
            zoom_upper_limit: Some(5.0),
            zoom_lower_limit: Some(1.0),
            // Adjust sensitivity of controls
            orbit_sensitivity: 1.5,
            pan_sensitivity: 0.5,
            zoom_sensitivity: 0.5,
            // Allow the camera to go upside down
            allow_upside_down: true,
            // Change the controls (these match Blender)
            button_orbit: MouseButton::Right,
            button_pan: MouseButton::Right,
            modifier_pan: Some(KeyCode::ShiftLeft),
            // Reverse the zoom direction
            reversed_zoom: true,
            ..default()
        },
    ));
}

// Press 'T' to toggle the camera controls
fn toggle_camera_controls_system(key_input: Res<Input<KeyCode>>, mut pan_orbit_query: Query<&mut PanOrbitCamera>)
{
    if key_input.just_pressed(KeyCode::T) {
        for mut pan_orbit in pan_orbit_query.iter_mut() {
            pan_orbit.enabled = !pan_orbit.enabled;
        }
    }
}
