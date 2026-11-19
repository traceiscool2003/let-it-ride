class_name MovementConfig
extends Resource
## Every movement tunable lives here. Open res://config/movement.tres in the
## inspector and tweak feel without touching code. Units: pixels and seconds
## (one tile = 16 px).

@export_group("Run")
@export var max_run_speed := 125.0
@export var ground_accel := 7000.0
@export var ground_decel := 9000.0
@export var turn_accel := 12000.0
@export var air_accel := 5000.0
@export var air_decel := 4000.0
## How fast speed ABOVE max_run_speed bleeds off. Low = momentum is preserved.
@export var overspeed_decay_ground := 900.0
@export var overspeed_decay_air := 500.0
@export var absolute_max_speed := 420.0

@export_group("Jump")
@export var gravity := 1150.0
@export var fall_gravity_mult := 1.45
## Gravity multiplier near the apex while jump is held (floatier peak).
@export var apex_gravity_mult := 0.7
@export var apex_threshold := 30.0
@export var jump_velocity := 345.0
## Velocity kept when jump is released early (variable jump height).
@export var jump_cut_mult := 0.15
@export var max_fall_speed := 380.0
@export var coyote_time := 0.1
@export var jump_buffer := 0.1
## Bumping your head within this many pixels of a corner nudges you around it.
@export var corner_correction := 4.0

@export_group("Wall")
@export var wall_slide_speed := 60.0
@export var wall_jump_velocity := Vector2(170, 320)
## Seconds after a wall jump where horizontal input is ignored.
@export var wall_jump_lock := 0.1
@export var wall_coyote_time := 0.1
@export var wall_run_min_speed := 135.0
@export var wall_run_speed := 280.0
@export var wall_run_time := 0.32

@export_group("Ledge")
## Vertical tolerance (px) for catching a ledge.
@export var ledge_grab_window := 8.0
@export var ledge_climb_time := 0.15

@export_group("Slide")
@export var slide_min_speed := 90.0
@export var slide_boost := 50.0
@export var slide_friction := 190.0
@export var slide_stop_speed := 45.0
@export var slide_cooldown := 0.2

@export_group("Vault")
@export var vault_min_speed := 115.0
@export var vault_hop_velocity := 190.0
@export var vault_speed_bonus := 15.0
@export var vault_time := 0.12

@export_group("Dash")
@export var dash_speed := 330.0
@export var dash_time := 0.17
## Velocity kept when the dash ends.
@export var dash_end_mult := 0.0
## Seconds between dashes (ground or air).
@export var dash_cooldown := 0.4

@export_group("Stomp")
@export var stomp_bounce := 280.0
@export var stomp_bounce_held := 380.0

@export_group("Combat")
@export var attack_time := 0.2
## Portion of the swing (from its start) where the hitbox is live.
@export var attack_active := 0.11
@export var attack_cooldown := 0.06
## Press again within this window after a swing to continue the combo.
@export var combo_window := 0.3
@export var finisher_lunge := 120.0
@export var pogo_bounce := 300.0
@export var parry_window := 0.2
## Lockout after a whiffed parry (a successful parry resets it).
@export var parry_cooldown := 0.45

@export_group("Body")
@export var stand_size := Vector2(10, 22)
@export var slide_size := Vector2(10, 10)
