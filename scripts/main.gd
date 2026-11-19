extends Node
## Game director: run state, Pot / Bankroll economy, Flow, House Rules,
## combat resolution, bosses, breakables, casino games, story, perks (The
## Fence), lighting, post-processing, adaptive music.

const LevelScript := preload("res://scripts/level.gd")
const PlayerScript := preload("res://scripts/player.gd")
const EnemyScript := preload("res://scripts/enemy.gd")
const BossScript := preload("res://scripts/boss.gd")
const ProjScript := preload("res://scripts/projectile.gd")
const ChipScript := preload("res://scripts/chip.gd")
const PropScript := preload("res://scripts/prop.gd")
const FXScript := preload("res://scripts/fx.gd")
const FoliageScript := preload("res://scripts/foliage.gd")
const AmbientScript := preload("res://scripts/ambient.gd")
const HUDScript := preload("res://scripts/hud.gd")
const CasinoScript := preload("res://scripts/casino.gd")
const Story := preload("res://scripts/story.gd")
const Charms := preload("res://scripts/charms.gd")
const Wardrobe := preload("res://scripts/wardrobe.gd")
const Weapons := preload("res://scripts/weapons.gd")
const Cities := preload("res://scripts/cities.gd")
const VoiceMisc := preload("res://scripts/voice_lines_misc.gd")
const VoiceLines := preload("res://scripts/voice_lines.gd")
const VoiceProfiles := preload("res://scripts/voice_profiles.gd")
const BossDefs := preload("res://scripts/boss_defs.gd")
const EnemyTypes := preload("res://scripts/enemy_types.gd")
const Dialogue := preload("res://scripts/dialogue.gd")
const Menus := preload("res://scripts/menus.gd")
const MagsScript := preload("res://scripts/mags.gd")
const SettingsScript := preload("res://scripts/settings.gd")

## Default keyboard bindings (the Settings > Controls tab can change them).
const DEFAULT_KEYS := {
	"left": [KEY_A, KEY_LEFT], "right": [KEY_D, KEY_RIGHT],
	"up": [KEY_W, KEY_UP], "down": [KEY_S, KEY_DOWN],
	"jump": [KEY_SPACE, KEY_Z, KEY_C],
	"dash": [KEY_SHIFT, KEY_X],
	"attack": [KEY_F, KEY_J],
	"parry": [KEY_Q, KEY_K],
	"focus": [KEY_E, KEY_L],
	"shoot": [KEY_G, KEY_O], "weapon": [KEY_TAB], "map": [KEY_M],
	"confirm": [KEY_ENTER, KEY_KP_ENTER],
	"restart": [KEY_R], "pause": [KEY_ESCAPE, KEY_P],
	"choose1": [KEY_1], "choose2": [KEY_2],
	"debug1": [KEY_F1], "debug2": [KEY_F2],
}


## A Losing Ticket lying on the floor (lore collectible).
class TicketNode extends Node2D:
	var t := 0.0
	func _process(delta: float) -> void:
		t += delta
		queue_redraw()
	func _draw() -> void:
		var y := sin(t * 2.5) * 1.5
		draw_circle(Vector2(0, y), 9.0, Color(1, 0.95, 0.75, 0.12 + 0.06 * sin(t * 4.0)))
		draw_set_transform(Vector2(0, y), sin(t * 1.7) * 0.2, Vector2.ONE)
		draw_rect(Rect2(-5, -3.5, 10, 7), Color(0.96, 0.94, 0.85))
		draw_rect(Rect2(-5, -3.5, 10, 7), Color(0.55, 0.4, 0.3), false, 0.6)
		draw_rect(Rect2(-3.5, -1.5, 6, 0.8), Color(0.4, 0.3, 0.3))
		draw_rect(Rect2(-3.5, 0.5, 4, 0.8), Color(0.4, 0.3, 0.3))
		draw_rect(Rect2(2, -2.5, 2, 2), Color(0.85, 0.15, 0.2))
		draw_set_transform(Vector2.ZERO)

const RULES := {
	"heavy": {"name": "HEAVY POCKETS", "desc": "Gravity +25%"},
	"loiter": {"name": "NO LOITERING", "desc": "Flow drains 3x faster"},
	"edge": {"name": "HOUSE EDGE", "desc": "Twice the spikes"},
	"security": {"name": "SECURITY DETAIL", "desc": "Twice the guards and bats"},
	"lights": {"name": "LIGHTS OUT", "desc": "The power's been cut"},
	"lastcall": {"name": "LAST CALL", "desc": "40s on the clock, then the Pot bleeds"},
	"glass": {"name": "GLASS JAW", "desc": "Any hit busts you"},
	"grounded": {"name": "GROUNDED", "desc": "No air dash"},
}

## Skill tree: five branches of four. Each node needs the one above it and
## costs SKILL POINTS (earned by levelling up, or bought from The Fence).
const BRANCHES := [
	["BODY", Color(1, 0.45, 0.45)], ["FISTS", Color(0.5, 0.85, 1)], ["FEET", Color(0.5, 1, 0.75)],
	["FORTUNE", Color(1.0, 0.78, 0.25)], ["GAMBLER", Color(1, 0.5, 0.85)],
]
const SKILLS := [
	{"id": "skin1", "name": "THICK SKIN", "desc": "+1 max life", "branch": 0, "tier": 0, "cost": 1, "grants": {"skin": 1}},
	{"id": "warm1", "name": "HOT STREAK", "desc": "Start every floor with 25 Flow", "branch": 0, "tier": 1, "cost": 2, "grants": {"warm": 1}},
	{"id": "skin2", "name": "IRON HIDE", "desc": "+1 more max life", "branch": 0, "tier": 2, "cost": 3, "grants": {"skin": 1}},
	{"id": "revive", "name": "NINE LIVES", "desc": "Once per run, a killing blow leaves you on 1 life instead", "branch": 0, "tier": 3, "cost": 4, "grants": {"revive": 1}},
	{"id": "blade1", "name": "BRASS KNUCKLES", "desc": "+1 strike damage", "branch": 1, "tier": 0, "cost": 1, "grants": {"blade": 1}},
	{"id": "parry1", "name": "IRON NERVE", "desc": "Much wider parry window", "branch": 1, "tier": 1, "cost": 2, "grants": {"parry": 2}},
	{"id": "hay", "name": "HAYMAKER", "desc": "Combo finishers deal +2 damage", "branch": 1, "tier": 2, "cost": 3, "grants": {"haymaker": 2}},
	{"id": "blade2", "name": "LOADED GLOVES", "desc": "+1 more strike damage", "branch": 1, "tier": 3, "cost": 4, "grants": {"blade": 1}},
	{"id": "spring", "name": "SPRING HEELS", "desc": "Jump 8% higher", "branch": 2, "tier": 0, "cost": 1, "grants": {"jump": 1}},
	{"id": "dash2", "name": "SECOND WIND", "desc": "A second air dash", "branch": 2, "tier": 1, "cost": 2, "grants": {"dash": 1}},
	{"id": "flowkeep", "name": "FREE RUNNER", "desc": "Flow drains 35% slower", "branch": 2, "tier": 2, "cost": 3, "grants": {"flowkeep": 1}},
	{"id": "fleet", "name": "FLEET FOOTED", "desc": "+7% run and dash speed", "branch": 2, "tier": 3, "cost": 4, "grants": {"speed": 1}},
	{"id": "mag1", "name": "STICKY FINGERS", "desc": "Much bigger chip magnet", "branch": 3, "tier": 0, "cost": 1, "grants": {"magnet": 2}},
	{"id": "luck1", "name": "LOADED DICE", "desc": "Luckier slots, more gold chips", "branch": 3, "tier": 1, "cost": 2, "grants": {"luck": 2}},
	{"id": "ins1", "name": "INSURANCE", "desc": "Keep 30% of the Pot when you bust", "branch": 3, "tier": 2, "cost": 3, "grants": {"insure": 2}},
	{"id": "stake", "name": "HIGH ROLLER", "desc": "Start every run with $150 in the Pot", "branch": 3, "tier": 3, "cost": 4, "grants": {"stake": 1}},
	{"id": "cardsense", "name": "CARD SENSE", "desc": "Blackjack: get a read on the dealer's hidden card", "branch": 4, "tier": 0, "cost": 1, "grants": {"cardsense": 1}},
	{"id": "hottable", "name": "HOT TABLE", "desc": "+10% on every casino win", "branch": 4, "tier": 1, "cost": 2, "grants": {"hottable": 1}},
	{"id": "sidehustle", "name": "SIDE HUSTLE", "desc": "Side bets pay 50% more", "branch": 4, "tier": 2, "cost": 3, "grants": {"sidebet": 1}},
	{"id": "highlimit", "name": "HIGH LIMIT", "desc": "$1,000 and $2,500 bets at every table", "branch": 4, "tier": 3, "cost": 4, "grants": {"highlimit": 1}},
]

## Playable runners.
const CHARACTERS := [
	{"name": "RICO", "desc": "Balanced. Fast hands, faster feet.", "lock": "", "hood": Color(0.30, 0.18, 0.45), "hood_l": Color(0.47, 0.31, 0.64), "speed": 1.0, "hp": 0, "dmg": 0, "flow": 0.0},
	{"name": "DICE", "desc": "Glass cannon speedster. +12% speed, starts hot, -1 life.", "lock": "Beat Big Sal to unlock.", "hood": Color(0.15, 0.45, 0.55), "hood_l": Color(0.25, 0.65, 0.75), "speed": 1.12, "hp": -1, "dmg": 0, "flow": 40.0},
	{"name": "JULES", "desc": "The brother. Heavy hitter: +1 life, +1 damage, a bit slower.", "lock": "Finish the story to unlock.", "hood": Color(0.2, 0.45, 0.3), "hood_l": Color(0.3, 0.6, 0.4), "speed": 0.93, "hp": 1, "dmg": 1, "flow": 0.0},
]

const TROPHIES := [
	{"id": "first_bank", "name": "Walk Away", "desc": "Cash out for the first time"},
	{"id": "ride8", "name": "Let It Ride", "desc": "Reach a x8 Pot multiplier"},
	{"id": "flow5", "name": "In The Zone", "desc": "Hit the x5 Flow tier"},
	{"id": "chain30", "name": "Unbroken", "desc": "Chain 30 moves"},
	{"id": "parry10", "name": "Iron Wall", "desc": "Parry 10 times in one run"},
	{"id": "smash25", "name": "Bull In A Casino", "desc": "Smash 25 things in one run"},
	{"id": "boss1", "name": "Sal's Out", "desc": "Defeat Big Sal"},
	{"id": "boss2", "name": "Wheel Stops", "desc": "Defeat Madame Roulette"},
	{"id": "boss3", "name": "House Falls", "desc": "Defeat The House"},
	{"id": "jackpot", "name": "Triple Seven", "desc": "Hit the slot machine jackpot", "secret": true},
	{"id": "blackjack", "name": "Natural", "desc": "Win with a blackjack"},
	{"id": "rich", "name": "High Roller", "desc": "Bank $2,000 in one run"},
	{"id": "greedy", "name": "Should've Banked", "desc": "Bust with $1,000+ at risk", "secret": true},
	{"id": "drinks", "name": "Regular", "desc": "Buy a drink from Lucky"},
	{"id": "charms5", "name": "Lucky Charms", "desc": "Hold 5 charms at once"},
	{"id": "vault", "name": "Safecracker", "desc": "Crack a Vault Door"},
	{"id": "bet", "name": "Side Hustle", "desc": "Win a side bet"},
	{"id": "loan", "name": "Square With Mags", "desc": "Pay back a loan"},
	{"id": "pet", "name": "Good Kitty", "desc": "Pet Comp the cat"},
	{"id": "daily", "name": "Daily Grind", "desc": "Play a Daily Deal"},
	{"id": "heat5", "name": "High Stakes", "desc": "Beat The House at Heat 5 or higher"},
	{"id": "tickets", "name": "Paper Trail", "desc": "Find every Losing Ticket"},
	{"id": "true_end", "name": "Cashed Out", "desc": "Let Eddie walk away", "secret": true},
	{"id": "level10", "name": "Made Man", "desc": "Reach level 10"},
	{"id": "all_skills", "name": "Fully Loaded", "desc": "Learn every skill at The Fence"},
	{"id": "bigwin", "name": "Big Winner", "desc": "Win 10x your bet at a casino table"},
	{"id": "royal", "name": "Royalty", "desc": "Hit a Royal Flush", "secret": true},
	{"id": "ladder", "name": "Top Rung", "desc": "Climb 6 rungs on the Hi-Lo ladder"},
	{"id": "doubler", "name": "Double Trouble", "desc": "Win Double or Nothing three times in a row"},
	{"id": "stash", "name": "Finders Keepers", "desc": "Crack open a hidden stash"},
	{"id": "elite", "name": "Bouncer Bouncer", "desc": "Knock out an elite guard"},
]

## Side bets offered at the kiosk near the start of a floor. `pay` is the
## multiple of the stake you win.
const SIDE_BETS := [
	{"id": "nodmg", "name": "CLEAN HANDS", "desc": "Take no damage this floor", "pay": 3.0},
	{"id": "fast", "name": "IN AND OUT", "desc": "Reach the exit within 60 seconds", "pay": 2.5},
	{"id": "flow4", "name": "HOT HAND", "desc": "Hit the x4 Flow tier this floor", "pay": 2.0},
	{"id": "chain", "name": "UNBROKEN", "desc": "Chain 20 moves this floor", "pay": 3.0},
	{"id": "kills", "name": "BOUNCER'S NIGHTMARE", "desc": "Knock out 6 enemies this floor", "pay": 2.0},
	{"id": "smash", "name": "BULL IN A CASINO", "desc": "Smash 8 things this floor", "pay": 2.0},
]

## Table Limits: opt-in difficulty unlocked after you first beat The House.
## Each point of Heat adds 10% to what you bank. `rule` makes a House Rule
## permanent for the whole run.
const STAKES := [
	{"id": "comps", "name": "NO COMPS", "desc": "Vera and Lucky charge 50% more", "heat": 1},
	{"id": "edge", "name": "HOUSE EDGE", "desc": "Every floor has twice the spikes", "heat": 1, "rule": "edge"},
	{"id": "loiter", "name": "NO LOITERING", "desc": "Flow always drains 3x faster", "heat": 1, "rule": "loiter"},
	{"id": "hot", "name": "HOT START", "desc": "Start at x2 with a random House Rule", "heat": 1},
	{"id": "shark", "name": "LOAN SHARKED", "desc": "Mags wants 75% interest, a floor sooner", "heat": 1},
	{"id": "security", "name": "TIGHT SECURITY", "desc": "Every floor has double security", "heat": 2, "rule": "security"},
	{"id": "short", "name": "SHORT STACK", "desc": "-1 max life", "heat": 2},
]

## Lobby objects: interaction prompt and who you talk to.
const HUB_KINDS := {
	"phone": ["CALL MARLOW", "MARLOW"], "vera": ["TALK TO VERA", "VERA"], "mags": ["TALK TO MAGS", "MAGS"],
	"lucky": ["TALK TO LUCKY", "LUCKY"], "jules": ["TALK TO JULES", "JULES"], "cat": ["PET COMP", ""],
	"tickets": ["READ LOSING TICKETS", ""], "board": ["TABLE LIMITS", ""], "trophies": ["TROPHY CASE", ""],
	"fence": ["THE FENCE  (skill tree)", ""], "daily": ["DAILY DEAL", ""],
}
const LOAN_PRINCIPAL := 200
## Zones of The Pit. Floors 1-4 are the Slot Hall (Big Sal on 4), 5-8 the
## Back Rooms (Madame Roulette on 8), 9-12 the Vault (The House on 12), and
## everything below is High Limit.
const ZONES := [
	{"name": "ATLANTIC SHITTY: RESORTZ", "paint": "slots", "sub": "Velvet, brass, and a thousand hungry machines."},
	{"name": "RENO: CIRRCUS CIRRCUS", "paint": "back", "sub": "The biggest little city. The smallest little odds."},
	{"name": "BILOXI: HARD ROK", "paint": "vault", "sub": "Guitars on the wall. Sharks in the water."},
	{"name": "FREMONT: GOLDUN NUGGET", "paint": "deep", "sub": "Old Vegas. Neon, gold, and a tank full of sharks."},
	{"name": "THE ALLEY", "paint": "back", "sub": "Wet cardboard, a flickering sign, and the smell of a bad decision."},
	{"name": "THE STRIP: BELLAGIRO", "paint": "deep", "sub": "The nicest casino in Vegas. The fountain alone costs more than you."},
]
const GAME_NAMES := {
	"slots": "SLOTS", "blackjack": "BLACKJACK", "roulette": "ROULETTE", "poker": "VIDEO POKER",
	"holdem": "HOLD'EM", "baccarat": "BACCARAT", "hilo": "HI-LO",
}
## First-run controls coach: [move, actions to show, how].
const COACH := [
	["MOVE", "left,right", "Run left and right. Momentum carries."],
	["JUMP", "jump", "Tap to hop, hold to jump higher."],
	["STRIKE", "attack", "Hit three times for a combo finisher."],
	["AIR DASH", "dash", "Dash any direction, even in mid-air."],
	["WALL RUN", "", "Run at a wall and keep holding toward it."],
	["SLIDE", "down", "Hold DOWN while running to slide."],
	["PARRY", "parry", "Press it the moment an enemy flashes !"],
]
const BOSS_ARENAS := ["THE HIGH-STAKES ROOM", "THE PRIVATE TABLE", "THE HOUSE'S PENTHOUSE"]
const LOAD_TIPS := [
	"Cash out at a door and the money is yours forever. Ride it and the Pot doubles, but so does the risk.",
	"Watch for the wind-up flash, then PARRY. Parried cards and roulette balls fly back at whoever threw them.",
	"Chaining moves without touching the ground fills Flow. Higher Flow means every chip is worth more.",
	"Cracked walls hide stash rooms. Strike them, or dash through with Flow behind you.",
	"Every slot machine has its own hidden odds. Some are loose. Some are cold. None of them tell you which.",
	"In Hi-Lo, every right guess climbs the ladder. Walk away before the cards turn on you.",
	"Video Poker pays best on a Royal Flush. Hold your pairs, chase your flushes.",
	"Banker wins slightly more often in Baccarat. The House still takes its 5%.",
	"Vault Doors seal on a timer. Run straight there and press UP for a free charm.",
	"Mags will lend you $200. Pay her back on time or she swims through the walls to collect.",
	"Level up to earn SKILL POINTS, then spend them at The Fence in the Lobby.",
	"Lucky's Shot of Courage gives you an extra life. It's usually cheaper than a bust.",
	"Heavies block strikes from the front. Stomp them, flank them, or parry their swing.",
	"Each House Rule you ride into stays until you cash out. Cashing out wipes the slate clean.",
	"Side bets pay more the deeper you go. An All-In stake pays the most, if you can pull it off.",
	"Double or Nothing: after any casino win you can gamble the payout on one card. Red or black.",
	"Comp the cat likes you. Pet him before a run for a head start on Flow.",
	"Losing Tickets tell the story of the man behind The House. Find all twenty.",
	"In Blackjack you can DOUBLE DOWN on your first two cards: one more card, twice the bet.",
	"Bosses have three phases. The last one is the meanest. Save your parries for it.",
	"Roulette has more than red and black: try a Dozen at 3:1, or one lucky number at 35:1.",
	"High Roller Hold'em: fold a bad hand and you only lose the ante.",
	"Your charms only last for one run. Your skills last forever.",
	"The Daily Deal is the same floors for everyone. One scored attempt per day.",
]
## Spotlight color over each character / booth.
const SPOT_COLS := {
	"vera": Color(1.0, 0.5, 0.65), "mags": Color(0.6, 0.75, 1.0), "phone": Color(0.45, 0.85, 1.0),
	"lucky": Color(0.55, 1.0, 0.6), "bar": Color(0.55, 1.0, 0.6), "jules": Color(0.55, 1.0, 0.7),
	"cat": Color(1.0, 0.75, 0.9), "tickets": Color(1.0, 0.9, 0.7), "board": Color(1.0, 0.4, 0.4),
	"trophies": Color(0.5, 0.9, 1.0), "fence": Color(0.5, 1.0, 0.55), "daily": Color(0.45, 0.85, 1.0),
	"bets": Color(0.45, 0.85, 1.0), "vault": Color(1.0, 0.8, 0.35),
}

const RED_C := Color(1.0, 0.35, 0.35)

const POST_SHADER := """
shader_type canvas_item;
uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;
uniform float iris = 2.0;
uniform vec2 iris_center = vec2(0.5);
uniform float hurt = 0.0;
uniform float flow = 0.0;
uniform float slowmo = 0.0;
uniform float bloom = 1.0;
uniform float vignette = 1.0;
void fragment() {
	vec2 uv = SCREEN_UV;
	vec3 col = texture(screen_tex, uv).rgb;
	vec3 blur = textureLod(screen_tex, uv, 2.5).rgb * 0.5 + textureLod(screen_tex, uv, 4.5).rgb * 0.5;
	col += max(blur - vec3(0.32), vec3(0.0)) * 0.9 * bloom;
	float l = dot(col, vec3(0.299, 0.587, 0.114));
	col = mix(vec3(l), col, 1.1 + flow * 0.25);
	col *= vec3(1.03, 0.98, 1.06);
	vec2 d = uv - 0.5;
	d.x *= 1.6;
	float v = smoothstep(0.42, 1.05, length(d));
	col *= 1.0 - v * 0.6 * vignette;
	col = mix(col, vec3(0.65, 0.0, 0.06), v * hurt);
	col = mix(col, vec3(l) * vec3(0.85, 0.95, 1.15), slowmo * 0.55);
	vec2 q = uv - iris_center;
	q.x *= 1.7778;
	col *= 1.0 - smoothstep(iris - 0.03, iris, length(q));
	COLOR = vec4(col, 1.0);
}
"""

@export var movement: MovementConfig

@export_group("Flow")
@export var flow_gains := {
	"WALL JUMP": 14.0, "WALL RUN": 16.0, "MANTLE": 9.0, "LEDGE HOP": 8.0,
	"SLIDE": 8.0, "SLIDE JUMP": 11.0, "SLIDE KICK": 18.0, "VAULT": 14.0,
	"AIR DASH": 7.0, "STOMP": 18.0, "STRIKE": 6.0, "FINISHER": 14.0, "POGO": 16.0,
	"PARRY": 22.0, "SMASH": 7.0, "BOSS HIT": 8.0, "BOSS STOMP": 20.0, "KO": 12.0,
}
@export var flow_max := 100.0
@export var flow_tier_size := 25.0
@export var flow_idle_drain := 5.0
@export var flow_stopped_drain := 55.0
@export var flow_stop_speed := 45.0
@export var flow_stop_grace := 0.6
@export var flow_repeat_penalty := 0.3

@export_group("Run")
@export var base_hp := 3
@export var last_call_time := 40.0
@export var last_call_bleed := 0.08
@export var boss_every := 5

## Tests point this at a throwaway file so they never touch your real save.
var save_path := "user://save.cfg"
var state := "title"
var rng := RandomNumberGenerator.new()
var world: Node2D
var level
var player
var boss
var fx
var camera: Camera2D
var player_light: PointLight2D
var enemies: Array = []
var chips: Array = []
var props: Array = []
var projectiles: Array = []
var hud
var post: ColorRect
var dark_rect: ColorRect
var unshaded: CanvasItemMaterial
var casino
## Slot machines on this floor, keyed by position: each has its own odds.
var machines := {}
var charms: Charms
## Nerve: fills as you land hits; hold FOCUS to turn 33 of it into a life.
var nerve := 0.0
const NERVE_MAX := 99.0
const NERVE_COST := 33.0
var focus_t := 0.0
## Ranged weapons (weapons.gd): owned ids, the equipped one, per-weapon ammo.
var owned_weapons: Array = ["chip_flick"]
var weapon_id := "chip_flick"
var weapon_ammo := {}
var shoot_cd := 0.0
## Worn clothing ids for this run (see wardrobe.gd). Abilities come from here.
var worn: Array = []
var menu: Menus
var settings: SettingsScript
var settings_return := "title"
var ambient_node: Node2D
var foliage_node: Node2D

var hp := 3
var start_hp := 3
var pot := 0
var pot_mult := 1
var banked := 0
var floor_num := 1
var rules: Array = []
var pending_rule := ""
var choice_idx := 0
var choice_t := 0.0
var flow := 0.0
var chain := 0
var best_chain := 0
var last_move := ""
var stop_t := 0.0
var popups: Array = []
var banner_t := 0.0
var banner_sub := ""
var trauma := 0.0
var last_call_left := -1.0
var bleed_acc := 0.0
var dead_t := 0.0
var death_reason := ""
var death_quip := ""
var lost_pot := 0
var kept_pot := 0
var new_best := false
var run_time := 0.0
var iris_t := 0.0
var hurt_flash := 0.0
var slowmo := 0.0
var callout := ""
var callout_t := 0.0
var callout_col := Color.WHITE
var boss_shout := ""
var boss_shout_t := 0.0
var interact_text := ""
var interact_pos := Vector2.ZERO
var stats := {}

# Dialogue.
var dialog: Array = []
var dialog_chars := 0.0
var dialog_spoken: Array = []
var dialog_clip := 0.0
var dialog_clip_wait := 0.0
var recent_death := false
## Hunter's journal: kills per enemy / boss name (saved).
var bestiary := {}
var journal_on := false
var combos_seen := {}
var wobble_t := 0.0
## Map screen (M): markers you drop (floor-local world positions).
var map_markers: Array = []
var voice_test_on := false
var vt_char := 0
var vt_line := 0
var dialog_after := ""
# Menus.
var title_sel := 0
var skill_sel := 0
var skill_msg := ""
var pause_sel := 0
var char_i := 0
var toasts: Array = []
var trophies := {}
var music_vol := 0.8
var sfx_vol := 0.8
var run_dmg_bonus := 0
var run_cfg: MovementConfig
var chip_mult := 1

# Lobby, story and reactive dialogue.
var in_hub := false
var hub_new := {}
var pending_menu := ""
var menu_return := "play"
var bark_text := ""
var bark_t := 0.0
var bark_cd := 0.0
var cat_bonus := 0.0
var cat_pet_this_visit := false
# Run extras: seeds, charms, loans, side bets, vaults, tickets, assist.
var run_seed := 0
var is_daily := false
var daily_scored := false
var charm_queue: Array = []
var ride_streak := 0
var run_rides := 0
var run_cashouts := 0
var run_max_mult := 1
var floor_t := 0.0
var dice_chip_t := 0.0
var debt_principal := 0
var debt_interest := 0
var debt_deadline := 0
var debt_overdue_hit := false
var pending_loan := false
var mags_node: Node2D
var active_bet := {}
var pending_bet := {}
var bet_used := false
var vault := {}
var ticket_node: Node2D
var assisted := false
var debug_overlay := false
var heat_run := 0
var last_cause := ""
var heat_bonus := 0
# Cinematics: letterbox bars, camera pans, title cards, dialogue.
var cine: Array = []
var cine_step := {}
var cine_t := 0.0
var cine_after := "play"
var bars := 0.0
var bars_target := 0.0
var card_text := ""
var card_sub := ""
var card_t := 0.0
var card_dur := 0.0
var cam_from := Vector2.ZERO
var cam_to := Vector2.ZERO
var zoom_from := 3.0
var zoom_to := 3.0
var cam_zoom := 3.0
# One-time tips.
var load_kind := ""
var load_title := ""
var load_sub := ""
var load_tip := ""
var load_t := 0.0
var load_dur := 2.0
var load_fn := Callable()
var load_done := false
var load_post := "play"
var fade_in := 0.0
var wipe_t := 0.0
var wipe_built := false
var respawn_drop := false
var zone_card_t := 0.0
var zone_card := ""
var cast_name := ""
var cast_role := ""
var cast_line := ""
var tip_title := ""
var tip_text := ""
var tip_t := 0.0

# Persistent.
var pstats := {}
var flags := {}
var seen := {}
var tickets := {}
var stakes_on := {}
var daily_date := ""
var daily_best := 0
var daily_done := false
var assist_speed := 1.0
var assist_invincible := false

# Persistent.
var best := 0
var xp := 0
var level_num := 1
var skill_points := 0
var sp_bought := 0
var revive_used := false
var coach_i := -1
var coach_ok_t := 0.0
var coach_step_t := 0.0
var xp_flash := 0.0
var last_xp_gain := 0
var wallet := 0
var lifetime := 0
var runs := 0
var perks := {}
var intro_seen := false
var exit_tip_seen := false
var bosses_beaten := 0
var ending_seen := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if movement == null:
		movement = load("res://config/movement.tres")
	rng.randomize()
	_setup_input()
	_load()
	call_deferred("_apply_volume")
	unshaded = CanvasItemMaterial.new()
	unshaded.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
	casino = CasinoScript.new()
	charms = Charms.new()
	menu = Menus.new()
	settings = SettingsScript.new()
	_load_extra()

	var post_layer := CanvasLayer.new()
	post_layer.layer = 4
	add_child(post_layer)
	post = ColorRect.new()
	post.size = Vector2(1280, 720)
	post.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sh := Shader.new()
	sh.code = POST_SHADER
	var mat := ShaderMaterial.new()
	mat.shader = sh
	post.material = mat
	post_layer.add_child(post)
	dark_rect = ColorRect.new()
	dark_rect.visible = false

	var hud_layer := CanvasLayer.new()
	hud_layer.layer = 10
	add_child(hud_layer)
	hud = HUDScript.new()
	hud.g = self
	hud_layer.add_child(hud)

	_build_floor()
	get_tree().paused = true
	state = "title"


## Sum of an effect granted by every owned skill node.
func perk(id: String) -> int:
	var n := 0
	for sk in SKILLS:
		if perks.has(sk["id"]):
			n += int((sk["grants"] as Dictionary).get(id, 0))
	return n


func has_skill(id: String) -> bool:
	return perks.has(id)


func skill_available(sk: Dictionary) -> bool:
	if has_skill(sk["id"]):
		return false
	if int(sk["tier"]) == 0:
		return true
	for o in SKILLS:
		if o["branch"] == sk["branch"] and int(o["tier"]) == int(sk["tier"]) - 1:
			return has_skill(o["id"])
	return false


func char_unlocked(i: int) -> bool:
	match i:
		1: return bosses_beaten >= boss_every
		2: return ending_seen
	return true


func title_items() -> Array:
	return ["NEW GAME" if not intro_seen else "CONTINUE", "THE FENCE  (skill tree)", "TROPHY CASE", "SETTINGS", "QUIT GAME"]


func pause_items() -> Array:
	return ["RESUME", "SETTINGS", "START RUN" if in_hub else "RESTART RUN", "QUIT TO TITLE"]


func unlock(id: String) -> void:
	if trophies.has(id):
		return
	for tr in TROPHIES:
		if tr["id"] == id:
			trophies[id] = true
			toasts.append({"text": "TROPHY UNLOCKED", "sub": tr["name"], "t": 4.0})
			xp += 50
			Sfx.play("buy")
			_save()
			return


# ---------------------------------------------------------------- input map

func _setup_input() -> void:
	var keys := DEFAULT_KEYS
	var pads := {
		"left": [JOY_BUTTON_DPAD_LEFT], "right": [JOY_BUTTON_DPAD_RIGHT],
		"up": [JOY_BUTTON_DPAD_UP], "down": [JOY_BUTTON_DPAD_DOWN],
		"jump": [JOY_BUTTON_A], "dash": [JOY_BUTTON_B, JOY_BUTTON_RIGHT_SHOULDER],
		"attack": [JOY_BUTTON_X], "focus": [JOY_BUTTON_RIGHT_STICK], "shoot": [JOY_BUTTON_LEFT_STICK], "parry": [JOY_BUTTON_LEFT_SHOULDER, JOY_BUTTON_Y],
		"pause": [JOY_BUTTON_START], "restart": [JOY_BUTTON_BACK],
	}
	var axes := {
		"left": [JOY_AXIS_LEFT_X, -1.0], "right": [JOY_AXIS_LEFT_X, 1.0],
		"up": [JOY_AXIS_LEFT_Y, -1.0], "down": [JOY_AXIS_LEFT_Y, 1.0],
	}
	for a in keys:
		if not InputMap.has_action(a):
			InputMap.add_action(a, 0.35)
		for k in keys[a]:
			var ev := InputEventKey.new()
			ev.physical_keycode = k
			InputMap.action_add_event(a, ev)
	for a in pads:
		for b in pads[a]:
			var ev := InputEventJoypadButton.new()
			ev.button_index = b
			InputMap.action_add_event(a, ev)
	for a in axes:
		var ev := InputEventJoypadMotion.new()
		ev.axis = axes[a][0]
		ev.axis_value = axes[a][1]
		InputMap.action_add_event(a, ev)


func _jp(a: String) -> bool:
	return Input.is_action_just_pressed(a)


# ---------------------------------------------------------------- run flow

func _start_run(daily := false) -> void:
	in_hub = false
	Engine.time_scale = assist_speed
	if not char_unlocked(char_i):
		char_i = 0
	var ch: Dictionary = CHARACTERS[char_i]
	run_cfg = movement.duplicate()
	run_cfg.max_run_speed *= ch["speed"]
	run_cfg.dash_speed *= ch["speed"]
	run_cfg.wall_run_min_speed *= ch["speed"]
	if perk("speed") > 0:
		run_cfg.max_run_speed *= 1.07
		run_cfg.dash_speed *= 1.07
	if perk("jump") > 0:
		run_cfg.jump_velocity *= 1.08
	revive_used = false
	run_dmg_bonus = ch["dmg"]
	charms.reset_run()
	recent_death = false
	boss_order.clear()
	worn = Wardrobe.START_OUTFIT.duplicate()
	nerve = 0.0
	focus_t = 0.0
	owned_weapons = ["chip_flick"]
	weapon_id = "chip_flick"
	weapon_ammo = {}
	heat_run = heat()
	hp = 99
	_recalc_max_hp()
	hp = start_hp
	pot = 150 if perk("stake") > 0 else 0
	pot_mult = 1
	banked = 0
	floor_num = 1
	best_chain = 0
	new_best = false
	run_time = 0.0
	runs += 1
	stats = {"kills": 0, "parries": 0, "smashed": 0, "chips": 0, "bosses": 0, "casino": 0}
	# Seeds: every floor layout comes from run_seed, so a Daily Deal is the
	# same set of floors for everyone that day.
	is_daily = daily
	daily_scored = false
	if daily:
		var today := Time.get_date_string_from_system()
		if daily_date != today:
			daily_date = today
			daily_best = 0
			daily_done = false
		daily_scored = not daily_done
		daily_done = true
		run_seed = absi(hash("daily:" + today))
		rng.seed = run_seed
		_stat_add("daily_played")
		unlock("daily")
	else:
		rng.randomize()
		run_seed = rng.randi()
	rules = _stake_rules()
	if _stake("hot"):
		pot_mult = 2
		var avail: Array = RULES.keys().filter(func(k): return not rules.has(k))
		rules.append(avail[rng.randi_range(0, avail.size() - 1)])
	# Mags' loan, taken in the Lobby.
	debt_principal = 0
	debt_interest = 0
	debt_overdue_hit = false
	if pending_loan:
		pending_loan = false
		pot += LOAN_PRINCIPAL
		debt_principal = LOAN_PRINCIPAL
		debt_interest = 150 if _stake("shark") else 100
		debt_deadline = 2 if _stake("shark") else 3
		_stat_add("loans")
	ride_streak = 0
	run_rides = 0
	run_cashouts = 0
	run_max_mult = pot_mult
	charm_queue.clear()
	active_bet = {}
	assisted = assist_speed < 1.0 or assist_invincible
	banner_sub = Story.WHISPERS[rng.randi_range(0, Story.WHISPERS.size() - 1)]
	_build_floor()
	if cat_bonus > 0.0:
		flow = minf(flow_max, flow + cat_bonus)
		cat_bonus = 0.0
	state = "play"
	get_tree().paused = false
	Sfx.play("start")
	_save()
	tip_t = 0.0
	_tip("goal", "YOUR GOAL", "Grab chips, chain moves to build Flow (bottom left), and reach the EXIT door. The map (top right) marks the exit once you've seen it.")
	coach_i = 0 if not flags.has("coach_done") and settings.val("tips") else -1
	coach_step_t = 0.0
	if _debt() > 0:
		_tip("loan_run", "MAGS' LOAN", "Mags takes her cut whenever you cash out. Pay her back by the end of floor %d or she comes swimming through the walls." % debt_deadline)
	if daily:
		_bark("daily", true)
	elif rng.randf() < 0.5:
		_say([Story.RADIO[rng.randi_range(0, Story.RADIO.size() - 1)]], "")
	else:
		_bark("start", true)


## Secret boss: a side fight reached through a hidden door (item 15).
var in_secret := false
var secret_id := ""


func is_boss_floor() -> bool:
	return in_secret or floor_num % boss_every == 0


func _build_floor() -> void:
	if world:
		world.queue_free()
	enemies.clear()
	chips.clear()
	props.clear()
	projectiles.clear()
	boss = null
	world = Node2D.new()
	world.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(world)
	move_child(world, 0)

	var cm := CanvasModulate.new()
	cm.color = Color(0.07, 0.06, 0.1) if rules.has("lights") else Color(0.52, 0.44, 0.6)
	world.add_child(cm)

	level = LevelScript.new()
	world.add_child(level)
	var grng := RandomNumberGenerator.new()
	grng.seed = hash("%d:%d" % [run_seed, floor_num])
	if in_hub:
		grng.seed = 7
		level.generate_lobby(grng)
		level.games = level.games.filter(func(gm): return _hub_kind_available(gm[1]))
	elif is_boss_floor():
		var bdef := boss_def_for(floor_num)
		level.generate_boss(grng, int(bdef["tier"]), rules, Cities.zone_of(floor_num))
	else:
		level.generate(grng, floor_num, rules, threat(), zone_of(floor_num))
		level.games = level.games.filter(func(gm): return _floor_kind_available(gm[1]))
	if not rules.has("lights"):
		cm.color = level.pal()["mod"]
	level.broke.connect(_on_broke)
	level.crumble_started.connect(_on_crumble)

	for s in level.chip_spots:
		var v: int = s[1]
		if v == 5 and rng.randf() < perk("luck") * 0.08:
			v = 25
		_add_chip(s[0], v)

	for s in level.prop_spots:
		var p = PropScript.new()
		p.kind = ["crate", "urn", "case", "safe"][s[1]]
		p.position = s[0]
		world.add_child(p)
		props.append(p)
	vault = {}
	machines = {}
	for gm in level.games:
		if gm[1] != "slots":
			var p = PropScript.new()
			p.kind = gm[1]
			p.position = gm[0]
			world.add_child(p)
			if SPOT_COLS.has(gm[1]):
				level.make_light((gm[0] as Vector2) + Vector2(0, -30), SPOT_COLS[gm[1]], 0.9, 0.42, false)
			if gm[1] == "vault":
				var dist_tiles: float = (gm[0] as Vector2).distance_to(level.start_pos) / 16.0
				vault = {"pos": gm[0], "prop": p, "par": clampf(10.0 + dist_tiles * 0.5, 20.0, 50.0), "state": "closed"}
	ticket_node = null
	if not in_hub and not level.is_boss and level.ticket_spot != Vector2.ZERO and _next_ticket() >= 0 and rng.randf() < 0.5:
		ticket_node = TicketNode.new()
		ticket_node.position = level.ticket_spot
		ticket_node.material = unshaded
		world.add_child(ticket_node)

	player = PlayerScript.new()
	player.cfg = charms.apply_cfg(run_cfg if run_cfg else movement)
	var ch: Dictionary = CHARACTERS[char_i]
	player.hood = ch["hood"]
	player.hood_l = ch["hood_l"]
	player.level = level
	player.position = level.start_pos
	player.gravity_mult = 1.25 if rules.has("heavy") else 1.0
	player.dash_enabled = not rules.has("grounded")
	player.dash_max = 1 + perk("dash") + charms.dash_bonus()
	player.dashes = player.dash_max
	level.set_meta("player", player)
	_apply_worn()
	player.pounded.connect(_on_pound)
	player.parry_bonus = perk("parry") * 0.05
	world.add_child(player)
	player.move_done.connect(_on_move)
	player.landed.connect(_on_land)
	player_light = PointLight2D.new()
	player_light.texture = LevelScript.light_tex()
	player_light.color = Color(0.85, 0.85, 1.0)
	player_light.energy = 1.1 if rules.has("lights") else 0.55
	player_light.texture_scale = 1.0 if rules.has("lights") else 0.75
	player_light.shadow_enabled = rules.has("lights")
	player.add_child(player_light)

	for s in level.enemy_spots:
		_spawn_enemy(s[0], s[1])

	if level.is_boss:
		boss = BossScript.new()
		boss.position = level.boss_spawn + Vector2(0, -18)
		raise_paid = 0
		boss.setup(floor_num, level, player, boss_def_for(floor_num))
		world.add_child(boss)
		boss.fire.connect(_on_boss_fire)
		boss.summon.connect(_on_boss_summon)
		boss.slammed.connect(_on_boss_slam)
		boss.phase_changed.connect(_on_boss_phase)
		boss.defeated.connect(_on_boss_defeated)

	fx = FXScript.new()
	fx.material = unshaded
	world.add_child(fx)
	player.fx = fx

	var fol = FoliageScript.new()
	fol.setup(level, player)
	world.add_child(fol)
	foliage_node = fol

	camera = Camera2D.new()
	cam_zoom = 2.0 if level.is_boss else 3.0
	camera.zoom = Vector2(cam_zoom, cam_zoom)
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = level.w * level.T
	camera.limit_bottom = level.h * level.T
	world.add_child(camera)
	camera.global_position = player.global_position
	camera.make_current()

	var amb = AmbientScript.new()
	amb.setup(level, camera)
	world.add_child(amb)
	ambient_node = amb
	_apply_world_settings()

	last_call_left = last_call_time if rules.has("lastcall") and not in_hub else -1.0
	bleed_acc = 0.0
	flow = 0.0 if in_hub else minf(flow_max, perk("warm") * 25.0 + float(ch["flow"]))
	chain = 0
	last_move = ""
	stop_t = 0.0
	popups.clear()
	banner_t = 2.8
	chip_mult = 1
	iris_t = 0.0
	charms.reset_floor()
	map_markers.clear()
	floor_t = 0.0
	dice_chip_t = 0.0
	bet_used = false
	active_bet = {}
	if in_hub:
		banner_t = 0.0
	# Mags comes collecting on a late loan (never on boss floors).
	mags_node = null
	if not in_hub and not level.is_boss and _debt() > 0 and floor_num > debt_deadline:
		mags_node = MagsScript.new()
		var side := -1.0 if level.start_pos.x > level.w * 8 else 1.0
		mags_node.position = Vector2(clampf(level.start_pos.x + side * 300.0, 24.0, level.w * 16 - 24.0), maxf(24.0, level.start_pos.y - 140.0))
		mags_node.target = player
		mags_node.speed = 58.0 + floor_num * 2.0
		world.add_child(mags_node)
		_bark("loan_due", true)
		if not debt_overdue_hit:
			debt_overdue_hit = true
			_stat_add("defaulted")
	if mags_node and not flags.has("mags_cine") and state == "play":
		flags["mags_cine"] = true
		_cinematic_later([
			{"do": "bars", "v": 1.0}, {"do": "sfx", "name": "windup"},
			{"do": "pan", "to": "mags", "zoom": 3.6, "t": 1.1}, {"do": "shake", "v": 0.3},
			{"do": "say", "lines": Story.MAGS_CHASE},
			{"do": "pan", "to": "player", "zoom": cam_zoom, "t": 0.7}, {"do": "bars", "v": 0.0},
		], "mags")
	if not in_hub and not level.is_boss and floor_num > 1 and state == "play":
		# 1-2 buffs per floor, Risk of Rain style: a pick of three, sometimes a free bonus.
		var picks: Array = charms.roll(rng, 3)
		if picks.size() > 0:
			charm_queue.append({"pick": picks, "title": "FLOOR %d BUFF" % floor_num})
		if rng.randf() < 0.35:
			var bonus_b: Array = charms.roll(rng, 1)
			if bonus_b.size() > 0:
				charm_queue.append({"charm": bonus_b[0]})
	if not in_hub and state == "play" and not is_boss_floor() and Cities.floor_in_city(floor_num) == (0 if floor_num > 5 else 0) and floor_num <= 25:
		var cn := Cities.city_of(floor_num) + 1
		var sid := "city%d_arrive" % cn
		if VoiceMisc.SCENES.has(sid):
			_cinematic_later([{"do": "bars", "v": 1.0}, {"do": "card", "text": String(Cities.info(floor_num)["name"]), "sub": String(Cities.info(floor_num)["full"]), "t": 2.2},
				{"do": "say", "lines": VoiceMisc.SCENES[sid]}, {"do": "bars", "v": 0.0}], sid)
	if is_boss_floor() and state == "play" and not in_hub:
		var tier: int = boss.tier
		_tip("boss", "BOSS FLOOR", "The exit stays locked until the boss goes down. Watch for the wind-up, then parry (Q / K) or get out of the way.")
		_cinematic_later([
			{"do": "bars", "v": 1.0}, {"do": "sfx", "name": "windup"},
			{"do": "pan", "to": "boss_low", "zoom": 3.0, "t": 1.4}, {"do": "shake", "v": 0.45}, {"do": "sfx", "name": "slam"},
			{"do": "card", "text": boss.bname, "sub": boss.title, "t": 2.2},
			{"do": "say", "lines": boss_intro_lines(boss.def)},
			{"do": "pan", "to": "player", "zoom": cam_zoom, "t": 0.8}, {"do": "bars", "v": 0.0},
		], "boss%d" % tier)
		_bark("boss", true)


func _add_chip(pos: Vector2, v: int):
	var c = ChipScript.new()
	c.value = v
	c.position = pos
	c.material = unshaded
	world.add_child(c)
	chips.append(c)
	return c


## Break an amount into real chip denominations (largest first, max `cap` chips).
func chips_for(amount: int, cap := 10) -> Array:
	var out: Array = []
	for d in [1000, 500, 100, 25, 5, 1]:
		while amount >= d and out.size() < cap:
			out.append(d)
			amount -= d
	if amount > 0 and out.size() > 0:
		out[out.size() - 1] = int(out[out.size() - 1]) + amount if out[out.size() - 1] < 5 else out[out.size() - 1]
	return out


func _spawn_loose(pos: Vector2, values: Array) -> void:
	for v in values:
		var c = _add_chip(pos, v)
		c.launch(level, Vector2(rng.randf_range(-120, 120), rng.randf_range(-280, -140)))


func _spawn_enemy(pos: Vector2, kind: int) -> void:
	var e = EnemyScript.new()
	var th := threat()
	if not level.is_boss and (kind == 0 or kind == 1):
		# Enemies get more professional as you climb (enemy_types.gd): alley
		# junkies and rats first, pit bosses and suited security later,
		# snipers and drones on the Strip.
		kind = EnemyTypes.pick(floor_num, kind == 1, rng)
	var elite: bool = not level.is_boss and kind != 1 and not EnemyTypes.info(kind).get("air", false) and rng.randf() < clampf((floor_num - 3) * 0.03 * th, 0.0, 0.3)
	e.position = pos
	e.setup(kind, level, player, floor_num, th, elite)
	world.add_child(e)
	e.fire.connect(_on_boss_fire)
	enemies.append(e)


func _enter_secret() -> void:
	var city := Cities.city_of(floor_num)
	var opts: Array = ["snake_eyes", "rusty_slots"] if city < 3 else ["rusty_slots", "mr_lucky"]
	secret_id = opts[rng.randi_range(0, opts.size() - 1)]
	in_secret = true
	_stat_add("secrets")
	_loading("boss%d" % int(BossDefs.by_id(secret_id)["tier"]), "SECRET TABLE", "A side boss: " + String(BossDefs.by_id(secret_id)["name"]), func(): _build_floor())



func _reach_exit() -> void:
	_resolve_bet_at_exit()
	_gain_xp(20 + 5 * floor_num, "FLOOR CLEARED")
	state = "choice"
	choice_idx = 0
	choice_t = 0.0
	var avail: Array = RULES.keys().filter(func(k): return not rules.has(k))
	pending_rule = avail[rng.randi_range(0, avail.size() - 1)] if avail.size() > 0 else ""
	get_tree().paused = true
	Sfx.play("door")
	if not exit_tip_seen:
		exit_tip_seen = true
		_save()
		_say(Story.FIRST_EXIT, "choice")


func _choose(i: int) -> void:
	if i == 0:
		var gain: int = charms.cash_out(pot * pot_mult)
		# Mags gets paid first.
		if _debt() > 0 and gain > 0:
			if charms.has("interest"):
				debt_interest = 0
			var pay := mini(gain, _debt())
			gain -= pay
			var from_p := mini(pay, debt_principal)
			debt_principal -= from_p
			debt_interest -= pay - from_p
			toasts.append({"text": "MAGS TAKES HER CUT", "sub": "-$%d   (owed $%d)" % [pay, _debt()], "t": 4.0})
			if _debt() <= 0:
				_stat_add("repaid")
				unlock("loan")
				toasts.append({"text": "LOAN PAID OFF", "sub": "Mags tips her hat.", "t": 4.0})
				if mags_node and is_instance_valid(mags_node):
					mags_node.queue_free()
				mags_node = null
		if gain > 0:
			unlock("first_bank")
			_gain_xp(10 + mini(80, gain / 40))
		banked += gain
		banner_sub = "CASHED OUT  +$%d   (rules cleared, +1 life)" % gain
		pot = 0
		pot_mult = 1
		rules = _stake_rules()
		hp = mini(hp + 1, start_hp)
		ride_streak = 0
		run_cashouts += 1
		_stat_add("cashouts_total")
		Sfx.play("bank")
		_bark("cashout")
	else:
		pot_mult *= charms.ride_factor()
		if charms.has("allin"):
			hp = maxi(1, hp - 1)
		if pending_rule != "":
			rules.append(pending_rule)
			banner_sub = "LET IT RIDE  x%d   NEW RULE: %s" % [pot_mult, RULES[pending_rule]["name"]]
		else:
			banner_sub = "LET IT RIDE  x%d" % pot_mult
		ride_streak += 1
		run_rides += 1
		run_max_mult = maxi(run_max_mult, pot_mult)
		_stat_add("rides_total")
		pstats["max_mult"] = maxi(int(pstats.get("max_mult", 1)), pot_mult)
		Sfx.play("ride")
		_bark("ride8" if pot_mult >= 8 else "ride", pot_mult >= 8)
	if banked > best:
		best = banked
		new_best = true
	if in_secret:
		in_secret = false
	floor_num += 1
	_recalc_max_hp()
	_save()
	_loading_floor(func(): _build_floor())


func _die(reason: String) -> void:
	recent_death = true
	in_secret = false
	state = "dead"
	dead_t = 0.0
	death_reason = reason
	last_cause = _cause_of(reason)
	lost_pot = pot * pot_mult
	kept_pot = int(lost_pot * (perk("insure") * 0.15 + charms.insurance()))
	if lost_pot >= 1000:
		unlock("greedy")
	banked += kept_pot
	pot = 0
	player.die()
	Sfx.play("die")
	shake(1.0)
	slowmo = 1.0
	death_quip = Story.DEATH_QUIPS[rng.randi_range(0, Story.DEATH_QUIPS.size() - 1)]
	_stat_add("deaths")
	pstats["last_cause"] = last_cause
	pstats["last_floor"] = floor_num
	pstats["last_lost"] = lost_pot
	pstats["last_mult"] = pot_mult
	pstats["last_cashed"] = run_cashouts
	pstats["last_rode"] = run_rides
	var causes: Dictionary = pstats.get("causes", {})
	causes[last_cause] = int(causes.get(last_cause, 0)) + 1
	pstats["causes"] = causes
	debt_principal = 0
	debt_interest = 0
	if mags_node and is_instance_valid(mags_node):
		mags_node.queue_free()
	mags_node = null
	_end_run()


func _end_run() -> void:
	if in_hub:
		return
	heat_bonus = 0
	if heat_run > 0 and banked > 0:
		heat_bonus = int(banked * 0.1 * heat_run)
		banked += heat_bonus
	if is_daily and daily_scored and not assisted:
		daily_best = maxi(daily_best, banked)
	_run_log()
	if banked > best:
		best = banked
		new_best = true
	wallet += banked
	lifetime += banked
	_save()


# ---------------------------------------------------------------- dialogue

func _say(lines: Array, after: String) -> void:
	for l in lines:
		dialog.append(l)
	if state != "dialog":
		dialog_after = after if after != "" else state
		state = "dialog"
		get_tree().paused = true
	dialog_chars = 0.0


func _dialog_tick(delta: float) -> void:
	if _dialog_advance(delta):
		_dialog_end()


## Types out the current line; JUMP finishes it or moves on. Returns true
## once every line has been read.
func _dialog_advance(delta: float) -> bool:
	if dialog.is_empty():
		return true
	var cur: Array = dialog[0]
	var line: String = cur[1]
	# New line: start its voice clip (or fall back to blips).
	if not is_same(dialog_spoken, cur):
		dialog_spoken = cur
		dialog_clip = Voice.speak(String(cur[0]), line)
		dialog_clip_wait = 0.0
	var cps := float(settings.val("text_speed"))
	if dialog_clip > 0.0 and cps < 9000.0:
		cps = maxf(cps, float(line.length()) / maxf(0.4, dialog_clip * 0.9))   # type in time with the voice
	var before := int(dialog_chars)
	dialog_chars += delta * cps
	if int(dialog_chars) != before:
		Voice.blip(String(cur[0]), mini(int(dialog_chars), line.length()), line)
	# Cutscene dialogue waits for the clip to finish, then moves on by itself.
	var auto_next := false
	if state == "cine" and dialog_clip > 0.0 and dialog_chars >= line.length():
		dialog_clip_wait += delta
		auto_next = not Voice.is_playing() and dialog_clip_wait > 0.6
	if _jp("jump") or _jp("confirm") or _jp("attack") or auto_next:
		if dialog_chars < line.length():
			dialog_chars = line.length()
		else:
			Voice.stop()
			dialog.pop_front()
			dialog_chars = 0.0
			dialog_spoken = []
			if settings.val("blips") and dialog_clip <= 0.0:
				Sfx.play("blip", 1.4)
			return dialog.is_empty()
	return false


func _dialog_end() -> void:
	state = dialog_after
	get_tree().paused = state != "play"
	if pending_menu != "" and state == "play":
		var m := pending_menu
		pending_menu = ""
		_open_menu(m)


# ---------------------------------------------------------------- loop

func _process(delta: float) -> void:
	if _jp("debug1"):
		debug_overlay = not debug_overlay
	if _jp("debug2") and state == "play" and not in_hub:
		pot += 500
		var dbg: Array = charms.roll(rng, 1)
		if dbg.size() > 0:
			_offer_charm(dbg[0])
		toasts.append({"text": "DEBUG", "sub": "+$500 and a random charm", "t": 3.0})
	match state:
		"settings":
			if settings.rebinding == "":
				for a in ["left", "right", "up", "down", "confirm", "back"]:
					var pressed := false
					match a:
						"confirm":
							pressed = _jp("jump") or _jp("confirm")
						"back":
							pressed = _jp("pause")
						_:
							pressed = _jp(a)
					if pressed:
						_settings_result(settings.press(a))
						break
		"menu":
			Music.intensity = 0.0
			for a in ["left", "right", "up", "down", "confirm", "back"]:
				var pressed := false
				match a:
					"confirm":
						pressed = _jp("jump") or _jp("confirm")
					"back":
						pressed = _jp("pause") or _jp("dash")
					_:
						pressed = _jp(a)
				if pressed:
					_menu_result(menu.press(a))
					if state != "menu":
						break
		"title":
			Music.intensity = 0.0
			var n := title_items().size()
			if _jp("up"):
				title_sel = (title_sel + n - 1) % n
				Sfx.play("tick")
			if _jp("down"):
				title_sel = (title_sel + 1) % n
				Sfx.play("tick")
			if _jp("left"):
				char_i = (char_i + CHARACTERS.size() - 1) % CHARACTERS.size()
				Sfx.play("tick")
			if _jp("right"):
				char_i = (char_i + 1) % CHARACTERS.size()
				Sfx.play("tick")
			if _jp("jump") or _jp("confirm"):
				match title_sel:
					0:
						if char_unlocked(char_i):
							_loading("lobby", "HOME SWEET HOVEL", "Apartment 4B. Rent is overdue.", func(): _enter_lobby(false))
						else:
							Sfx.play("deny")
					1:
						state = "skills"
						skill_msg = ""
						Sfx.play("door")
					2:
						state = "trophies"
						Sfx.play("door")
					3:
						_open_settings()
					4:
						get_tree().quit()
		"loading":
			_loading_tick(delta)
		"wipe":
			_wipe_tick(delta)
		"skills":
			_skills_tick()
		"map":
			Music.intensity = 0.0
			if _jp("map") or _jp("pause") or _jp("dash"):
				state = "play"
				get_tree().paused = false
				Sfx.play("tick", 0.8)
			elif (_jp("jump") or _jp("confirm")) and player and is_instance_valid(player):
				# Drop or remove a marker at your position.
				var near := -1
				for i in map_markers.size():
					if (map_markers[i] as Vector2).distance_to(player.global_position) < 40.0:
						near = i
				if near >= 0:
					map_markers.remove_at(near)
				else:
					map_markers.append(player.global_position)
				Sfx.play("tick", 1.5)
		"trophies":
			if _jp("pause") or _jp("dash") or _jp("jump") or _jp("confirm"):
				_back_from_menu_screen()
		"pause":
			_pause_tick()
		"dialog":
			_dialog_tick(delta)
		"cine":
			Music.intensity = 0.0
			_cine_tick(delta)
		"casino":
			Music.intensity = 0.0
			for a in ["left", "right", "up", "confirm", "back"]:
				var pressed := false
				match a:
					"confirm":
						pressed = _jp("jump") or _jp("confirm")
					"back":
						pressed = _jp("down") or _jp("pause")
					_:
						pressed = _jp(a)
				if pressed:
					var before := pot
					var was_bet: bool = casino.step == "bet"
					pot = maxi(0, pot + casino.press(a, pot))
					if pot < before:
						stats["casino"] = stats.get("casino", 0) + 1
						if was_bet and casino.game == "slots" and casino.step == "spin" and charms.free_spin:
							charms.free_spin = false
							pot = before
							casino.msg = "FREE SPIN  (Weighted Reels)"
							casino.msg_col = Color(0.6, 0.95, 1.0)
			var gain: int = casino.update(delta) + casino.take_pending()
			if casino.achievement != "":
				if casino.achievement == "jackpot":
					_stat_add("jackpots")
					_bark("jackpot", true)
				unlock(casino.achievement)
				casino.achievement = ""
			if casino.charm_tier != "":
				var won: Array = charms.roll(rng, 1, casino.charm_tier)
				if casino.slot_bad:
					var badc := charms.roll_bad(rng)
					won = [badc] if badc != "" else []
					casino.slot_bad = false
				casino.charm_tier = ""
				if won.size() > 0:
					charm_queue.append({"charm": won[0]})
			if casino.bought != "":
				_apply_drink(casino.bought)
				casino.bought = ""
			if gain > 0:
				pot += gain
				_gain_xp(5 + mini(40, gain / 50))
				_stat_add("casino_wins")
				if casino.big_win:
					shake(0.6)
					unlock("bigwin")
			if casino.done:
				state = "play"
				get_tree().paused = false
		"play":
			if _jp("pause"):
				state = "pause"
				pause_sel = 0
				get_tree().paused = true
				Sfx.play("tick")
			elif _jp("restart"):
				if not in_hub:
					_end_run()
				_begin_run()
				return
			else:
				_tick_play(delta)
		"choice":
			choice_t += delta
			if _jp("left") and choice_idx != 0:
				choice_idx = 0
				Sfx.play("tick")
			if _jp("right") and choice_idx != 1:
				choice_idx = 1
				Sfx.play("tick")
			if choice_t > 0.4:
				if _jp("choose1"):
					_choose(0)
				elif _jp("choose2"):
					_choose(1)
				elif _jp("jump") or _jp("confirm"):
					_choose(choice_idx)
		"dead":
			dead_t += delta
			Music.intensity = 0.0
			_update_camera(delta)
			if dead_t > 0.6 and _jp("restart"):
				_begin_run()
			elif dead_t > 1.0 and (_jp("jump") or _jp("confirm")):
				_respawn_sequence()
			elif dead_t > 1.0 and _jp("pause"):
				state = "title"
				get_tree().paused = true
	_update_fx(delta)
	if hud:
		hud.queue_redraw()


func _skills_tick() -> void:
	var cur: Dictionary = SKILLS[skill_sel]
	var b: int = cur["branch"]
	var tr: int = cur["tier"]
	var nb := BRANCHES.size()
	if _jp("up"):
		tr = maxi(0, tr - 1)
	if _jp("down"):
		tr = mini(3, tr + 1)
	if _jp("left"):
		b = (b + nb - 1) % nb
	if _jp("right"):
		b = (b + 1) % nb
	for i in SKILLS.size():
		if SKILLS[i]["branch"] == b and SKILLS[i]["tier"] == tr and i != skill_sel:
			skill_sel = i
			Sfx.play("tick")
	if _jp("pause") or _jp("dash"):
		_back_from_menu_screen()
		return
	if _jp("attack"):
		var price := sp_price()
		if wallet < price:
			skill_msg = "A skill point costs %s banked. Cash out more often." % _fmt_money(price)
			Sfx.play("deny")
		else:
			wallet -= price
			sp_bought += 1
			skill_points += 1
			skill_msg = "The Fence slides you a SKILL POINT for %s." % _fmt_money(price)
			Sfx.play("buy")
			_save()
		return
	if _jp("jump") or _jp("confirm"):
		var sk: Dictionary = SKILLS[skill_sel]
		if has_skill(sk["id"]):
			skill_msg = "Already yours."
			Sfx.play("deny")
		elif not skill_available(sk):
			skill_msg = "Unlock the skill above it first."
			Sfx.play("deny")
		elif skill_points < int(sk["cost"]):
			skill_msg = "Not enough SKILL POINTS. Level up, or press STRIKE to buy one."
			Sfx.play("deny")
		else:
			skill_points -= int(sk["cost"])
			perks[sk["id"]] = 1
			skill_msg = "%s learned." % sk["name"]
			Sfx.play("buy")
			Sfx.play("tier", 1.2)
			if perks.size() >= SKILLS.size():
				unlock("all_skills")
			_save()


## Price of one extra skill point at The Fence; it climbs each time.
func sp_price() -> int:
	return int(round(400.0 * pow(1.5, sp_bought) / 50.0)) * 50


func _fmt_money(v: int) -> String:
	var s2 := str(absi(v))
	var out := ""
	while s2.length() > 3:
		out = "," + s2.substr(s2.length() - 3) + out
		s2 = s2.substr(0, s2.length() - 3)
	return "$" + s2 + out


# ---------------------------------------------------------------- XP and levels

func xp_need(lv: int) -> int:
	return 100 + 50 * (lv - 1)


## Earn XP. Every level gives a SKILL POINT (two on every fifth level).
func _gain_xp(n: int, label := "") -> void:
	if n <= 0:
		return
	xp += n
	last_xp_gain = n
	xp_flash = 1.2
	if label != "" and fx and player and is_instance_valid(player):
		fx.text(player.global_position + Vector2(0, -34), "%s  +%d XP" % [label, n], Color(0.55, 1, 0.65), 9)
	var levelled := false
	while xp >= xp_need(level_num):
		xp -= xp_need(level_num)
		level_num += 1
		var gained := 2 if level_num % 5 == 0 else 1
		skill_points += gained
		levelled = true
		toasts.append({"text": "LEVEL UP!  LEVEL %d" % level_num, "sub": "+%d SKILL POINT%s. Spend at The Fence." % [gained, "S" if gained > 1 else ""], "t": 4.5})
	if levelled:
		Sfx.play("tier", 1.35)
		Sfx.play("buy")
		if state == "play":
			_callout("LEVEL UP!", Color(0.5, 1, 0.6))
		if level_num >= 10:
			unlock("level10")
		_save()


func _pause_tick() -> void:
	var n := pause_items().size()
	if _jp("up"):
		pause_sel = (pause_sel + n - 1) % n
		Sfx.play("tick")
	if _jp("down"):
		pause_sel = (pause_sel + 1) % n
		Sfx.play("tick")
	if _jp("pause"):
		state = "play"
		get_tree().paused = false
		return
	if _jp("jump") or _jp("confirm"):
		match pause_sel:
			0:
				state = "play"
				get_tree().paused = false
			1:
				_open_settings()
			2:
				if not in_hub:
					_end_run()
				_begin_run()
			3:
				_end_run()
				in_hub = false
				state = "title"
				get_tree().paused = true
				_build_floor()


func _apply_volume() -> void:
	_apply_settings()
	_save()


func _check_trophies() -> void:
	if pot_mult >= 8:
		unlock("ride8")
	if flow_mult() >= 5:
		unlock("flow5")
	if chain >= 30:
		unlock("chain30")
	if int(stats.get("parries", 0)) >= 10:
		unlock("parry10")
	if int(stats.get("smashed", 0)) >= 25:
		unlock("smash25")
	if banked >= 2000:
		unlock("rich")


func _update_fx(delta: float) -> void:
	trauma = maxf(0.0, trauma - delta * 2.0)
	if camera and is_instance_valid(camera):
		camera.offset = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)) * trauma * trauma * 7.0
	iris_t += delta
	hurt_flash = maxf(0.0, hurt_flash - delta * 1.6)
	slowmo = maxf(0.0, slowmo - delta * 0.8)
	callout_t = maxf(0.0, callout_t - delta)
	if state != "menu" and state != "cine":
		for tst in toasts:
			tst["t"] -= delta
		toasts = toasts.filter(func(x): return x["t"] > 0.0)
	boss_shout_t = maxf(0.0, boss_shout_t - delta)
	bars = move_toward(bars, bars_target, delta * 2.5)
	fade_in = maxf(0.0, fade_in - delta)
	xp_flash = maxf(0.0, xp_flash - delta * 0.8)
	coach_ok_t = maxf(0.0, coach_ok_t - delta)
	if state == "play":
		zone_card_t = maxf(0.0, zone_card_t - delta)
	card_t += delta
	if (state == "play" or state == "dialog") and (in_hub or (banner_t <= 0.0 and zone_card_t <= 0.0)):
		tip_t = maxf(0.0, tip_t - delta)
		bark_t = maxf(0.0, bark_t - delta)
	bark_cd = maxf(0.0, bark_cd - delta)
	var m := post.material as ShaderMaterial
	m.set_shader_parameter("iris", lerpf(0.0, 2.2, clampf(iris_t / 0.7, 0.0, 1.0)) if iris_t < 0.7 else 50.0)
	if player and is_instance_valid(player):
		m.set_shader_parameter("iris_center", to_screen(player.global_position) / Vector2(1280, 720))
	var flash_k := 0.35 if settings.val("flash") else 1.0
	var low_glow := 0.35 if hp == 1 and state == "play" and not in_hub and settings.val("hurt_vignette") else 0.0
	m.set_shader_parameter("hurt", hurt_flash * flash_k + low_glow * flash_k)
	m.set_shader_parameter("flow", flow / flow_max)
	m.set_shader_parameter("slowmo", slowmo if settings.val("slowmo_fx") else 0.0)


func _tick_play(delta: float) -> void:
	if in_hub:
		_update_camera(delta)
		Music.intensity = 0.0
		for p in popups:
			p["life"] -= delta
		popups = popups.filter(func(p): return p["life"] > 0.0)
		return
	floor_t += delta
	if _jp("map") and state == "play":
		state = "map"
		get_tree().paused = true
		Sfx.play("tick", 1.2)
		return
	_coach_tick(delta)
	dice_chip_t = maxf(0.0, dice_chip_t - delta)
	_tick_bet()
	_tick_vault()
	if charm_queue.size() > 0 and dialog.is_empty():
		var q: Dictionary = charm_queue.pop_front()
		if q.has("pick"):
			_open_pick(q["pick"], q.get("title", "CHOOSE A CHARM"))
		else:
			_offer_charm(q.get("charm", ""))
		if state != "play":
			return
	run_time += delta
	_focus_tick(delta)
	_weapon_tick(delta)
	_crowd_bark(delta)
	if wobble_t > 0.0:
		wobble_t -= delta
		if int(wobble_t * 4.0) % 2 == 0:
			trauma = maxf(trauma, 0.12)
	_check_trophies()
	_update_flow(delta)
	_update_camera(delta)
	for p in popups:
		p["life"] -= delta
	popups = popups.filter(func(p): return p["life"] > 0.0)
	banner_t = maxf(0.0, banner_t - delta)
	if last_call_left >= 0.0:
		last_call_left = maxf(0.0, last_call_left - delta)
		if last_call_left <= 0.0 and pot > 0:
			bleed_acc += maxf(1.0, pot * last_call_bleed) * delta
			var b := int(bleed_acc)
			if b > 0:
				pot = maxi(0, pot - b)
				bleed_acc -= b
	# Music intensity follows the danger.
	var target := 0.0
	if boss and is_instance_valid(boss) and boss.alive() and boss.state != "intro":
		target = 1.0
	else:
		for e in enemies:
			if is_instance_valid(e) and e.is_aggro():
				target = 0.6
				break
	Music.intensity = target
	Music.zone = level.zone if level != null and not in_hub else 6
	Music.boss_mode = target >= 1.0 and boss != null and boss.phase >= 1
	if Music.boss_mode:
		Music.boss_music = boss.def.get("music", {})
		Music.boss_phase = boss.phase
	else:
		Music.boss_music = {}


func _add_nerve(n: float) -> void:
	nerve = minf(NERVE_MAX, nerve + n * (1.5 if charms.has("overdraft") else 1.0))


## Hold FOCUS (E / L) while standing still: 0.9s later, spend Nerve to heal one life.
func _focus_tick(delta: float) -> void:
	if player == null or not is_instance_valid(player) or hp >= start_hp:
		focus_t = 0.0
		return
	var ok: bool = Input.is_action_pressed("focus") and nerve >= NERVE_COST and player.is_on_floor() \
		and absf(player.velocity.x) < 20.0 and player.invuln <= 0.0 and player.atk_t <= 0.0
	if not ok:
		focus_t = maxf(0.0, focus_t - delta * 3.0)
		return
	if focus_t <= 0.0:
		Sfx.play("charge")
	focus_t += delta
	if int(focus_t * 30.0) % 3 == 0:
		fx.burst(player.global_position + Vector2(0, -6), 1, Color(0.5, 0.9, 1.0), 40.0, 0.4, 1.5, -60.0)
	if focus_t >= 0.9:
		focus_t = 0.0
		nerve -= NERVE_COST
		hp = mini(start_hp, hp + 1)
		hurt_flash = 0.0
		Sfx.play("heal")
		fx.burst(player.global_position + Vector2(0, -6), 20, Color(0.5, 1.0, 0.9), 120.0, 0.6, 2.5, -40.0)
		fx.text(player.global_position + Vector2(0, -26), "+1 LIFE", Color(0.6, 1.0, 0.9), 11)


func weapon_ammo_of(id: String) -> int:
	return int(weapon_ammo.get(id, Weapons.info(id).get("ammo", 0)))


func give_weapon(id: String) -> void:
	var w: Dictionary = Weapons.info(id)
	if owned_weapons.has(id):
		if int(w.get("ammo", 0)) > 0:
			weapon_ammo[id] = int(w["ammo"])
			toasts.append({"text": "AMMO: " + String(w["name"]), "sub": "Refilled.", "t": 2.5})
		return
	owned_weapons.append(id)
	weapon_id = id
	weapon_ammo[id] = int(w.get("ammo", 0))
	toasts.append({"text": "WEAPON: " + String(w["name"]), "sub": String(w["desc"]), "t": 4.0})
	Sfx.play("buy")


func _weapon_tick(delta: float) -> void:
	shoot_cd = maxf(0.0, shoot_cd - delta)
	if player == null or not is_instance_valid(player) or player.state == PlayerScript.S.DEAD:
		return
	if Input.is_action_just_pressed("weapon") and owned_weapons.size() > 1:
		weapon_id = owned_weapons[(owned_weapons.find(weapon_id) + 1) % owned_weapons.size()]
		Sfx.play("tick", 1.4)
		_callout(String(Weapons.info(weapon_id)["name"]), Color(0.9, 0.95, 1.0))
	if Input.is_action_pressed("shoot") and shoot_cd <= 0.0:
		_fire_weapon()


func _fire_weapon() -> void:
	var w: Dictionary = Weapons.info(weapon_id)
	var amt := int(w["amt"])
	match String(w["cost"]):
		"pot":
			if pot < amt:
				shoot_cd = 0.3
				Sfx.play("deny")
				return
			pot -= amt
		"ammo":
			if weapon_ammo_of(weapon_id) < amt:
				shoot_cd = 0.3
				Sfx.play("deny")
				fx.text(player.global_position + Vector2(0, -22), "EMPTY", Color(1, 0.5, 0.4), 9)
				return
			weapon_ammo[weapon_id] = weapon_ammo_of(weapon_id) - amt
		"nerve":
			if nerve < amt:
				shoot_cd = 0.3
				Sfx.play("deny")
				return
			nerve -= amt
	shoot_cd = float(w["cd"])
	var up: bool = Input.is_action_pressed("up")
	var base := Vector2(player.facing, 0.0)
	if up:
		base = Vector2(player.facing * 0.5, -0.85).normalized()
	var origin: Vector2 = player.global_position + Vector2(player.facing * 7.0, -9.0)
	var arc: float = float(w.get("arc", 0.0))
	for i in int(w["shots"]):
		var ang := 0.0
		if int(w["shots"]) > 1:
			ang = lerpf(-float(w["spread"]), float(w["spread"]), float(i) / float(int(w["shots"]) - 1))
		else:
			ang = rng.randf_range(-float(w["spread"]), float(w["spread"]))
		var dir := (base + Vector2(0, arc)).normalized().rotated(ang * player.facing) if arc != 0.0 else base.rotated(ang * player.facing)
		var p = ProjScript.new()
		p.position = origin
		p.setup_weapon(w.duplicate(), level, dir * float(w["speed"]) * rng.randf_range(0.92, 1.08))
		p.material = unshaded
		world.add_child(p)
		projectiles.append(p)
	if w.has("recoil"):
		player.velocity.x -= player.facing * float(w["recoil"])
	var snd := "hit" if String(w["shape"]) in ["bullet", "coin"] else "swing"
	Sfx.play(snd, 1.5 if String(w["shape"]) == "bullet" else 1.2)
	shake(0.1 if w.has("recoil") else 0.04)
	fx.burst(origin, 4, Color(w["col"]), 90.0, 0.15, 1.8, 0.0, Vector2(player.facing, 0), 0.6)


## Weapon projectile touched something: damage, explode, ricochet.
func _weapon_proj_step(p) -> void:
	var w: Dictionary = p.wp
	var rc: Rect2 = p.rect()
	var pierce := int(w.get("pierce", 0))
	var done := false
	for e in enemies:
		if not is_instance_valid(e) or not e.alive or p.hit_set.has(e.get_instance_id()):
			continue
		if rc.intersects(e.get_rect()):
			p.hit_set[e.get_instance_id()] = true
			_weapon_damage_enemy(e, int(w["dmg"]), p.global_position.x, w)
			if p.hit_set.size() > pierce:
				done = true
				break
	if not done and boss and is_instance_valid(boss) and boss.alive() and not p.hit_set.has(-1) and rc.intersects(boss.get_rect()):
		p.hit_set[-1] = true
		var dealt: int = boss.hurt(int(w["dmg"]))
		if dealt > 0:
			_boss_hit_fx(dealt, p.global_position)
		done = p.hit_set.size() > pierce
	if not done:
		for pr in props:
			if is_instance_valid(pr) and not pr.broken and rc.intersects(pr.rect()):
				_break_prop(pr)
				done = not w.get("boomerang", false)
				break
	if (done or w.get("hit_wall", false)) and w.has("explode"):
		_weapon_explode(p.global_position, w)
	if done or w.get("hit_wall", false):
		fx.burst(p.global_position, 6, Color(w["col"]), 100.0, 0.25, 2.0, 100.0)
		p.die()


func _weapon_damage_enemy(e, dmg: int, from_x: float, w: Dictionary) -> void:
	if e.hurt(dmg, from_x):
		_enemy_killed(e)
		if rng.randf() < 0.35:
			var ammo_ids := ["card_throw", "dice_bomb", "bottle_toss", "snub", "shotgun"]
			for oid in owned_weapons:
				if ammo_ids.has(oid) and rng.randf() < 0.5:
					weapon_ammo[oid] = mini(int(Weapons.info(oid)["ammo"]), weapon_ammo_of(oid) + int(Weapons.info(oid)["ammo"] * 0.2) + 1)
					fx.text(e.global_position + Vector2(0, -22), "+AMMO", Color(0.8, 0.9, 1.0), 8)
					break
	elif w.has("stun") and e.has_method("stun"):
		e.stun(float(w["stun"]), from_x)
	fx.text(e.global_position + Vector2(0, -16), "-%d" % dmg, Color(1, 0.9, 0.5), 9)
	_add_nerve(6.0)
	Sfx.play("hit", 1.2)
	hitstop(0.03)


func _weapon_explode(at: Vector2, w: Dictionary) -> void:
	var r := float(w["explode"])
	fx.burst(at, 18, Color(1.0, 0.8, 0.4), 160.0, 0.4, 3.0, 60.0)
	fx.burst(at, 10, Color(w["col"]), 120.0, 0.5, 2.5, 120.0)
	Sfx.play("slam", 1.4)
	shake(0.25)
	for e in enemies:
		if is_instance_valid(e) and e.alive and e.global_position.distance_to(at) < r + 6.0:
			_weapon_damage_enemy(e, int(w["dmg"]), at.x, w)
	if boss and is_instance_valid(boss) and boss.alive() and boss.global_position.distance_to(at) < r + 20.0:
		var dealt: int = boss.hurt(int(w["dmg"]))
		if dealt > 0:
			_boss_hit_fx(dealt, at)


func _physics_process(delta: float) -> void:
	if state != "play" or get_tree().paused or player == null:
		return
	_check_world(delta)


# ---------------------------------------------------------------- combat & world

func _try_parry(src: Vector2) -> bool:
	if player.parry_t <= 0.0:
		return false
	player.parried()
	stats["parries"] = stats.get("parries", 0) + 1
	if coach_i == 6:
		_coach_next()
	hitstop(0.12)
	shake(0.35)
	slowmo = 0.6
	Sfx.play("parry")
	var mid: Vector2 = (player.global_position + src) * 0.5
	fx.burst(mid, 18, Color(0.8, 0.95, 1.0), 170.0, 0.4, 2.5, 0.0)
	fx.burst(mid, 8, Color(1, 0.9, 0.5), 90.0, 0.3, 2.0, 0.0)
	_callout("PARRY!", Color(0.6, 0.95, 1.0))
	_on_move("PARRY")
	return true


func _check_world(delta: float) -> void:
	if in_hub:
		_hub_world()
		return
	var pr: Rect2 = player.get_rect()
	var pc := pr.get_center()
	var ps: int = player.state
	level.reveal(player.global_position)

	# Losing Ticket.
	if ticket_node and is_instance_valid(ticket_node) and pr.grow(5.0).has_point(ticket_node.position):
		_collect_ticket()

	# Chips (magnet).
	var mag := (26.0 + perk("magnet") * 14.0) * charms.magnet_mult()
	for i in range(chips.size() - 1, -1, -1):
		var c = chips[i]
		if not is_instance_valid(c):
			chips.remove_at(i)
			continue
		if not c.collectible():
			continue
		var d: float = (c.position as Vector2).distance_to(pc)
		if d < mag:
			c.loose = false
			c.position = (c.position as Vector2).move_toward(pc, (110.0 + (mag - d) * 14.0) * delta)
		if d < 9.0:
			_collect(c)
			chips.remove_at(i)

	# Crumbling floors.
	if player.is_on_floor():
		for fxp in [pr.position.x + 1.0, pr.end.x - 1.0]:
			level.touch_crumble(Vector2i(floori(fxp / 16.0), floori((pr.end.y + 2.0) / 16.0)))

	# Spikes.
	if player.velocity.y >= 0.0 and (level.spike_at(Vector2(pr.position.x + 1.0, pr.end.y - 1.0)) or level.spike_at(Vector2(pr.end.x - 1.0, pr.end.y - 1.0))):
		_hurt(player.global_position.x - player.facing, "Impaled on house spikes")
		if state != "play":
			return

	_resolve_strike()

	# Enemies.
	for e in enemies:
		if not is_instance_valid(e) or not e.alive:
			continue
		var pk: Rect2 = e.punch_rect()
		if pk.has_area() and pr.intersects(pk):
			if _try_parry(e.global_position):
				e.stun(1.5, player.global_position.x)
				continue
			_hurt(e.global_position.x, "Knocked out by a bouncer")
			if state != "play":
				return
			continue
		var er: Rect2 = e.get_rect()
		if not pr.intersects(er):
			continue
		if ps == PlayerScript.S.SLIDE and e.kind != 3:
			e.hurt(99, player.global_position.x)
			_enemy_killed(e)
			_on_move("SLIDE KICK")
			Sfx.play("kick")
			if charms.has("sliderule"):
				_bonus(e.global_position, 10)
		elif player.velocity.y > 0.0 and pr.end.y - er.position.y <= 6.0 + player.velocity.y * delta * 2.0:
			if e.kind == 3 and not e.hurt(2, player.global_position.x):
				player.bounce()
				_on_move("STOMP")
				Sfx.play("stomp")
				continue
			e.hurt(99, player.global_position.x)
			_enemy_killed(e)
			player.bounce()
			_on_move("STOMP")
			Sfx.play("stomp")
			hitstop(0.045)
			if charms.has("pickpocket"):
				_bonus(e.global_position, 10)
			if charms.has("snake") and rng.randi_range(1, 6) == 6:
				_roll_die()
		elif e.is_dangerous():
			if _try_parry(e.global_position):
				if e.kind == 1:
					e.hurt(99, player.global_position.x)
					_enemy_killed(e)
				else:
					e.stun(1.2, player.global_position.x)
				continue
			_hurt(e.global_position.x, "Escorted out by security" if e.kind == 0 else ("Bitten by a pit bat" if e.kind == 1 else "Rolled by " + EnemyTypes.name_of(e.kind).to_lower()))
			if state != "play":
				return
	enemies = enemies.filter(func(e): return is_instance_valid(e))

	# Mags, collecting on a late loan: eats enemies, bites you.
	if mags_node and is_instance_valid(mags_node):
		var mr: Rect2 = mags_node.rect()
		for e in enemies:
			if is_instance_valid(e) and e.alive and mr.intersects(e.get_rect()):
				e.kill(0.0)
				mags_node.bite = 1.0
				fx.burst(e.global_position, 14, Color(1, 0.3, 0.35), 120.0, 0.4, 2.5, 200.0)
				Sfx.play("stomp", 0.7)
		if pr.intersects(mr):
			mags_node.bite = 1.0
			_hurt(mags_node.global_position.x, "Collected by Mags")
			if state != "play":
				return

	# Boss body.
	if boss and is_instance_valid(boss) and boss.alive():
		var br: Rect2 = boss.get_rect()
		if pr.intersects(br):
			if player.velocity.y > 0.0 and pr.end.y - br.position.y <= 10.0 + player.velocity.y * delta * 2.0:
				var dealt: int = boss.hurt(2 + perk("blade"))
				player.bounce()
				if dealt > 0:
					_boss_hit_fx(dealt, Vector2(boss.global_position.x, br.position.y))
					_on_move("BOSS STOMP")
			elif boss.dangerous():
				if _try_parry(boss.global_position):
					if boss.charging():
						boss.stun(2.2)
						boss.hurt(1)
						_callout("PERFECT PARRY!", Color(1, 0.9, 0.4))
					player.velocity = Vector2(signf(player.global_position.x - boss.global_position.x) * 200.0, -180.0)
				else:
					_hurt(boss.global_position.x, "Flattened by " + boss.bname)
					if state != "play":
						return

	# Projectiles.
	for p in projectiles:
		if not is_instance_valid(p) or not p.alive:
			continue
		var prc: Rect2 = p.rect()
		if p.owner_tag == "weapon":
			_weapon_proj_step(p)
			continue
		if p.owner_tag == "boss" and pr.intersects(prc):
			if _try_parry(p.global_position):
				if p.kind != "wave" and boss and is_instance_valid(boss) and boss.alive():
					p.reflect(boss.global_position)
				elif p.kind == "card" and _nearest_enemy(p.global_position) != null:
					p.reflect(_nearest_enemy(p.global_position).global_position)
				else:
					p.die()
				continue
			_hurt(p.global_position.x, "Dealt out by " + (boss.bname if boss and is_instance_valid(boss) else "the House"))
			p.die()
			if state != "play":
				return
		elif p.owner_tag == "player" and _proj_hits_enemy(p):
			p.die()
		elif p.owner_tag == "player" and boss and is_instance_valid(boss) and boss.alive() and prc.intersects(boss.get_rect()):
			var dealt: int = boss.hurt(4 if charms.has("ricochet") else 2)
			if dealt > 0:
				_boss_hit_fx(dealt, p.global_position)
				_callout("RETURN TO SENDER", Color(0.6, 0.95, 1.0))
			p.die()
	projectiles = projectiles.filter(func(p): return is_instance_valid(p) and p.alive)

	# Props: smash on fast contact.
	var fast: bool = ps == PlayerScript.S.DASH or ps == PlayerScript.S.SLIDE or absf(player.velocity.x) > 125.0 or player.velocity.y > 220.0
	if fast:
		for p in props:
			if is_instance_valid(p) and not p.broken and pr.intersects(p.rect()):
				_break_prop(p)

	# Exit & casino games.
	interact_text = ""
	if pr.intersects(level.exit_rect()):
		interact_pos = level.exit_pos + Vector2(0, -44)
		interact_text = "LOCKED: beat the boss" if level.exit_locked else "UP: EXIT"
		if not level.exit_locked and Input.is_action_pressed("up") and player.is_on_floor():
			_reach_exit()
			return
	else:
		for gm in level.games:
			var gp: Vector2 = gm[0]
			if absf(gp.x - pc.x) < (16.0 if gm[1] == "slots" else 20.0) and absf(gp.y - pr.end.y) < 6.0:
				var k: String = gm[1]
				interact_pos = gp + Vector2(0, -34)
				if TIPS.has(k):
					_tip(k, TIPS[k][0], TIPS[k][1])
				match k:
					"bar":
						interact_text = "UP: TALK TO LUCKY"
					"vera":
						interact_text = "UP: VERA'S CHARM TABLE"
						interact_pos = gp + Vector2(0, -48)
					"tailor":
						interact_text = "UP: SILAS THE TAILOR"
					"fizz":
						interact_text = "UP: DOC FIZZ (no questions)"
					"gunny":
						interact_text = "UP: GUNNY'S ARMORY"
					"shady":
						interact_text = "UP: SHADY UPGRADE"
					"secretdoor":
						interact_text = "UP: SIT AT THE SECRET TABLE"
					"velma", "dumpster_dan", "slick_nick", "lorraine", "dunn":
						interact_text = "UP: TALK TO " + String(VoiceProfiles.P[k]["name"])
					"bets":
						interact_text = "SIDE BET PLACED" if bet_used else "UP: SIDE BETS"
					"vault":
						interact_pos = gp + Vector2(0, -42)
						match String(vault.get("state", "closed")):
							"open":
								interact_text = "CRACKED"
							"sealed":
								interact_text = "SEALED. BE FASTER."
							_:
								interact_text = "UP: CRACK THE VAULT"
					_:
						interact_text = "UP: PLAY " + String(GAME_NAMES.get(k, k.to_upper()))
				if _jp("up") and player.is_on_floor():
					match k:
						"vera":
							_open_menu("shop")
						"secretdoor":
							_enter_secret()
						"velma", "dumpster_dan", "slick_nick", "lorraine", "dunn":
							_talk_npc(k)
						"tailor", "fizz", "gunny", "shady":
							_open_menu(k)
							Voice.speak_ctx(k, voice_state())
						"bets":
							if not bet_used:
								_open_menu("bets")
						"vault":
							_try_vault()
						_:
							casino.high_limit = has_skill("highlimit")
							casino.card_sense = has_skill("cardsense")
							casino.pay_bonus = perk("hottable") * 0.1
							if k == "slots":
								var key := str(gp)
								if not machines.has(key):
									machines[key] = CasinoScript.new_machine()
								casino.machine = machines[key]
							casino.open(k, perk("luck"), floor_num)
							casino.discount = _price_mult()
							state = "casino"
							get_tree().paused = true
							Sfx.play("door")
				break


func _resolve_strike() -> void:
	var hb: Rect2 = player.attack_hitbox()
	if not hb.has_area():
		return
	var id: int = player.atk_id
	var down: bool = player.atk_kind == "down"
	var fin: bool = player.combo == 2
	var dmg := 1 + perk("blade") + run_dmg_bonus + ((1 + perk("haymaker")) if fin else 0)
	var landed := false
	for e in enemies:
		if not is_instance_valid(e) or not e.alive or int(e.get_meta("hit", -1)) == id:
			continue
		if hb.intersects(e.get_rect()):
			e.set_meta("hit", id)
			landed = true
			if e.blocking(player.global_position.x) and not fin:
				Sfx.play("clash", 0.8)
				fx.burst(e.global_position + Vector2(e.dir * 9, -2), 8, Color(0.8, 0.9, 1.0), 110.0, 0.25, 2.0, 0.0)
				fx.text(e.global_position + Vector2(0, -24), "BLOCKED", Color(0.7, 0.85, 1.0), 9)
				player.velocity.x = -player.facing * 140.0
				continue
			if e.kind == 3 and fin and e.blocking(player.global_position.x):
				e.stun(1.6, player.global_position.x)
				_callout("GUARD BREAK!", Color(1, 0.8, 0.4))
			var killed: bool = e.hurt(dmg, player.global_position.x)
			fx.burst(e.global_position, 8, Color(1, 0.95, 0.7), 120.0, 0.25, 2.0, 0.0)
			_hit_juice(e.global_position, dmg, fin, killed, player.global_position.x)
			if killed:
				_enemy_killed(e)
				_on_move("KO")
	if boss and is_instance_valid(boss) and boss.alive() and int(boss.get_meta("hit", -1)) != id and hb.intersects(boss.get_rect()):
		boss.set_meta("hit", id)
		var dealt: int = boss.hurt(dmg)
		if dealt > 0:
			landed = true
			_boss_hit_fx(dealt, hb.get_center())
	for p in projectiles:
		if is_instance_valid(p) and p.alive and p.owner_tag == "boss" and hb.intersects(p.rect()):
			if p.kind == "ball" and boss and is_instance_valid(boss):
				p.reflect(boss.global_position)
			elif p.kind == "card":
				p.die()
			else:
				continue
			Sfx.play("clash")
			fx.burst(p.global_position, 6, Color(1, 1, 1), 100.0, 0.2, 2.0, 0.0)
			landed = true
	for p in props:
		if is_instance_valid(p) and not p.broken and hb.intersects(p.rect()):
			_break_prop(p)
			landed = true
	var c0 := Vector2i(floori(hb.position.x / 16.0), floori(hb.position.y / 16.0))
	var c1 := Vector2i(floori(hb.end.x / 16.0), floori(hb.end.y / 16.0))
	for cy in range(c0.y, c1.y + 1):
		for cx in range(c0.x, c1.x + 1):
			var v: int = level.get_cell(cx, cy)
			if v == 3 or v == 4:
				level.smash(Vector2i(cx, cy))
				landed = true
	if not landed and down:
		# Pogo off spikes: a down-strike that touches a spike bounces you up.
		for cx in range(c0.x, c1.x + 1):
			if level.spike_at(Vector2(cx * 16 + 8, c1.y * 16 + 8)) or level.spike_at(Vector2(cx * 16 + 8, c0.y * 16 + 8)):
				landed = true
				fx.burst(Vector2(cx * 16 + 8, c1.y * 16 + 4), 6, Color(1, 0.9, 0.5), 120.0, 0.3, 2.0, 120.0)
				break
	if landed:
		_add_nerve(11.0 if not fin else 16.0)
		if not down and player.atk_kind == "fwd":
			player.velocity.x -= player.facing * (70.0 if not fin else 110.0)
		Sfx.play("hit", 1.0 + player.combo * 0.12)
		hitstop(0.035 if not fin else 0.06)
		shake(0.12 if not fin else 0.3)
		if down:
			player.pogo()
			_on_move("POGO")
		else:
			_on_move("FINISHER" if fin else "STRIKE")
		# Each swing only connects once per target set.
		player.atk_t = minf(player.atk_t, movement.attack_time - movement.attack_active)


## Shared "feel" for every melee hit: damage number, directional sparks, ring,
## pitched impact, stagger on the target, a bigger boom on kills and finishers.
func _hit_juice(at: Vector2, dmg: int, fin: bool, killed: bool, from_x: float) -> void:
	var dir := Vector2(signf(at.x - from_x), -0.15)
	fx.burst(at, 7 + dmg * 2, Color(1, 0.9, 0.5), 200.0, 0.3, 2.2, 160.0, dir, 0.7)
	fx.burst(at, 4, Color(1, 1, 1), 260.0, 0.14, 1.4, 0.0, dir, 0.25)
	fx.text(at + Vector2(0, -14), str(dmg), Color(1, 0.95, 0.6) if not fin else Color(1, 0.6, 0.25), 9 + dmg + (3 if fin else 0))
	if killed or fin:
		fx.burst(at, 16, Color(1, 0.55, 0.25), 220.0, 0.5, 3.0, 220.0)
		Sfx.play("stomp", 0.9 if killed else 1.1)
		hitstop(0.08 if killed else 0.06)
		shake(0.32)


func _boss_hit_fx(dealt: int, at: Vector2) -> void:
	if boss and randf() < 0.35:
		Sfx.grunt(String(boss.def.get("id", "the_house")), "hurt")
	fx.burst(at, 12 + dealt * 4, Color(1, 0.85, 0.4), 160.0, 0.35, 2.5, 120.0)
	fx.text(at + Vector2(0, -12), "-%d" % dealt, Color(1, 0.4, 0.3) if dealt < 3 else Color(1, 0.9, 0.3), 12)
	Sfx.play("hit", 0.8)
	shake(0.2)
	hitstop(0.05)
	_on_move("BOSS HIT")


func _enemy_killed(e) -> void:
	Sfx.grunt("enemy", "death")
	var bonus: int = (5 if e.kind == 0 else 3) * flow_mult() * (3 if e.elite else 1)
	_gain_xp(12 if e.elite else 4, "")
	if e.elite:
		_spawn_loose(e.global_position, [25, 5, 5])
		_callout("ELITE DOWN", Color(1, 0.82, 0.3))
		unlock("elite")
	_add_nerve(14.0)
	charms.kill_stack += 1
	var bkey := EnemyTypes.name_of(e.kind)
	bestiary[bkey] = int(bestiary.get(bkey, 0)) + 1
	_spawn_loose(e.global_position + Vector2(0, -6), chips_for(bonus, 6))
	stats["kills"] = stats.get("kills", 0) + 1
	fx.text(e.global_position + Vector2(0, -14), "+%d" % bonus, Color(1, 0.85, 0.4), 10)
	fx.burst(e.global_position, 12, Color(1, 0.9, 0.6), 120.0, 0.4, 2.0, 200.0)
	shake(0.25)


func _break_prop(p) -> void:
	p.broken = true
	props.erase(p)
	var at: Vector2 = (p.rect() as Rect2).get_center()
	fx.burst(at, 16, p.debris_color(), 140.0, 0.5, 2.5, 420.0, Vector2.UP, 1.4)
	Sfx.play("glass" if p.kind == "case" else ("slam" if p.kind == "safe" else "smash"))
	shake(0.15)
	stats["smashed"] = stats.get("smashed", 0) + 1
	var vals: Array = []
	match p.kind:
		"crate":
			for i in rng.randi_range(3, 5):
				vals.append(5 if rng.randf() < 0.25 else 1)
		"urn":
			for i in rng.randi_range(2, 4):
				vals.append(25 if rng.randf() < 0.15 + perk("luck") * 0.05 else 5)
		"case":
			vals = [25, 5, 5]
			if rng.randf() < 0.2 + perk("luck") * 0.08:
				vals.append(100)
		"safe":
			vals = [100, 25, 25, 25, 5, 5]
			_gain_xp(25, "STASH FOUND")
			_stat_add("stashes")
			unlock("stash")
			if rng.randf() < 0.4 + perk("luck") * 0.05:
				var won: Array = charms.roll(rng, 1)
				if won.size() > 0:
					charm_queue.append({"charm": won[0]})
	_spawn_loose(at, vals)
	Sfx.play("coins")
	_on_move("SMASH")
	p.queue_free()


func _on_broke(cell: Vector2i, kind: int) -> void:
	var at := Vector2(cell.x * 16 + 8, cell.y * 16 + 8)
	match kind:
		3:
			fx.burst(at, 9, Color(0.75, 0.95, 1.0, 0.9), 150.0, 0.55, 2.5, 500.0)
			Sfx.play("glass", randf_range(0.9, 1.15))
		4:
			fx.burst(at, 10, Color(0.45, 0.14, 0.2), 130.0, 0.6, 3.0, 500.0)
			fx.burst(at, 6, Color(0.8, 0.7, 0.6, 0.6), 50.0, 0.6, 2.0, -20.0)
			Sfx.play("crack")
			if rng.randf() < 0.3:
				_spawn_loose(at, [5 if rng.randf() < 0.3 else 1])
		5:
			fx.burst(at, 8, Color(0.6, 0.45, 0.3), 80.0, 0.6, 2.5, 500.0)
			Sfx.play("crumble")
	stats["smashed"] = stats.get("smashed", 0) + 1
	shake(0.12)


func _on_crumble(cell: Vector2i) -> void:
	fx.burst(Vector2(cell.x * 16 + 8, cell.y * 16 + 16), 5, Color(0.7, 0.55, 0.4, 0.8), 30.0, 0.6, 1.5, 200.0, Vector2.DOWN, 0.6)
	Sfx.play("creak")


func _on_boss_fire(kind: String, pos: Vector2, vel: Vector2) -> void:
	var p = ProjScript.new()
	p.position = pos
	p.setup(kind, level, vel)
	p.material = unshaded
	world.add_child(p)
	projectiles.append(p)


func _on_boss_summon(pos: Vector2) -> void:
	_spawn_enemy(pos + Vector2(0, -12), 0)
	fx.burst(pos, 16, Color(0.8, 0.4, 1.0), 120.0, 0.5, 2.5, 0.0)
	Sfx.play("door")


func _on_boss_slam(pos: Vector2) -> void:
	shake(0.6)
	Sfx.play("slam")
	fx.burst(pos, 18, Color(0.8, 0.7, 0.6, 0.8), 140.0, 0.5, 2.5, 300.0, Vector2.UP, 1.3)


const HERO_NAME := "RICO"

## Doc Fizz sells unlabeled drugs and booze. Each bottle has a hidden random effect.
const FIZZ_STOCK := [
	{"name": "GREEN VIAL", "flavor": "It glows. Mildly."}, {"name": "SUSPICIOUS PILL", "flavor": "Blue on one side."},
	{"name": "BATHTUB GIN", "flavor": "Smells like a lawsuit."}, {"name": "MYSTERY POWDER", "flavor": "Do NOT ask."},
	{"name": "CLEARISH SHOT", "flavor": "Might be water."}, {"name": "PURPLE DRANK", "flavor": "Thick. It moves."},
	{"name": "BACKROOM BOURBON", "flavor": "Aged in a boot."}, {"name": "ENERGY GUMMY", "flavor": "Chew. Regret."},
]
## id -> [good?, label]. The label is only shown AFTER you drink it.
const FIZZ_EFFECTS := {
	"heal": [true, "PATCHED UP  +1 life"], "nerve": [true, "NERVE SURGE  Nerve full"], "chips2": [true, "SEEING DOLLAR SIGNS  chips x2 for 40s"],
	"ghost": [true, "UNTOUCHABLE  invincible for 12s"], "gift": [true, "FREE BUFF  a charm falls out of the bottle"],
	"hurt": [false, "WRONG PILL  -1 life"], "numb": [false, "NUMB  Nerve drained"], "wobble": [false, "THE ROOM SPINS  screen sways for 25s"],
	"curse": [false, "UGLY SIDE EFFECT  you grow a shitty buff"], "tax": [false, "LIGHT FINGERS  you lose 20% of your Pot"],
}


func boss_intro_lines(def: Dictionary) -> Array:
	return [[String(def["name"]), String(def["line_intro"])],
		[HERO_NAME, "%s? I've lost bigger pots to dumber tables. Deal me in." % String(def["game"]).capitalize()]]


func boss_defeat_lines(def: Dictionary) -> Array:
	return [[String(def["name"]), String(def["line_defeat"])],
		[HERO_NAME, "Read 'em and weep, pal."]]


## Raise: at each phase change you may put chips on the table to multiply damage.
func _on_boss_phase_raise(p: int) -> void:
	if pot < 10:
		return
	menu.kind = "raise"
	menu.data = {"phase": p}
	_open_menu("raise")


func _on_boss_phase(p: int) -> void:
	_on_boss_phase_raise(p)
	boss_shout = String(boss.def.get("line_phase", Story.BOSS_PHASE3.get(boss.tier, "") if p >= 3 else Story.BOSS_PHASE.get(boss.tier, "")))
	boss_shout_t = 3.0
	_callout("FINAL PHASE" if p >= 3 else "PHASE 2", Color(1, 0.35, 0.35))
	if p >= 3:
		slowmo = 1.0
		_bark("boss", true)
	shake(0.5)
	Sfx.play("windup", 0.6)


func _on_boss_defeated() -> void:
	if boss:
		Sfx.grunt(String(boss.def.get("id", "the_house")), "death")
	var tier: int = boss.tier
	if raise_paid > 0:
		pot += int(raise_paid * 1.5)
		toasts.append({"text": "THE RAISE PAID OFF", "sub": "+$%d back from the table" % int(raise_paid * 1.5), "t": 3.5})
		raise_paid = 0
	stats["bosses"] = stats.get("bosses", 0) + 1
	bestiary[String(boss.bname)] = int(bestiary.get(String(boss.bname), 0)) + 1
	unlock("boss%d" % tier)
	_gain_xp(150 * tier, "BOSS DOWN")
	Sfx.play("boss_die")
	shake(1.0)
	slowmo = 1.5
	_callout("JACKPOT!", Color(1, 0.85, 0.3))
	var vals: Array = []
	for i in 14 + tier * 4:
		var r := rng.randf()
		vals.append(1000 if r < 0.03 else (500 if r < 0.1 else (100 if r < 0.25 else (25 if r < 0.5 else 5))))
	_spawn_loose(boss.global_position + Vector2(0, -10), vals)
	for e in enemies:
		if is_instance_valid(e) and e.alive:
			e.kill(0.0)
	if in_secret:
		_spawn_loose(boss.global_position + Vector2(0, -10), [1000, 500, 500, 100, 100, 100])
		_callout("SECRET BOSS DOWN", Color(1, 0.4, 0.85))
		_stat_add("secret_bosses")
	var wdrop: Array = Weapons.ids().filter(func(k): return not owned_weapons.has(k))
	if not wdrop.is_empty():
		give_weapon(wdrop[rng.randi_range(0, wdrop.size() - 1)])
	var drop := _roll_wear(1)
	if not drop.is_empty():
		_give_wear(drop[0])
	level.exit_locked = false
	level.tile_layer.queue_redraw()
	for p in projectiles:
		if is_instance_valid(p):
			p.die()
	var first := floor_num > bosses_beaten
	bosses_beaten = maxi(bosses_beaten, floor_num)
	var steps: Array = [
		{"do": "bars", "v": 1.0},
		{"do": "pan", "to": boss.global_position + Vector2(0, -20), "zoom": 2.8, "t": 1.0},
		{"do": "say", "lines": boss_defeat_lines(boss.def)},
	]
	if tier == 3:
		if heat_run >= 5:
			unlock("heat5")
		pstats["heat_wins"] = maxi(int(pstats.get("heat_wins", 0)), heat_run)
		if ending_seen and not flags.has("true_end") and _true_ending_ready():
			flags["true_end"] = true
			unlock("true_end")
			first = true
			steps.append_array([
				{"do": "card", "text": "CASHING OUT", "sub": "", "t": 2.4},
				{"do": "say", "lines": Story.TRUE_ENDING},
				{"do": "sfx", "name": "bank"},
				{"do": "card", "text": "THE FREE HOUSE", "sub": "Every Marker is paid. The tables are still open. Thanks for playing.", "t": 5.0},
			])
		if not ending_seen:
			ending_seen = true
			flags["ending"] = true
			steps.append_array([
				{"do": "card", "text": "THE VAULT OPENS", "sub": "", "t": 2.4},
				{"do": "say", "lines": Story.ENDING},
				{"do": "card", "text": "THE END?", "sub": "Jules is free. The Pit goes deeper. High Roller mode, Table Limits and Jules unlocked.", "t": 5.0},
			])
	steps.append_array([{"do": "pan", "to": "player", "zoom": cam_zoom, "t": 0.7}, {"do": "bars", "v": 0.0}])
	_save()
	var spoils: Array = charms.roll(rng, 3)
	var tm := get_tree().create_timer(2.2, true, false, true)
	tm.timeout.connect(_boss_outro.bind(steps, first or tier == 3, spoils, boss.bname, world.get_instance_id()))


func _boss_outro(steps: Array, show: bool, spoils: Array, bname: String, floor_id: int) -> void:
	if world == null or world.get_instance_id() != floor_id:
		return
	if spoils.size() > 0:
		charm_queue.append({"pick": spoils, "title": "SPOILS: " + bname})
	if state == "play" and show:
		_cinematic(steps, "play", "outro_%s" % bname)


func _hurt(from_x: float, reason: String) -> void:
	if player.invuln > 0.0 or assist_invincible:
		return
	if active_bet.get("id", "") == "nodmg" and not active_bet.get("done", false):
		_lose_bet()
	var lethal := rules.has("glass") or hp <= 1
	if lethal and charms.has("rabbit") and not charms.rabbit_used:
		# Rabbit's Foot: the Pot takes the hit instead of you.
		charms.rabbit_used = true
		var dumped := pot
		pot = 0
		flow = 0.0
		chain = 0
		last_move = ""
		shake(0.6)
		hitstop(0.1)
		hurt_flash = 0.8
		_callout("RABBIT'S FOOT!", Color(1, 0.35, 0.9))
		fx.text(player.global_position + Vector2(0, -26), "POT DUMPED  -$%d" % dumped, Color(1, 0.5, 0.8), 11)
		fx.burst(player.global_position, 20, Color(1, 0.4, 0.9), 150.0, 0.5, 2.5, 200.0)
		Sfx.play("hurt")
		player.take_hit(from_x)
		return
	if lethal and perk("revive") > 0 and not revive_used:
		# Nine Lives: survive the killing blow once per run.
		revive_used = true
		hp = 1
		flow = 0.0
		chain = 0
		shake(0.6)
		hitstop(0.12)
		hurt_flash = 0.9
		slowmo = 0.8
		_callout("NINE LIVES!", Color(1, 0.75, 0.9))
		fx.burst(player.global_position, 24, Color(1, 0.75, 0.9), 160.0, 0.6, 2.5, 120.0)
		Sfx.play("hurt")
		player.take_hit(from_x)
		return
	hp = 0 if rules.has("glass") else hp - 1
	flow = 0.0
	chain = 0
	last_move = ""
	shake(0.55)
	hitstop(0.08)
	hurt_flash = 1.0
	fx.burst(player.global_position, 14, Color(1, 0.3, 0.35), 120.0, 0.45, 2.5, 250.0)
	if hp <= 0:
		_die(reason)
	else:
		Sfx.play("hurt")
		player.take_hit(from_x)
		if pot >= 5:
			_spill(pot / 5)
		if hp == 1:
			_bark("low_hp")


func _callout(text: String, col: Color) -> void:
	callout = text
	callout_t = 1.0
	callout_col = col


## Loyalty status for this run: earned by beating each city's boss (floor 5, 10, ...).
func run_status() -> int:
	return Cities.status_for(floor_num - 1)


func _collect(c) -> void:
	var v: int = c.value
	if not c.raw:
		v = charms.chip_value(c.value, {
			"flow_mult": flow_mult(), "airborne": not player.is_on_floor(), "pot_mult": pot_mult,
			"ride_streak": ride_streak, "in_debt": _debt() > 0,
			"extra_mult": float(chip_mult) * (2.0 if dice_chip_t > 0.0 else 1.0)})
		if charms.seven_proc:
			_callout("LUCKY SEVEN!  +$%d" % v, Color(1, 0.85, 0.3))
	if not c.raw:
		v = int(round(v * (1.0 + Cities.chip_bonus(run_status()))))
	pot += v
	stats["chips"] = stats.get("chips", 0) + v
	var col: Color = c.color()
	fx.text(c.position + Vector2(0, -6), "+%d" % v, col, 9 if v < 25 else 11)
	fx.burst(c.position, 6, col, 70.0, 0.35, 2.0, 60.0)
	Sfx.play("chip_big" if c.value >= 25 else "chip", 1.0 + minf(0.5, chain * 0.03))
	if c.value >= 100:
		_callout("+$%d" % v, Color(0.85, 0.5, 1.0))
	c.queue_free()


func _on_move(move_name: String) -> void:
	if in_hub:
		return
	if (coach_i == 3 and move_name == "AIR DASH") or (coach_i == 4 and (move_name == "WALL RUN" or move_name == "WALL JUMP")) or (coach_i == 5 and move_name.begins_with("SLIDE")):
		_coach_next()
	if move_name == "WALL RUN" and charms.has("wallst"):
		_bonus(player.global_position, 3 * flow_mult())
	var g: float = flow_gains.get(move_name, 5.0)
	if move_name == last_move:
		g *= flow_repeat_penalty
	last_move = move_name
	var old_tier := flow_mult()
	flow = minf(flow_max, flow + g)
	chain += 1
	best_chain = maxi(best_chain, chain)
	stop_t = 0.0
	popups.push_front({"t": move_name, "life": 1.1})
	if popups.size() > 5:
		popups.pop_back()
	if flow_mult() > old_tier:
		Sfx.play("tier", 1.0 + flow_mult() * 0.08)
		fx.text(player.global_position + Vector2(0, -24), "FLOW x%d" % flow_mult(), Color(1, 0.85, 0.3), 11)


func _on_land(impact: float) -> void:
	if respawn_drop and in_hub:
		respawn_drop = false
		shake(0.55)
		hitstop(0.06)
		Sfx.play("slam")
		if fx and player:
			fx.burst(player.global_position + Vector2(0, 10), 22, Color(0.75, 0.65, 0.6), 110.0, 0.7, 2.6, 90.0, Vector2.UP, PI * 0.45)
			fx.burst(player.global_position + Vector2(0, 10), 10, Color(1, 0.85, 0.4), 160.0, 0.5, 1.8, 300.0, Vector2.UP, PI * 0.6)
		_callout("WELCOME BACK", Color(1, 0.6, 0.6))
		return
	if impact > 380.0:
		shake(0.15)


func _update_flow(delta: float) -> void:
	var drain_mult := (3.0 if rules.has("loiter") else 1.0) * charms.flow_drain_mult() * (0.65 if perk("flowkeep") > 0 else 1.0)
	var pstate: int = player.state
	var busy: bool = player.velocity.length() >= flow_stop_speed or pstate == PlayerScript.S.CLIMB or player.atk_t > 0.0
	if boss and is_instance_valid(boss) and boss.alive():
		busy = true
	if busy:
		stop_t = 0.0
	else:
		stop_t += delta
	if stop_t > flow_stop_grace:
		flow -= flow_stopped_drain * drain_mult * delta
		chain = 0
	else:
		flow -= flow_idle_drain * drain_mult * delta
	if flow <= 0.0:
		flow = 0.0
		chain = 0
	player.flow_ratio = flow / flow_max


func flow_mult() -> int:
	return mini(5, 1 + int(flow / flow_tier_size))


func rule_info(id: String) -> Dictionary:
	return RULES.get(id, {"name": "?", "desc": ""})


func _update_camera(delta: float) -> void:
	if camera == null or player == null or not is_instance_valid(camera):
		return
	var v: Vector2 = player.velocity
	var la := float(settings.val("lookahead"))
	var look := Vector2(clampf(v.x * 0.3, -70.0, 70.0), clampf(v.y * 0.12, -20.0, 40.0)) * la
	var target: Vector2 = player.global_position + look
	if boss and is_instance_valid(boss) and boss.alive():
		target = target.lerp(boss.global_position, 0.3)
	camera.global_position = camera.global_position.lerp(target, 1.0 - exp(-6.0 * delta))


func shake(amount: float) -> void:
	trauma = minf(1.0, trauma + amount * float(settings.val("shake")))


func hitstop(dur: float) -> void:
	if not settings.val("hitstop"):
		return
	Engine.time_scale = 0.05
	await get_tree().create_timer(dur, true, false, true).timeout
	Engine.time_scale = assist_speed


func to_screen(p: Vector2) -> Vector2:
	return get_viewport().get_canvas_transform() * p


# ---------------------------------------------------------------- save

func _load() -> void:
	var cf := ConfigFile.new()
	if cf.load(save_path) != OK:
		return
	best = int(cf.get_value("stats", "best", 0))
	wallet = int(cf.get_value("stats", "wallet", 0))
	lifetime = int(cf.get_value("stats", "lifetime", 0))
	runs = int(cf.get_value("stats", "runs", 0))
	perks = cf.get_value("stats", "perks", {})
	bestiary = cf.get_value("stats", "bestiary", {})
	intro_seen = bool(cf.get_value("story", "intro", false))
	exit_tip_seen = bool(cf.get_value("story", "exit_tip", false))
	bosses_beaten = int(cf.get_value("story", "bosses", 0))
	ending_seen = bool(cf.get_value("story", "ending", false))
	trophies = cf.get_value("stats", "trophies", {})
	music_vol = float(cf.get_value("settings", "music", 0.8))
	sfx_vol = float(cf.get_value("settings", "sfx", 0.8))
	char_i = int(cf.get_value("settings", "runner", 0))
	xp = int(cf.get_value("progress", "xp", 0))
	level_num = int(cf.get_value("progress", "level", 1))
	skill_points = int(cf.get_value("progress", "sp", 0))
	sp_bought = int(cf.get_value("progress", "sp_bought", 0))
	# Older saves bought skills with cash: grant points for those levels instead.
	if not cf.has_section_key("progress", "level") and perks.size() > 0:
		level_num = 1 + perks.size()


func _save() -> void:
	var cf := ConfigFile.new()
	cf.set_value("stats", "best", best)
	cf.set_value("stats", "wallet", wallet)
	cf.set_value("stats", "lifetime", lifetime)
	cf.set_value("stats", "runs", runs)
	cf.set_value("stats", "perks", perks)
	cf.set_value("stats", "bestiary", bestiary)
	cf.set_value("story", "intro", intro_seen)
	cf.set_value("story", "exit_tip", exit_tip_seen)
	cf.set_value("story", "bosses", bosses_beaten)
	cf.set_value("story", "ending", ending_seen)
	cf.set_value("stats", "trophies", trophies)
	cf.set_value("settings", "music", music_vol)
	cf.set_value("settings", "sfx", sfx_vol)
	cf.set_value("settings", "runner", char_i)
	cf.set_value("progress", "xp", xp)
	cf.set_value("progress", "level", level_num)
	cf.set_value("progress", "sp", skill_points)
	cf.set_value("progress", "sp_bought", sp_bought)
	if settings:
		cf.set_value("settings", "options", settings.values)
	cf.set_value("extra", "pstats", pstats)
	cf.set_value("extra", "flags", flags)
	cf.set_value("extra", "seen", seen)
	cf.set_value("extra", "tickets", tickets)
	cf.set_value("extra", "stakes", stakes_on)
	cf.set_value("extra", "licensed", charms.licensed if charms else {})
	cf.set_value("extra", "pending_loan", pending_loan)
	cf.set_value("extra", "daily_date", daily_date)
	cf.set_value("extra", "daily_best", daily_best)
	cf.set_value("extra", "daily_done", daily_done)
	cf.save(save_path)


func _apply_drink(id: String) -> void:
	unlock("drinks")
	match id:
		"shot":
			hp = mini(hp + 1, start_hp)
			_callout("+1 LIFE", RED_C)
		"flow":
			flow = flow_max
			_callout("FLOW MAXED", Color(1, 0.85, 0.3))
		"lucky":
			chip_mult = 2
			_callout("CHIPS x2 THIS FLOOR", Color(0.6, 1, 0.6))


func _proj_hits_enemy(p) -> bool:
	for e in enemies:
		if is_instance_valid(e) and e.alive and (p.rect() as Rect2).intersects(e.get_rect()):
			if e.hurt(5 if charms.has("ricochet") else 3, p.global_position.x):
				_enemy_killed(e)
				_callout("RETURN TO SENDER", Color(0.6, 0.95, 1.0))
			if charms.has("ricochet"):
				_spawn_loose(e.global_position, [5, 5])
			return true
	return false


func _nearest_enemy(from: Vector2):
	var best_e = null
	var best_d := 260.0
	for e in enemies:
		if is_instance_valid(e) and e.alive:
			var d: float = (e.global_position as Vector2).distance_to(from)
			if d < best_d:
				best_d = d
				best_e = e
	return best_e


# ================================================================ new systems
# Everything below was added for the Lobby, reactive dialogue, charms, side
# bets, Vault Doors, Mags' loans, Losing Tickets, Table Limits, the Daily
# Deal and Assist mode. See GAME_DESIGN.md for the reasoning behind each.

func _load_extra() -> void:
	var cf := ConfigFile.new()
	if cf.load(save_path) == OK:
		pstats = cf.get_value("extra", "pstats", {})
		flags = cf.get_value("extra", "flags", {})
		seen = cf.get_value("extra", "seen", {})
		tickets = cf.get_value("extra", "tickets", {})
		stakes_on = cf.get_value("extra", "stakes", {})
		charms.licensed = cf.get_value("extra", "licensed", {})
		pending_loan = bool(cf.get_value("extra", "pending_loan", false))
		daily_date = String(cf.get_value("extra", "daily_date", ""))
		daily_best = int(cf.get_value("extra", "daily_best", 0))
		daily_done = bool(cf.get_value("extra", "daily_done", false))
		var opts: Dictionary = cf.get_value("settings", "options", {})
		for k in opts:
			settings.values[k] = opts[k]
		if not opts.has("music"):
			settings.values["music"] = snappedf(music_vol, 0.1)
			settings.values["sfx"] = snappedf(sfx_vol, 0.1)
	_apply_binds()
	_apply_settings()
	if ending_seen:
		flags["ending"] = true


func _stat_add(key: String, n := 1) -> void:
	pstats[key] = int(pstats.get(key, 0)) + n


## Table Limits only apply once the board is unlocked (after the ending).
func _stake(id: String) -> bool:
	return ending_seen and stakes_on.has(id)


func heat() -> int:
	var h := 0
	for st in STAKES:
		if _stake(st["id"]):
			h += int(st["heat"])
	return h


func _stake_rules() -> Array:
	var out: Array = []
	for st in STAKES:
		if st.has("rule") and _stake(st["id"]):
			out.append(st["rule"])
	return out


func _recalc_max_hp() -> void:
	var ch: Dictionary = CHARACTERS[char_i]
	start_hp = maxi(1, (1 if run_status() >= 4 else 0) + base_hp + perk("skin") + int(ch["hp"]) + charms.max_hp_delta() - (1 if _stake("short") else 0))
	hp = mini(hp, start_hp)


func _apply_charm_effects() -> void:
	_recalc_max_hp()
	if player and is_instance_valid(player):
		player.cfg = charms.apply_cfg(run_cfg if run_cfg else movement)
		player.dash_max = 1 + perk("dash") + charms.dash_bonus()
		player.dashes = mini(player.dashes, player.dash_max)


func _debt() -> int:
	return debt_principal + debt_interest


func _price_mult_status() -> float:
	return 0.9 if run_status() >= 3 else 1.0


func _price_mult() -> float:
	return charms.price_mult() * (1.5 if _stake("comps") else 1.0) * _price_mult_status()


func _floor_kind_available(kind: String) -> bool:
	match kind:
		"bets":
			return runs >= 2
		"vault":
			return floor_num >= 2
	return true


func _hub_kind_available(kind: String) -> bool:
	match kind:
		"jules", "board":
			return ending_seen
	return true


func _true_ending_ready() -> bool:
	return tickets.size() >= Dialogue.TICKETS.size() and flags.has("vera_free") and flags.has("marlow_confessed")


func _daily_done_today() -> bool:
	return daily_date == Time.get_date_string_from_system() and daily_done


## Turn a death reason into a short key the dialogue can react to.
func _cause_of(reason: String) -> String:
	var r := reason.to_lower()
	if r.contains("spike"):
		return "spikes"
	if r.contains("mags"):
		return "mags"
	if r.contains("bat"):
		return "bat"
	if r.contains("bouncer") or r.contains("security"):
		return "guard"
	if boss and is_instance_valid(boss) and (r.contains(boss.bname.to_lower()) or r.contains("dealt out")):
		return "boss%d" % boss.tier
	if r.contains("dealt out"):
		return "card"
	return "other"


## The House talks over the PA. `force` ignores the cooldown.
func _bark(ev: String, force := false) -> void:
	if not Dialogue.BARKS.has(ev) or not settings.val("barks"):
		return
	if bark_cd > 0.0 and not force:
		return
	var arr: Array = Dialogue.BARKS[ev]
	bark_text = arr[rng.randi_range(0, arr.size() - 1)]
	bark_t = 5.0
	bark_cd = 9.0


func _dialog_ctx() -> Dictionary:
	var c: Dictionary = pstats.duplicate()
	c["runs"] = runs
	c["boss_tiers"] = mini(3, bosses_beaten / boss_every)
	c["tickets"] = tickets.size()
	c["last_cause"] = last_cause if last_cause != "" else String(pstats.get("last_cause", ""))
	return c


# ---------------------------------------------------------------- the Lobby

func _enter_lobby(woke: bool) -> void:
	in_hub = true
	Engine.time_scale = assist_speed
	slowmo = 0.0
	pot = 0
	pot_mult = 1
	rules = []
	boss = null
	run_cfg = null
	charms.reset_run()
	_recalc_max_hp()
	hp = start_hp
	cat_pet_this_visit = false
	_build_floor()
	state = "play"
	get_tree().paused = false
	_refresh_hub_new()
	if not intro_seen:
		intro_seen = true
		_save()
		_cinematic(_intro_steps(), "play", "intro")
		return
	_tip("lobby", "THE LOBBY", "Home sweet hovel. You wake up in bed after every bust. Step out the front door and walk down the block; talk to anyone with a  !  over their head. Your car (if it starts) at the far end of the block starts the climb.")
	if woke:
		var ev := "wake_" + last_cause
		if lost_pot >= 1000:
			ev = "wake_big"
		_bark(ev if Dialogue.BARKS.has(ev) else "wake", true)
	else:
		_bark("lobby", true)


func _refresh_hub_new() -> void:
	var ctx := _dialog_ctx()
	for who in ["MARLOW", "VERA", "MAGS", "LUCKY", "JULES"]:
		hub_new[who] = Dialogue.has_new(who, ctx, seen, flags)


func _hub_world() -> void:
	var pr: Rect2 = player.get_rect()
	var pc := pr.get_center()
	interact_text = ""
	if pr.intersects(level.exit_rect()):
		interact_pos = level.exit_pos + Vector2(0, -50)
		interact_text = "UP: GET IN THE CAR. DRIVE TO " + String(Cities.CITIES[0]["name"])
		if Input.is_action_pressed("up") and player.is_on_floor():
			_begin_run()
		return
	for gm in level.games:
		var gp: Vector2 = gm[0]
		if absf(gp.x - pc.x) < 18.0 and absf(gp.y - pr.end.y) < 8.0:
			var info: Array = HUB_KINDS.get(gm[1], ["?", ""])
			interact_pos = gp + Vector2(0, -52)
			interact_text = "UP: " + String(info[0])
			if gm[1] == "daily":
				interact_text = "UP: DAILY DEAL" + ("  (practice)" if _daily_done_today() else "  (one shot)")
			if _jp("up") and player.is_on_floor():
				_hub_interact(gm[1])
			break


func _hub_interact(kind: String) -> void:
	match kind:
		"phone":
			_talk("MARLOW")
		"lucky":
			_talk("LUCKY")
		"jules":
			_talk("JULES")
		"vera":
			_talk("VERA", "licenses")
		"mags":
			_talk("MAGS", "loan")
		"cat":
			_pet_cat()
		"tickets":
			_open_menu("tickets")
		"board":
			_open_menu("stakes")
		"trophies":
			state = "trophies"
			get_tree().paused = true
			Sfx.play("door")
		"fence":
			state = "skills"
			skill_msg = ""
			get_tree().paused = true
			Sfx.play("door")
		"daily":
			_start_run(true)


func _back_from_menu_screen() -> void:
	Sfx.play("tick")
	if in_hub:
		state = "play"
		get_tree().paused = false
	else:
		state = "title"


## Talk to a Lobby character. `then_menu` opens their menu afterwards.
func _talk(who: String, then_menu := "") -> void:
	var e: Dictionary = Dialogue.pick(who, _dialog_ctx(), seen, flags, rng)
	if e.is_empty() or e.get("rep", false):
		# Nothing new to say: react to the player's state with a voiced pool line.
		var vp: Dictionary = VoiceLines.pick(VoiceProfiles.id_for(who), voice_state(), rng)
		if not vp.is_empty():
			e = {"id": "vp", "rep": true, "lines": [[who, String(vp["text"])]]}
			if then_menu == "":
				e["rep"] = false
				e["id"] = "vp_" + str(rng.randi())
	if e.is_empty():
		if then_menu != "":
			_open_menu(then_menu)
		return
	if e.get("rep", false) and then_menu != "":
		_open_menu(then_menu, "%s: \"%s\"" % [who.capitalize(), String(e["lines"][0][1])])
		return
	if not e.get("rep", false):
		seen[e["id"]] = true
		for fl in e.get("flags", []):
			flags[fl] = true
		_save()
	pending_menu = then_menu
	_say(e["lines"], "")
	_refresh_hub_new()


## What the NPCs react to: clothes, money, recent death, boss kills.
## Minor NPCs on the floors: a state-aware, voiced line.
func _talk_npc(cid: String) -> void:
	var vp: Dictionary = VoiceLines.pick(cid, voice_state(), rng)
	if vp.is_empty():
		return
	_say([[String(VoiceProfiles.P[cid]["name"]), String(vp["text"])]], "")


var crowd_cd := 20.0


## Generic crowd barks (tourists, junkies, pit bosses...) for the current city.
func _crowd_bark(delta: float) -> void:
	crowd_cd -= delta
	if crowd_cd > 0.0 or not settings.val("barks"):
		return
	crowd_cd = rng.randf_range(22.0, 40.0)
	var city := Cities.city_of(floor_num)
	var types := ["tourist", "junkie", "pitboss", "drunk", "bouncer", "hustler"]
	var pool: Array = VoiceLines.registry().filter(func(e): return e["dir"] in types and (String(e["id"]).begins_with("bark_") or String(e["id"]).begins_with("city%d_" % (city + 1))))
	# Early cities skew to junkies/hustlers, later ones to pit bosses/security.
	if pool.is_empty():
		return
	var e: Dictionary = pool[rng.randi_range(0, pool.size() - 1)]
	bark_text = "%s: %s" % [e["speaker"], e["text"]]
	bark_t = 5.0
	Voice.play_entry(e, String(e["char"]))


func run_swag() -> int:
	var sw := Wardrobe.swag(worn, floor_num)
	for id in charms.equipped:
		sw += Charms.swag_of(id)
	return sw


func voice_state() -> Dictionary:
	var sw := run_swag()
	var rich := pot >= 500 or wallet >= 1500
	var broke := pot < 30 and wallet < 100
	var st := {"died": recent_death, "boss": bosses_beaten > 0 and int(stats.get("bosses", 0)) > 0, "ugly": sw <= -3, "sharp": sw >= 8, "rich": rich, "broke": broke}
	return st


func _pet_cat() -> void:
	_stat_add("cat_pets")
	unlock("pet")
	Sfx.play("tier", 1.3)
	fx.burst(player.global_position + Vector2(10, -14), 6, Color(1, 0.55, 0.75), 40.0, 0.8, 2.0, -40.0)
	if not cat_pet_this_visit:
		cat_pet_this_visit = true
		cat_bonus = 25.0
		_callout("COMP PURRS", Color(1, 0.7, 0.85))
		toasts.append({"text": "GOOD KITTY", "sub": "+25 Flow at the start of your next run", "t": 3.5})
	else:
		_callout("prrrrr", Color(1, 0.7, 0.85))
	if rng.randf() < 0.4:
		_bark("cat", true)
	_save()


# ---------------------------------------------------------------- menus

func _open_menu(kind: String, sub_override := "") -> void:
	if state != "menu":
		menu_return = state
	_build_menu(kind, sub_override, 0)
	state = "menu"
	get_tree().paused = true
	Sfx.play("door")


func _charm_item(id: String, tag := "") -> Dictionary:
	var inf: Dictionary = Charms.info(id)
	return {"id": id, "name": inf["name"], "desc": String(inf["desc"]) + (("  \"" + String(Charms.FLAVOR[id]) + "\"") if Charms.FLAVOR.has(id) else ""), "col": Charms.color(id),
		"tag": tag if tag != "" else String(inf["rarity"]).to_upper(), "tag_col": Charms.color(id),
		"icon": String(inf["tags"][0]).left(1) if inf["tags"].size() > 0 else "?"}


func _drink_fizz() -> void:
	var ids: Array = FIZZ_EFFECTS.keys()
	var eid: String = ids[rng.randi_range(0, ids.size() - 1)]
	var eff: Array = FIZZ_EFFECTS[eid]
	match eid:
		"heal": hp = mini(start_hp, hp + 1)
		"nerve": nerve = NERVE_MAX
		"chips2": dice_chip_t = 40.0
		"ghost": player.invuln = 12.0
		"gift":
			var g: Array = charms.roll(rng, 1)
			if g.size() > 0:
				charm_queue.append({"charm": g[0]})
		"hurt": hp = maxi(1, hp - 1)
		"numb": nerve = 0.0
		"wobble": wobble_t = 25.0
		"curse":
			var bc := charms.roll_bad(rng)
			if bc != "" and not charms.full():
				_give_charm(bc)
		"tax": pot = int(pot * 0.8)
	toasts.append({"text": ("LUCKY!  " if eff[0] else "OH NO.  ") + String(eff[1]), "sub": "Doc Fizz: \"Side effects may include... everything.\"", "t": 4.5})
	Sfx.play("buy" if eff[0] else "deny", 1.0)


func _wear_item(id: String) -> Dictionary:
	var inf: Dictionary = Wardrobe.info(id)
	var price := int(round(float(inf["price"]) * _price_mult()))
	var ab := " [" + String(inf["abil"]).to_upper().replace("_", " ") + "]" if inf.has("abil") else ""
	return {"id": id, "name": inf["name"], "desc": String(inf["desc"]), "tag": "$%d" % price, "price": price,
		"col": Color(inf["col"]).lightened(0.25), "tag_col": Color(inf["col2"]), "icon": "W"}


## Pick clothing the player does not wear yet. Ability gear is weighted first.
func _roll_wear(n: int) -> Array:
	var pool: Array = []
	for id in Wardrobe.ITEMS:
		if id != "thrift_sneakers" and not worn.has(id) and int(Wardrobe.ITEMS[id]["price"]) > 0:
			pool.append(id)
	var out: Array = []
	while out.size() < n and not pool.is_empty():
		out.append(pool.pop_at(rng.randi_range(0, pool.size() - 1)))
	return out


func _give_wear(id: String) -> void:
	var inf: Dictionary = Wardrobe.info(id)
	worn = Wardrobe.wear(worn, id)
	_apply_worn()
	toasts.append({"text": "WEARING: " + String(inf["name"]), "sub": String(inf["desc"]), "t": 4.0})
	if player and is_instance_valid(player):
		fx.burst(player.global_position, 16, Color(inf["col"]), 120.0, 0.6, 2.5, -30.0)


## Push worn clothing onto the player: abilities and the drawn outfit.
func _apply_worn() -> void:
	if player == null or not is_instance_valid(player):
		return
	var ab: Dictionary = Wardrobe.abilities(worn)
	player.abil = ab
	player.worn = worn
	player.charm_ids = charms.equipped
	player.outfit_floor = floor_num
	player.dash_enabled = not rules.has("grounded")


func _on_pound(pos: Vector2) -> void:
	shake(0.35)
	hitstop(0.05)
	Sfx.play("slam")
	fx.burst(pos, 14, Color(0.8, 0.7, 0.6), 140.0, 0.5, 2.4, 80.0, Vector2.UP, PI * 0.5)
	for e in enemies:
		if is_instance_valid(e) and e.alive and absf(e.global_position.x - pos.x) < 36.0 and absf(e.global_position.y - pos.y) < 24.0:
			e.hurt(2 + run_dmg_bonus, 0.0) if e.has_method("hurt") else e.kill(0.0)


func _shop_price(id: String) -> int:
	var base: int = Charms.PRICE[Charms.info(id)["rarity"]]
	return int(round(base * (1.0 + floor_num / 6.0) * _price_mult() / 5.0)) * 5


func _license_price(id: String) -> int:
	var p: int = Charms.LICENSE[Charms.info(id)["rarity"]]
	return int(p * (0.75 if flags.has("vera_free") else 1.0))


## Side bet stake for size 0 (small), 1 (big) or 2 (all in).
func _bet_stake(size := 0) -> int:
	match size:
		1: return maxi(25, int(round(pot * 0.4 / 5.0)) * 5)
		2: return pot
	return maxi(10, int(round(pot * 0.15 / 5.0)) * 5)


## Total pay multiple for a side bet: deeper floors and bigger stakes pay more.
func _bet_pay(base: float, size: int) -> float:
	var m: float = base * (1.0 + 0.06 * (floor_num - 1)) * [1.0, 1.3, 1.8][clampi(size, 0, 2)]
	if perk("sidebet") > 0:
		m *= 1.5
	return m * charms.bet_pay_mult()


func _build_menu(kind: String, sub_override: String, keep_sel: int) -> void:
	var items: Array = []
	var title := ""
	var sub := ""
	var lay := "cards"
	var data: Dictionary = menu.data if menu.kind == kind else {}
	match kind:
		"shop":
			title = "VERA'S CHARM TABLE"
			sub = "Paid from your Pot ($%d). %d / %d charm slots used." % [pot, charms.equipped.size(), charms.max_slots]
			if not data.has("stock") or int(data.get("floor", -1)) != floor_num:
				data = {"stock": charms.roll(rng, 3), "floor": floor_num, "rerolls": 0}
			for id in data["stock"]:
				var price := _shop_price(id)
				var it := _charm_item(id, "$%d" % price)
				it["price"] = price
				it["disabled"] = pot < price
				items.append(it)
			if not data.has("wear"):
				data["wear"] = _roll_wear(2)
			for wid in data["wear"]:
				var wit := _wear_item(wid)
				wit["disabled"] = pot < int(wit["price"])
				items.append(wit)
			if not data.has("arms"):
				var apool: Array = Weapons.ids().filter(func(k): return not owned_weapons.has(k) or int(Weapons.info(k).get("ammo", 0)) > 0)
				apool.shuffle()
				data["arms"] = apool.slice(0, 1)
			for aid in data["arms"]:
				var wi: Dictionary = Weapons.info(aid)
				var wprice := int(round(float(wi["price"]) * 0.8 * _price_mult())) if not owned_weapons.has(aid) else int(round(30 * _price_mult()))
				items.append({"id": "w:" + aid, "name": String(wi["name"]) + ("" if not owned_weapons.has(aid) else "  AMMO"), "desc": String(wi["desc"]), "tag": "$%d" % wprice, "price": wprice, "col": Color(wi["col"]), "icon": "G", "disabled": pot < wprice})
			var rr := int(round(20 * (1 + int(data["rerolls"])) * _price_mult()))
			items.append({"id": "reroll", "name": "REROLL", "desc": "Vera shuffles new charms onto the table.", "tag": "$%d" % rr, "price": rr, "col": Color(0.6, 0.6, 0.7), "icon": "R", "disabled": pot < rr})
		"pick":
			title = String(data.get("title", "CHOOSE A CHARM"))
			sub = "Take one. %d / %d charm slots used." % [charms.equipped.size(), charms.max_slots]
			for id in data.get("ids", []):
				items.append(_charm_item(id, "FREE"))
		"swap":
			lay = "list"
			var nid: String = data.get("new", "")
			title = "NO ROOM FOR " + String(Charms.info(nid)["name"])
			sub = "New: %s. Swap out one of yours, or keep what you have." % Charms.info(nid)["desc"]
			for id in charms.equipped:
				var it := _charm_item(id, "SWAP OUT")
				items.append(it)
			items.append({"id": "skip", "name": "KEEP WHAT I HAVE", "desc": "Leave the new charm behind.", "col": Color(0.6, 0.6, 0.7)})
		"bets":
			title = "SIDE BETS"
			var stake := _bet_stake()
			sub = "Pick a challenge for this floor, then how much of your Pot to stake on it."
			if not data.has("offers") or int(data.get("floor", -1)) != floor_num:
				var pool: Array = SIDE_BETS.duplicate()
				var offers: Array = []
				for _i in 3:
					offers.append(pool.pop_at(rng.randi_range(0, pool.size() - 1)))
				data = {"offers": offers, "floor": floor_num}
			for b in data["offers"]:
				items.append({"id": b["id"], "name": b["name"], "desc": b["desc"], "tag": "PAYS UP TO x%.1f" % _bet_pay(float(b["pay"]), 2), "col": Color(0.45, 0.9, 1.0), "icon": "$", "disabled": pot < stake, "pay": float(b["pay"])})
			items.append({"id": "none", "name": "NO BET", "desc": "Keep your chips.", "col": Color(0.6, 0.6, 0.7), "icon": "-"})
			if pot < stake:
				sub = "Your Pot's too light to bet. You need at least $%d." % stake
		"bet_stake":
			title = String(pending_bet.get("name", "SIDE BET"))
			sub = "How much of your Pot rides on it? Bigger stakes pay a bigger multiple."
			lay = "list"
			var sizes := [["SMALL STAKE", "A safe little side action."], ["BIG STAKE", "Put some real money on it."], ["ALL IN", "Your whole Pot. Win big or walk out broke."]]
			for i in 3:
				var st := _bet_stake(i)
				var pay := _bet_pay(float(pending_bet.get("pay", 2.0)), i)
				items.append({"id": "s%d" % i, "size": i, "name": "%s   $%d" % [sizes[i][0], st], "desc": sizes[i][1], "tag": "WIN $%d  (x%.1f)" % [int(st * pay), pay], "col": [Color(0.45, 0.9, 1.0), Color(1, 0.8, 0.3), Color(1, 0.4, 0.4)][i], "icon": "$", "disabled": pot < st or st <= 0})
			items.append({"id": "none", "name": "NEVER MIND", "desc": "Keep your chips.", "col": Color(0.6, 0.6, 0.7), "icon": "-"})
		"raise":
			title = "%s RAISES. YOUR MOVE." % (boss.bname if boss else "THE TABLE")
			lay = "list"
			sub = "Put chips on the table: your hits do more damage this phase. Your Pot: $%d. Win and the chips come back." % pot
			var opts := [["FOLD", "Keep your chips. No bonus.", 0.0, 1.0], ["CALL", "10% of your Pot. Damage x1.5.", 0.10, 1.5],
				["RAISE", "25% of your Pot. Damage x2.", 0.25, 2.0], ["ALL IN", "ALL of your Pot. Damage x3.", 1.0, 3.0]]
			for o in opts:
				var cost := int(pot * float(o[2]))
				items.append({"id": "r%s" % String(o[0]).to_lower().replace(" ", ""), "name": String(o[0]), "desc": String(o[1]), "tag": "-$%d" % cost if cost > 0 else "FREE",
					"col": Color(1, 0.8, 0.3) if cost > 0 else Color(0.6, 0.6, 0.7), "icon": "$", "cost": cost, "mult": float(o[3]), "pct": float(o[2])})
		"fizz":
			title = "DOC FIZZ'S PHARMACY"
			lay = "cards"
			sub = "Unlabeled. Unlicensed. Each bottle: a random good OR bad effect. Pot: $%d." % pot
			if not data.has("stock") or int(data.get("floor", -1)) != floor_num:
				var pool: Array = FIZZ_STOCK.duplicate()
				pool.shuffle()
				data = {"stock": pool.slice(0, 3), "floor": floor_num}
			for i in (data["stock"] as Array).size():
				var bt: Dictionary = data["stock"][i]
				var price := int(round(40.0 * _price_mult() * (1.0 + floor_num * 0.05)))
				items.append({"id": "f%d" % i, "name": bt["name"], "desc": bt["flavor"] + " Effect: ???", "tag": "$%d" % price, "price": price, "col": Color(0.5, 1.0, 0.4), "icon": "?", "disabled": pot < price})
		"tailor":
			title = "SILAS STITCH, TAILOR"
			sub = "Clothes grant abilities. Paid from your Pot: $%d. Wearing swag: %d (%s)." % [pot, Wardrobe.swag(worn, floor_num), Wardrobe.swag_label(Wardrobe.swag(worn, floor_num))]
			if not data.has("stock") or int(data.get("floor", -1)) != floor_num:
				data = {"stock": _roll_wear(4), "floor": floor_num}
			for wid in data["stock"]:
				var wit := _wear_item(wid)
				wit["disabled"] = pot < int(wit["price"])
				items.append(wit)
		"gunny":
			title = "GUNNY'S ARMORY"
			sub = "Weapons and ammo. Paid from your Pot: $%d." % pot
			if not data.has("stock") or int(data.get("floor", -1)) != floor_num:
				var wp: Array = Weapons.ids().filter(func(k): return not owned_weapons.has(k))
				wp.shuffle()
				var st: Array = wp.slice(0, 3)
				for oid in owned_weapons:
					if int(Weapons.info(oid).get("ammo", 0)) > 0:
						st.append(oid)
				data = {"stock": st, "floor": floor_num}
			for aid in data["stock"]:
				var wi: Dictionary = Weapons.info(aid)
				var owned := owned_weapons.has(aid)
				var wprice := int(round(float(wi["price"]) * 0.8 * _price_mult())) if not owned else int(round(30 * _price_mult()))
				items.append({"id": "w:" + aid, "name": String(wi["name"]) + ("  AMMO" if owned else ""), "desc": String(wi["desc"]), "tag": "$%d" % wprice, "price": wprice, "col": Color(wi["col"]), "icon": "G", "disabled": pot < wprice})
		"shady":
			title = "SHADY UPGRADE"
			lay = "list"
			sub = "A guy in a trench coat will 'improve' one of your buffs. Costs $%d. Luck decides: it improves, or it backfires." % int(pot * 0.15)
			for id in charms.equipped:
				var it := _charm_item(id, "x%d" % charms.count(id))
				it["disabled"] = Charms.is_bad(id) or pot < 30
				items.append(it)
			items.append({"id": "none", "name": "WALK AWAY", "desc": "Keep your hands and your chips.", "col": Color(0.6, 0.6, 0.7), "icon": "-"})
		"loan":
			title = "MAGS' LOAN DESK"
			var interest := 150 if _stake("shark") else 100
			var due := 2 if _stake("shark") else 3
			sub = "Wallet: $%d. The loan goes into your next run's Pot." % wallet
			items.append({"id": "borrow", "name": "BORROW $%d" % LOAN_PRINCIPAL, "desc": "Pay back $%d when you cash out. Due by the end of floor %d, or Mags comes for you." % [LOAN_PRINCIPAL + interest, due],
				"tag": "OWED" if pending_loan else "SIGN", "col": Color(1, 0.45, 0.5), "icon": "$", "disabled": pending_loan})
			items.append({"id": "no", "name": "NO THANKS", "desc": "Walk away with all your fingers.", "col": Color(0.6, 0.6, 0.7), "icon": "-"})
			if pending_loan:
				sub = "You already owe me, kid. Go win something."
		"licenses":
			title = "VERA'S BACK ROOM"
			lay = "list"
			sub = "Wallet: $%d. A licensed charm can drop in the Pit from now on." % wallet
			if flags.has("vera_free"):
				sub += "  (25% off. You found her Queen.)"
			for id in Charms.DEFS:
				if not Charms.is_locked_tier(id):
					continue
				var owned: bool = charms.licensed.has(id)
				var price := _license_price(id)
				var it := _charm_item(id, "LICENSED" if owned else "$%d" % price)
				it["disabled"] = owned
				it["price"] = price
				items.append(it)
		"tickets":
			title = "LOSING TICKETS  (%d / %d)" % [tickets.size(), Dialogue.TICKETS.size()]
			lay = "list"
			sub = "Torn betting slips left behind by past runners. Find more on the floors."
			var ids: Array = tickets.keys()
			ids.sort()
			for i in ids:
				var txt: String = Dialogue.TICKETS[int(i)]
				items.append({"id": str(i), "name": "TICKET #%d" % (int(i) + 1), "desc": txt.left(52) + ("..." if txt.length() > 52 else ""), "long": txt, "col": Color(0.95, 0.9, 0.75)})
		"stakes":
			title = "TABLE LIMITS"
			lay = "list"
			sub = "Heat %d. Every point of Heat adds 10%% to everything you bank." % heat()
			for st in STAKES:
				var on: bool = stakes_on.has(st["id"])
				items.append({"id": st["id"], "name": st["name"], "desc": st["desc"], "tag": ("ON" if on else "OFF") + "   +%d HEAT" % int(st["heat"]),
					"tag_col": Color(1, 0.4, 0.4) if on else Color(0.6, 0.6, 0.7), "col": Color(1, 0.35, 0.35) if on else Color(0.5, 0.45, 0.55)})
	if sub_override != "":
		sub = sub_override
	menu.open(kind, title, sub, items, lay, data)
	menu.sel = clampi(keep_sel, 0, maxi(0, items.size() - 1))


func _open_pick(ids: Array, title: String) -> void:
	if ids.is_empty():
		return
	menu.kind = "pick"
	menu.data = {"ids": ids, "title": title}
	_open_menu("pick")


func _close_menu() -> void:
	state = menu_return if menu_return != "menu" else "play"
	get_tree().paused = state != "play"


func _menu_result(res: Dictionary) -> void:
	if res.is_empty():
		return
	if res.has("back"):
		_close_menu()
		return
	var it: Dictionary = res["choose"]
	var id: String = it["id"]
	match menu.kind:
		"fizz":
			var fp: int = int(it.get("price", 0))
			if pot < fp:
				Sfx.play("deny")
				return
			pot -= fp
			var idx := int(String(id).substr(1))
			(menu.data["stock"] as Array).remove_at(idx)
			_drink_fizz()
			_build_menu("fizz", "", 0)
		"tailor":
			var tp2: int = int(it.get("price", 0))
			if pot < tp2:
				Sfx.play("deny")
				return
			pot -= tp2
			(menu.data["stock"] as Array).erase(id)
			Sfx.play("buy")
			_give_wear(id)
			_build_menu("tailor", "", menu.sel)
		"gunny":
			var gp2: int = int(it.get("price", 0))
			if pot < gp2:
				Sfx.play("deny")
				return
			pot -= gp2
			give_weapon(String(id).substr(2))
			if not owned_weapons.has(String(id).substr(2)):
				pass
			_build_menu("gunny", "", menu.sel)
		"shady":
			if id == "none":
				_close_menu()
				return
			var cost2 := int(pot * 0.15)
			pot -= cost2
			var roll := rng.randf()
			var good := roll < 0.5 + minf(0.2, flow / 400.0)
			if good:
				charms.add_stack(id)
				toasts.append({"text": "UPGRADED: %s  x%d" % [Charms.info(id)["name"], charms.count(id)], "sub": "The trench-coat guy actually delivered.", "t": 3.5})
				Sfx.play("buy", 1.3)
			else:
				var badc := charms.roll_bad(rng)
				if badc != "" and not charms.full():
					_give_charm(badc)
				elif badc != "":
					pot = maxi(0, pot - cost2)
				toasts.append({"text": "BACKFIRED!", "sub": "You got fleeced. And a shitty buff.", "t": 3.5})
				Sfx.play("deny")
			_close_menu()
		"raise":
			var cost: int = int(it.get("cost", 0))
			pot -= cost
			if boss and is_instance_valid(boss):
				boss.dmg_mult = float(it.get("mult", 1.0))
				raise_paid = cost
				if cost > 0:
					_callout("x%.1f DAMAGE" % boss.dmg_mult, Color(1, 0.8, 0.3))
					Sfx.play("coins")
			_close_menu()
		"shop":
			var price: int = it.get("price", 0)
			if pot < price:
				menu.set_msg("Vera: \"Your Pot's light, sugar.\"", Color(1, 0.5, 0.45))
				Sfx.play("deny")
				return
			if id.begins_with("w:"):
				pot -= price
				(menu.data["arms"] as Array).erase(id.substr(2))
				give_weapon(id.substr(2))
				_build_menu("shop", "", menu.sel)
				return
			if Wardrobe.ITEMS.has(id):
				pot -= price
				(menu.data["wear"] as Array).erase(id)
				Sfx.play("buy")
				_give_wear(id)
				_build_menu("shop", "", menu.sel)
				return
			pot -= price
			if id == "reroll":
				menu.data["stock"] = charms.roll(rng, 3)
				menu.data["rerolls"] = int(menu.data["rerolls"]) + 1
				Sfx.play("coins")
				_build_menu("shop", "", menu.sel)
				return
			(menu.data["stock"] as Array).erase(id)
			Sfx.play("buy")
			_close_menu()
			_offer_charm(id)
		"pick":
			_close_menu()
			_offer_charm(id)
		"swap":
			var nid: String = menu.data.get("new", "")
			_close_menu()
			if id != "skip":
				var i: int = charms.equipped.find(id)
				charms.equipped[i] = nid
				_stat_add("charms_found")
				toasts.append({"text": "CHARM SWAPPED", "sub": "%s  ->  %s" % [Charms.info(id)["name"], Charms.info(nid)["name"]], "t": 3.5})
				_apply_charm_effects()
				Sfx.play("buy")
		"bets":
			if id == "none":
				_close_menu()
			else:
				pending_bet = {"id": id, "name": it["name"], "pay": float(it["pay"])}
				_build_menu("bet_stake", "", 0)
		"bet_stake":
			_close_menu()
			if id != "none":
				var size := int(it["size"])
				var stake := _bet_stake(size)
				pot -= stake
				bet_used = true
				active_bet = {"id": pending_bet["id"], "name": pending_bet["name"], "stake": stake, "pay": _bet_pay(float(pending_bet["pay"]), size) / charms.bet_pay_mult(), "t0": floor_t,
					"k0": int(stats.get("kills", 0)), "s0": int(stats.get("smashed", 0)), "done": false}
				_callout("ALL IN ON THE SIDE!" if size == 2 else "BET PLACED", Color(0.45, 0.9, 1.0))
				Sfx.play("chip_big" if size == 2 else "coins")
		"loan":
			if id == "borrow" and not pending_loan:
				pending_loan = true
				menu.set_msg("Mags: \"Pleasure doing business. Don't make me swim after you.\"", Color(1, 0.6, 0.6))
				toasts.append({"text": "LOAN SIGNED", "sub": "+$%d in your next Pot" % LOAN_PRINCIPAL, "t": 3.5})
				Sfx.play("buy")
				_save()
				_build_menu("loan", menu.msg, 0)
				menu.set_msg("Mags: \"Pleasure doing business.\"", Color(1, 0.6, 0.6))
			else:
				_close_menu()
		"licenses":
			var price: int = it.get("price", 0)
			if wallet < price:
				menu.set_msg("Not enough in your wallet. Cash out more often.", Color(1, 0.5, 0.45))
				Sfx.play("deny")
				return
			wallet -= price
			charms.licensed[id] = true
			Sfx.play("buy")
			_save()
			var keep: int = menu.sel
			_build_menu("licenses", "", keep)
			menu.set_msg("%s can drop in the Pit now." % Charms.info(id)["name"], Color(0.6, 1, 0.6))
		"tickets":
			pass
		"stakes":
			if stakes_on.has(id):
				stakes_on.erase(id)
			else:
				stakes_on[id] = true
				_bark("stakes")
			Sfx.play("tick")
			_save()
			_build_menu("stakes", "", menu.sel)


# ---------------------------------------------------------------- charms

func _offer_charm(id: String) -> void:
	if id == "":
		return
	if charms.has(id):
		# Risk of Rain stacking: the same buff again adds a stack.
		charms.add_stack(id)
		toasts.append({"text": "STACKED: %s  x%d" % [Charms.info(id)["name"], charms.count(id)], "sub": String(Charms.info(id)["desc"]), "t": 3.5})
		Sfx.play("buy", 1.2)
		return
	if not charms.full():
		_give_charm(id)
	else:
		menu.kind = "swap"
		menu.data = {"new": id}
		_open_menu("swap")


## Named synergies: when you hold both, the game tells you (and winks).
const COMBOS := [
	[["magnet", "seven"], "MAGNETIC SEVENS", "Everything is drawn to you, and every seventh chip is a jackpot."],
	[["heater", "housemoney"], "FLAMING HOUSE", "A heater at x4+: the chips are on fire and they are not even yours."],
	[["cool", "grease"], "ICE IN THE VEINS", "You never lose your flow and nothing slows you down."],
	[["spender", "bankroll"], "BIG SPENDER, BIGGER BANK", "Sacrifice a life, collect 20% more on every cash out."],
	[["snowball", "pickpocket"], "STREET SNOWBALL", "Every kill stacks and every stomp pays."],
	[["reels", "counter"], "CARD COUNTER AT THE REELS", "Free spins and double side bets. The pit boss is sweating."],
]


func _check_combos() -> void:
	for c in COMBOS:
		var key := String(c[1])
		if combos_seen.has(key):
			continue
		var ok := true
		for id in c[0]:
			if not charms.has(id):
				ok = false
		if ok:
			combos_seen[key] = true
			toasts.append({"text": "SYNERGY: " + key, "sub": String(c[2]), "t": 5.0})
			_callout("SYNERGY!", Color(1, 0.5, 0.95))
			shake(0.3)
			Sfx.play("ride")


func _give_charm(id: String) -> void:
	charms.equipped.append(id)
	call_deferred("_check_combos")
	_stat_add("charms_found")
	var inf: Dictionary = Charms.info(id)
	toasts.append({"text": "CHARM: " + String(inf["name"]), "sub": inf["desc"], "t": 4.0})
	_apply_charm_effects()
	if charms.equipped.size() >= 5:
		unlock("charms5")
	_tip("charm", "CHARMS", "Charms last until you bust. You can hold %d; they're listed under your Pot. Press ESC to read what they do." % charms.max_slots)
	Sfx.play("buy")
	if player and is_instance_valid(player):
		fx.burst(player.global_position, 18, Charms.color(id), 120.0, 0.6, 2.5, -30.0)
	if rng.randf() < 0.3:
		_bark("charm")


# ---------------------------------------------------------------- side bets

func _tick_bet() -> void:
	if active_bet.is_empty() or active_bet.get("done", false):
		return
	match String(active_bet["id"]):
		"fast":
			if floor_t - float(active_bet["t0"]) > 60.0:
				_lose_bet()
		"flow4":
			if flow_mult() >= 4:
				_win_bet()
		"chain":
			if chain >= 20:
				_win_bet()
		"kills":
			if int(stats.get("kills", 0)) - int(active_bet["k0"]) >= 6:
				_win_bet()
		"smash":
			if int(stats.get("smashed", 0)) - int(active_bet["s0"]) >= 8:
				_win_bet()


func _resolve_bet_at_exit() -> void:
	if active_bet.is_empty() or active_bet.get("done", false):
		return
	if active_bet["id"] == "nodmg" or active_bet["id"] == "fast":
		_win_bet()
	else:
		_lose_bet()


func _win_bet() -> void:
	var payout := int(int(active_bet["stake"]) * float(active_bet["pay"]) * charms.bet_pay_mult())
	active_bet["done"] = true
	active_bet["won"] = true
	pot += payout
	_stat_add("bets_won")
	unlock("bet")
	_gain_xp(30, "SIDE BET")
	_callout("SIDE BET WON  +$%d" % payout, Color(0.45, 0.95, 1.0))
	Sfx.play("chip_big")
	_bark("bet_won")


func _lose_bet() -> void:
	active_bet["done"] = true
	active_bet["won"] = false
	_callout("SIDE BET LOST", Color(1, 0.45, 0.45))
	Sfx.play("deny")
	_bark("bet_lost")


# ---------------------------------------------------------------- Vault Doors

func _tick_vault() -> void:
	if vault.is_empty() or vault["state"] != "closed":
		return
	if floor_t > float(vault["par"]):
		vault["state"] = "sealed"
		vault["prop"].vault_state = "sealed"
		_bark("vault_miss")


func _try_vault() -> void:
	if vault.is_empty():
		return
	match String(vault["state"]):
		"closed":
			vault["state"] = "open"
			vault["prop"].vault_state = "open"
			_stat_add("vaults")
			unlock("vault")
			_gain_xp(40, "VAULT")
			_callout("VAULT CRACKED!", Color(1, 0.85, 0.3))
			shake(0.4)
			Sfx.play("boss_die", 1.6)
			var pos: Vector2 = vault["pos"] + Vector2(0, -16)
			fx.burst(pos, 26, Color(1, 0.85, 0.35), 160.0, 0.6, 2.5, 200.0)
			_spawn_loose(pos, [25, 25, 25, 5, 5, 5, 5, 5])
			charm_queue.append({"pick": charms.roll(rng, 2), "title": "VAULT DOOR"})
			_bark("vault_open", true)
		"sealed":
			Sfx.play("deny")


# ---------------------------------------------------------------- Losing Tickets

func _next_ticket() -> int:
	for i in Dialogue.TICKETS.size():
		if not tickets.has(i):
			return i
	return -1


func _collect_ticket() -> void:
	var idx := _next_ticket()
	ticket_node.queue_free()
	ticket_node = null
	if idx < 0:
		return
	tickets[idx] = true
	_gain_xp(30, "LOSING TICKET")
	var txt: String = Dialogue.TICKETS[idx]
	toasts.append({"text": "LOSING TICKET #%d" % (idx + 1), "sub": txt.left(30) + "...", "t": 4.5})
	Sfx.play("buy")
	if idx == Dialogue.QUEEN_TICKET:
		flags["queen_found"] = true
		_callout("THE QUEEN OF SPADES!", Color(1, 0.6, 0.8))
	else:
		_callout("LOSING TICKET", Color(0.95, 0.9, 0.75))
	if tickets.size() >= Dialogue.TICKETS.size():
		unlock("tickets")
	_tip("ticket", "LOSING TICKETS", "Notes left by past runners. Read them all on the corkboard in the Lobby. There's a mystery in there.")
	_bark("ticket")
	_save()


# ---------------------------------------------------------------- small helpers

## Getting hit spills part of your Pot as bouncing chips (grab them fast).
func _spill(amount: int) -> void:
	if amount <= 0:
		return
	pot -= amount
	var vals: Array = []
	var left := amount
	for d in [100, 25, 5, 1]:
		while left >= d and vals.size() < 12:
			vals.append(d)
			left -= d
	if left > 0:
		if vals.is_empty():
			vals.append(left)
		else:
			vals[0] += left
	for v in vals:
		var c = _add_chip(player.global_position + Vector2(0, -8), v)
		c.raw = true
		c.ttl = 4.0
		c.launch(level, Vector2(rng.randf_range(-170, 170), rng.randf_range(-320, -170)))
	fx.text(player.global_position + Vector2(0, -30), "-$%d SPILLED" % amount, Color(1, 0.55, 0.45), 10)
	_tip("spill", "CHIPS SPILLED", "Getting hit knocks 20% of your Pot loose. Grab the chips back before they vanish!")
	Sfx.play("coins", 0.8)
	_bark("spill")


func _bonus(pos: Vector2, v: int) -> void:
	pot += v
	fx.text(pos + Vector2(0, -24), "+$%d" % v, Color(1, 0.85, 0.4), 10)


## Snake Eyes: a random buff.
func _roll_die() -> void:
	var face := rng.randi_range(1, 6)
	var txt := ""
	match face:
		1:
			flow = flow_max
			txt = "FLOW MAXED"
		2:
			dice_chip_t = 15.0
			txt = "CHIPS x2 FOR 15s"
		3:
			player.dashes = player.dash_max
			flow = minf(flow_max, flow + 30.0)
			txt = "DASHES REFILLED"
		4:
			player.invuln = 4.0
			txt = "INVINCIBLE FOR 4s"
		5:
			_spawn_loose(player.global_position + Vector2(0, -10), [25, 25])
			txt = "$50 ON THE FLOOR"
		6:
			hp = mini(hp + 1, start_hp)
			txt = "+1 LIFE"
	_callout("SNAKE EYES: " + txt, Color(0.6, 1, 0.6))
	Sfx.play("tier", 1.4)


func _run_log() -> void:
	var path := "user://run_log.csv"
	var exists := FileAccess.file_exists(path)
	var fa := FileAccess.open(path, FileAccess.READ_WRITE if exists else FileAccess.WRITE)
	if fa == null:
		return
	if exists:
		fa.seek_end()
	else:
		fa.store_line("date,seed,daily,runner,floor,cause,banked,lost,rides,cashouts,max_mult,charms,heat,seconds,assisted")
	var row := [Time.get_datetime_string_from_system(), run_seed, is_daily, CHARACTERS[char_i]["name"], floor_num, last_cause if state == "dead" else "quit",
		banked, lost_pot if state == "dead" else 0, run_rides, run_cashouts, run_max_mult, "|".join(charms.equipped), heat_run, int(run_time), assisted]
	fa.store_line(",".join(row.map(func(x): return str(x))))
	fa.close()


# ---------------------------------------------------------------- guidance

## One-time tips the first time you run into each system.
const TIPS := {
	"slots": ["SLOT MACHINES", "Every machine has its own hidden odds, and they drift. Three of a kind on any line wins a charm."],
	"vera": ["VERA'S CHARM TABLE", "Buy charms with your Pot. Charms change how you play for the rest of the run."],
	"bets": ["SIDE BETS", "Pick a challenge for this floor. Pull it off and the stake pays out into your Pot."],
	"vault": ["VAULT DOOR", "Reach it before the timer (top left) runs out, then press UP to crack it for a free charm."],
	"bar": ["LUCKY'S BAR", "Drinks are paid from your Pot: an extra life, max Flow, or double chips for this floor."],
	"blackjack": ["BLACKJACK", "Beat the dealer to 21 using chips from your Pot. Double down for one card at twice the bet."],
	"roulette": ["ROULETTE", "Colors and halves pay x2, dozens x3, one number x36. After any win: Double or Nothing."],
	"poker": ["VIDEO POKER", "Jacks or Better: hold the cards you want, draw once. Four of a kind or better wins a charm."],
	"holdem": ["HIGH ROLLER HOLD'EM", "Ante up, see the flop, then call or fold against the dealer. Big hands pay an ante bonus."],
	"baccarat": ["BACCARAT", "Bet Player, Banker or Tie. Closest to 9 wins. Tie pays 8 to 1."],
	"hilo": ["HI-LO LADDER", "Higher or lower? Every right guess multiplies your stake. Cash out before your luck runs dry."],
}


func _tip(id: String, title: String, text: String) -> void:
	if flags.has("tip_" + id) or not settings.val("tips"):
		return
	flags["tip_" + id] = true
	tip_title = title
	tip_text = text
	tip_t = 8.0


## What the player should be doing right now (drawn top-left by the HUD).
func objective_lines() -> Array:
	var out: Array = []
	if level == null or not is_instance_valid(level):
		return out
	if in_hub:
		var any_new := false
		for v in hub_new.values():
			if v:
				any_new = true
		out.append("Walk out the front door to your car at the end of the block to start a run")
		if any_new:
			out.append("Optional: talk to anyone with a  !  over their head")
		if skill_points > 0:
			out.append("%d SKILL POINT%s to spend at The Fence" % [skill_points, "S" if skill_points > 1 else ""])
		if pending_loan:
			out.append("Loan signed: +$%d in your next Pot" % LOAN_PRINCIPAL)
		if cat_bonus > 0.0:
			out.append("Comp purred: +25 Flow next run")
		if heat() > 0:
			out.append("Table Limits: Heat %d  (+%d%% banked)" % [heat(), heat() * 10])
		return out
	if level.is_boss:
		if boss and is_instance_valid(boss) and boss.alive():
			out.append("Defeat %s to unlock the exit" % boss.bname)
		else:
			out.append("Grab the spoils and take the EXIT")
	else:
		out.append("Reach the EXIT door" + ("  (gold diamond on the map)" if exit_seen() else ""))
	if not vault.is_empty() and vault["state"] == "closed":
		out.append("Vault Door seals in %ds" % ceili(float(vault["par"]) - floor_t))
	if not active_bet.is_empty() and not active_bet.get("done", false):
		var b := ""
		for sb in SIDE_BETS:
			if sb["id"] == active_bet["id"]:
				b = sb["desc"]
		out.append("Side bet: " + b)
	if _debt() > 0:
		if mags_node and is_instance_valid(mags_node):
			out.append("MAGS IS HUNTING YOU. Cash out to pay her $%d" % _debt())
		else:
			out.append("Owe Mags $%d by the end of floor %d" % [_debt(), debt_deadline])
	return out


func exit_seen() -> bool:
	if level == null or not is_instance_valid(level):
		return false
	var ex: Vector2 = level.exit_pos / 16.0
	return level.seen[clampi(int(ex.y) - 1, 0, level.h - 1) * level.w + clampi(int(ex.x), 0, level.w - 1)] == 1


# ---------------------------------------------------------------- cinematics

## Play a cutscene. Steps are dictionaries with a "do" key:
##   bars {v}            letterbox in (1) or out (0)
##   pan {to, zoom, t}   move the camera; `to` is a Vector2 or "player",
##                       "boss", "mags", "exit" or a Lobby object kind
##   card {text, sub, t} big title card
##   say {lines}         dialogue with the usual portraits
##   wait {t}, sfx {name}, shake {v}
## ESC skips the whole cutscene.
func _cinematic(steps: Array, after := "play", id := "") -> void:
	var mode: String = settings.val("cutscenes")
	if mode == "off" or (mode == "first" and id != "" and flags.has("cine_" + id)):
		_cine_as_dialogue(steps, after)
		return
	if id != "":
		flags["cine_" + id] = true
	cine = steps.duplicate()
	cine_after = after
	# Let the camera frame characters standing on the bottom floor.
	if camera and is_instance_valid(camera) and level and is_instance_valid(level):
		camera.limit_bottom = level.h * 16 + 150
	state = "cine"
	get_tree().paused = true
	dialog.clear()
	_next_cine_step()


## Start a cutscene a moment later, once the floor has had a few frames to
## settle (bosses land, characters pose).
func _cinematic_later(steps: Array, id := "", delay := 0.35) -> void:
	var mode: String = settings.val("cutscenes")
	var will_play := not (mode == "off" or (mode == "first" and id != "" and flags.has("cine_" + id)))
	if will_play:
		bars_target = 1.0
	var floor_id := world.get_instance_id()
	var tm := get_tree().create_timer(delay if will_play else 0.05, true, false, true)
	tm.timeout.connect(func():
		# Only play if we're still on the floor that scheduled it.
		if not world or world.get_instance_id() != floor_id:
			bars_target = 0.0
		elif state == "loading" or state == "wipe":
			_cinematic_later(steps, id, 0.3)
		elif state == "play":
			_cinematic(steps, "play", id)
		else:
			bars_target = 0.0)


## Cutscenes turned off: keep the story, drop the camera work.
func _cine_as_dialogue(steps: Array, after: String) -> void:
	var lines: Array = []
	for st in steps:
		match String(st.get("do", "")):
			"say":
				lines.append_array(st.get("lines", []))
			"card":
				if String(st.get("sub", "")) != "":
					lines.append([String(st.get("text", "")), String(st["sub"])])
			"call":
				call(String(st.get("fn", "")))
	if lines.size() > 0:
		_say(lines, after if after != "" else "play")


func _cine_target(to) -> Vector2:
	if to is Vector2:
		return to
	var key := String(to)
	if key == "player" and player and is_instance_valid(player):
		return player.global_position
	if key == "boss" and boss and is_instance_valid(boss):
		return boss.global_position + Vector2(0, -24)
	if key == "boss_low" and boss and is_instance_valid(boss):
		return boss.global_position + Vector2(0, 34)
	if key == "mags" and mags_node and is_instance_valid(mags_node):
		return mags_node.global_position
	if key == "exit":
		return level.exit_pos + Vector2(0, -24)
	for gm in level.games:
		if gm[1] == key:
			return (gm[0] as Vector2) + Vector2(0, -20)
	return camera.global_position


func _next_cine_step() -> void:
	while not cine.is_empty():
		cine_step = cine.pop_front()
		cine_t = 0.0
		match String(cine_step.get("do", "")):
			"bars":
				bars_target = float(cine_step.get("v", 1.0))
			"sfx":
				Sfx.play(String(cine_step.get("name", "door")))
			"shake":
				shake(float(cine_step.get("v", 0.3)))
			"pan":
				cam_from = camera.global_position
				cam_to = _cine_target(cine_step.get("to", "player"))
				zoom_from = camera.zoom.x
				zoom_to = float(cine_step.get("zoom", zoom_from))
				return
			"card":
				card_text = String(cine_step.get("text", ""))
				card_sub = String(cine_step.get("sub", ""))
				card_dur = float(cine_step.get("t", 2.0))
				card_t = 0.0
				Sfx.play("door", 0.7)
				return
			"who":
				cast_name = String(cine_step.get("name", ""))
				cast_role = String(cine_step.get("role", ""))
				cast_line = String(cine_step.get("line", ""))
				card_dur = float(cine_step.get("t", 2.8))
				card_t = 0.0
				Sfx.play("swing", 1.3)
				return
			"say":
				dialog = (cine_step.get("lines", []) as Array).duplicate()
				dialog_chars = 0.0
				return
			"wait":
				return
			"call":
				call(String(cine_step.get("fn", "")))
	_end_cine()


func _cine_tick(delta: float) -> void:
	cine_t += delta
	if _jp("pause"):
		skip_cine()
		return
	match String(cine_step.get("do", "")):
		"pan":
			var dur := maxf(0.01, float(cine_step.get("t", 1.0)))
			var k := smoothstep(0.0, 1.0, cine_t / dur)
			camera.global_position = cam_from.lerp(cam_to, k)
			var z := lerpf(zoom_from, zoom_to, k)
			camera.zoom = Vector2(z, z)
			if cine_t >= dur:
				_next_cine_step()
		"card":
			if cine_t >= card_dur or (cine_t > 0.8 and (_jp("jump") or _jp("confirm"))):
				card_text = ""
				_next_cine_step()
		"who":
			if cine_t >= card_dur or (cine_t > 0.8 and (_jp("jump") or _jp("confirm"))):
				cast_name = ""
				_next_cine_step()
		"say":
			if _dialog_advance(delta):
				_next_cine_step()
		"wait":
			if cine_t >= float(cine_step.get("t", 1.0)):
				_next_cine_step()
		_:
			_next_cine_step()


## Skip the rest of a cutscene, still running any scripted calls.
func skip_cine() -> void:
	for st in cine:
		if st.get("do", "") == "call":
			call(String(st.get("fn", "")))
	cine.clear()
	dialog.clear()
	_end_cine()


func _end_cine() -> void:
	bars_target = 0.0
	card_text = ""
	cast_name = ""
	cine_step = {}
	if camera and is_instance_valid(camera):
		camera.zoom = Vector2(cam_zoom, cam_zoom)
		if level and is_instance_valid(level):
			camera.limit_bottom = level.h * 16
	state = cine_after
	get_tree().paused = state != "play"


func _intro_steps() -> Array:
	var I: Array = Story.INTRO
	return [
		{"do": "bars", "v": 1.0},
		{"do": "pan", "to": "exit", "zoom": 2.4, "t": 0.01},
		{"do": "card", "text": "LET IT RIDE", "sub": "", "t": 2.4},
		{"do": "card", "text": "THE PIT", "sub": "Five cities. Twenty-five floors. One degenerate gambler.", "t": 3.0},
		{"do": "pan", "to": "player", "zoom": 3.4, "t": 3.0},
		{"do": "who", "name": "RICO", "role": "THE DEGENERATE", "line": "A degenerate gambler who loves risk. Fast hands, faster mouth, a brother to bring home.", "t": 3.0},
		{"do": "say", "lines": [I[0], I[1]]},
		{"do": "sfx", "name": "door"},
		{"do": "pan", "to": "mags", "zoom": 3.8, "t": 1.3},
		{"do": "who", "name": "MAGS", "role": "THE LOAN SHARK", "line": "She lends. You pay. Pay late and she swims through the walls.", "t": 3.0},
		{"do": "say", "lines": [I[2]]},
		{"do": "sfx", "name": "windup"}, {"do": "shake", "v": 0.35},
		{"do": "pan", "to": "player", "zoom": 2.6, "t": 0.9},
		{"do": "who", "name": "THE HOUSE", "role": "OWNER OF THE PIT", "line": "Every chip, every floor, every debt. Always listening.", "t": 3.0},
		{"do": "say", "lines": [I[3], I[4], I[5]]},
		{"do": "pan", "to": "vera", "zoom": 3.6, "t": 1.2},
		{"do": "who", "name": "VERA", "role": "THE DEALER", "line": "Sells charms that bend the odds. Knows more than she says.", "t": 3.0},
		{"do": "say", "lines": [Story.CAST["VERA"]]},
		{"do": "pan", "to": "lucky", "zoom": 3.6, "t": 1.0},
		{"do": "who", "name": "LUCKY", "role": "THE BARTENDER", "line": "Pours the drinks that keep you breathing down there.", "t": 2.8},
		{"do": "say", "lines": [Story.CAST["LUCKY"]]},
		{"do": "pan", "to": "cat", "zoom": 4.0, "t": 0.9},
		{"do": "who", "name": "COMP", "role": "THE CASINO CAT", "line": "Pet him before a run. He's good luck. Probably.", "t": 2.6},
		{"do": "pan", "to": "phone", "zoom": 3.6, "t": 0.9},
		{"do": "who", "name": "MARLOW", "role": "THE FIXER", "line": "Your voice on the radio. He got you in. He's keeping you alive.", "t": 3.0},
		{"do": "say", "lines": [I[6], I[7]]},
		{"do": "pan", "to": "exit", "zoom": 3.0, "t": 1.6},
		{"do": "card", "text": "YOUR GOAL", "sub": "Go down. Grab the money. Find Jules.\nAt every door: CASH OUT to keep it, or LET IT RIDE to double it.", "t": 4.0},
		{"do": "pan", "to": "player", "zoom": 3.0, "t": 1.2},
		{"do": "card", "text": "CHAPTER ONE", "sub": "THE MARKER", "t": 2.4},
		{"do": "bars", "v": 0.0},
		{"do": "call", "fn": "_after_intro"},
	]


func _after_intro() -> void:
	_refresh_hub_new()
	_tip("lobby", "HOME", "You wake up here after every bust. Talk to anyone with a  !  over their head. The DESCEND door on the far right starts a run.")


# ---------------------------------------------------------------- settings

func _open_settings() -> void:
	settings_return = state
	settings.row = -1
	settings.msg = ""
	state = "settings"
	get_tree().paused = true
	Sfx.play("door")


func _settings_result(res: String) -> void:
	match res:
		"changed":
			_apply_settings()
		"back":
			_apply_settings()
			_save()
			state = settings_return
			get_tree().paused = state != "play"
		"reset_controls":
			settings.values["binds"] = {}
			_apply_binds()
			_save()
		"reset_all":
			settings.reset_all()
			_apply_binds()
			_apply_settings()
			_save()


## Capture the next key press while rebinding a control.
## Voice test menu (F3): pick a character, pick a line, ENTER plays it (the recorded
## file if present, otherwise the fallback blips). Shows which lines are recorded.
func voice_test_lines() -> Array:
	var cid: String = VoiceProfiles.ORDER[vt_char % VoiceProfiles.ORDER.size()]
	return VoiceLines.registry().filter(func(e): return e["char"] == cid)


func _voice_test_input(event: InputEvent) -> bool:
	if not (event is InputEventKey) or not event.pressed:
		return false
	var k: int = (event as InputEventKey).physical_keycode
	var lines := voice_test_lines()
	match k:
		KEY_F3, KEY_ESCAPE:
			voice_test_on = false
			Voice.stop()
		KEY_LEFT:
			vt_char = (vt_char - 1 + VoiceProfiles.ORDER.size()) % VoiceProfiles.ORDER.size()
			vt_line = 0
		KEY_RIGHT:
			vt_char = (vt_char + 1) % VoiceProfiles.ORDER.size()
			vt_line = 0
		KEY_UP:
			vt_line = maxi(0, vt_line - 1)
		KEY_DOWN:
			vt_line = mini(maxi(0, lines.size() - 1), vt_line + 1)
		KEY_PAGEUP:
			vt_line = maxi(0, vt_line - 10)
		KEY_PAGEDOWN:
			vt_line = mini(maxi(0, lines.size() - 1), vt_line + 10)
		KEY_ENTER, KEY_KP_ENTER:
			Voice.clear_cache()
			if vt_line < lines.size():
				var e: Dictionary = lines[vt_line]
				var len_s := Voice.play_entry(e, String(e["char"]))
				if len_s <= 0.0:
					Voice.last_char = String(e["char"])
					for i in range(1, mini(40, String(e["text"]).length()), 2):
						get_tree().create_timer(0.03 * i, true, false, true).timeout.connect(Voice.blip.bind(String(e["speaker"]), i, String(e["text"])))
		_:
			return false
	return true


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and (event as InputEventKey).physical_keycode == KEY_F3 and not voice_test_on and state != "settings":
		voice_test_on = true
		Voice.clear_cache()
		get_viewport().set_input_as_handled()
		return
	if event is InputEventKey and event.pressed and not event.echo and (event as InputEventKey).physical_keycode == KEY_F4 and state in ["play", "pause", "title"]:
		journal_on = not journal_on
		get_viewport().set_input_as_handled()
		return
	if journal_on:
		if event is InputEventKey and event.pressed:
			journal_on = false
			get_viewport().set_input_as_handled()
		return
	if voice_test_on:
		if _voice_test_input(event):
			get_viewport().set_input_as_handled()
		return
	if state != "settings" or settings == null or settings.rebinding == "":
		return
	if event is InputEventKey and event.pressed and not event.echo:
		var k: int = (event as InputEventKey).physical_keycode
		var action: String = settings.rebinding
		settings.rebinding = ""
		settings.msg = ""
		get_viewport().set_input_as_handled()
		if k == KEY_ESCAPE:
			Sfx.play("deny")
			return
		var binds: Dictionary = settings.values.get("binds", {})
		binds[action] = k
		settings.values["binds"] = binds
		_apply_binds()
		Sfx.play("buy")
		_save()


## Keyboard bindings: defaults, with any rebinds replacing an action's keys.
func _apply_binds() -> void:
	var binds: Dictionary = settings.values.get("binds", {})
	for a in DEFAULT_KEYS:
		if not InputMap.has_action(a):
			continue
		for ev in InputMap.action_get_events(a):
			if ev is InputEventKey:
				InputMap.action_erase_event(a, ev)
		var ks: Array = [binds[a]] if binds.has(a) else DEFAULT_KEYS[a]
		for k in ks:
			var ev := InputEventKey.new()
			ev.physical_keycode = int(k)
			InputMap.action_add_event(a, ev)


## Push every setting into the engine, audio and gameplay.
func _apply_settings() -> void:
	if settings == null:
		return
	var v := settings.values
	# Window and frame rate (no-ops when running headless).
	if DisplayServer.get_name() != "headless":
		match String(v["window"]):
			"fullscreen":
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			"exclusive":
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			_:
				if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_WINDOWED:
					DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				var sz: Vector2i = v["res"]
				if DisplayServer.window_get_size() != sz:
					DisplayServer.window_set_size(sz)
					var scr := DisplayServer.screen_get_usable_rect()
					DisplayServer.window_set_position(scr.position + (scr.size - sz) / 2)
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if v["vsync"] else DisplayServer.VSYNC_DISABLED)
	Engine.max_fps = int(v["fps"])
	# Post-processing.
	if post:
		var m := post.material as ShaderMaterial
		m.set_shader_parameter("bloom", float(v["bloom"]))
		m.set_shader_parameter("vignette", 1.0 if v["vignette"] else 0.0)
	# Audio.
	music_vol = float(v["music"])
	sfx_vol = float(v["sfx"])
	Music.volume = music_vol
	Sfx.volume = sfx_vol
	Voice.set_volume(float(v["voice"]))
	Voice.set_filters(bool(v["voice_filters"]))
	Voice.blips_on = bool(v["blips"])
	AudioServer.set_bus_volume_db(0, linear_to_db(maxf(0.0001, float(v["master"]))))
	AudioServer.set_bus_mute(0, float(v["master"]) <= 0.0)
	# Assist.
	assist_speed = float(v["assist_speed"])
	assist_invincible = bool(v["assist_invincible"])
	if state != "cine":
		Engine.time_scale = assist_speed
	if (assist_speed < 1.0 or assist_invincible) and not in_hub and (settings_return == "pause" or state == "play"):
		assisted = true
	_apply_world_settings()


## Settings that live on world nodes (particles, shadows, ambience, foliage).
func _apply_world_settings() -> void:
	var v := settings.values
	FXScript.particle_mult = float(v["particles"])
	LevelScript.shadow_quality = int(v["shadows"])
	if level and is_instance_valid(level):
		for c in level.get_children():
			if c is PointLight2D and c.has_meta("wants_shadow"):
				c.shadow_enabled = int(v["shadows"]) > 0
				c.shadow_filter = Light2D.SHADOW_FILTER_PCF5 if int(v["shadows"]) >= 2 else Light2D.SHADOW_FILTER_NONE
	if ambient_node and is_instance_valid(ambient_node):
		ambient_node.visible = bool(v["ambient"])
	if foliage_node and is_instance_valid(foliage_node):
		foliage_node.visible = bool(v["foliage"])


func _notification(what: int) -> void:
	if settings == null:
		return
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT and settings.val("mute_unfocused"):
		AudioServer.set_bus_mute(0, true)
	elif what == NOTIFICATION_APPLICATION_FOCUS_IN:
		AudioServer.set_bus_mute(0, float(settings.val("master")) <= 0.0)


# ---------------------------------------------------------------- loading screens

func zone_of(fl: int) -> int:
	return Cities.zone_of(fl)


## Bosses 1-4 are random per run (seeded); floor 25 and every 25th after is THE HOUSE.
var boss_order: Array = []
var raise_paid := 0


func boss_def_for(fl: int) -> Dictionary:
	if in_secret:
		return BossDefs.by_id(secret_id)
	if fl % 25 == 0:
		return BossDefs.final_def()
	if boss_order.size() < 4:
		boss_order = BossDefs.roll_order(run_seed)
	var idx := ((fl / 5) - 1) % 5
	if idx >= 4:
		idx = 3
	var def: Dictionary = BossDefs.by_id(boss_order[idx])
	if fl > 25:
		# High Roller loops: rotate through the pool deterministically.
		def = BossDefs.POOL[((fl / 5) + hash(str(run_seed))) % BossDefs.POOL.size()]
	return def


## Show an illustrated loading screen, run `fn` (which builds the next place)
## behind it, then fade into the game.
func _loading(kind: String, title: String, sub: String, fn: Callable) -> void:
	load_kind = kind
	load_title = title
	load_sub = sub
	load_fn = fn
	load_t = 0.0
	load_done = false
	load_post = "play"
	load_tip = LOAD_TIPS[randi() % LOAD_TIPS.size()]
	load_dur = 2.4 if settings.val("load_screens") == "full" else 0.9
	if kind.begins_with("drive"):
		# The road trip between cities is a proper scene, not a flash.
		load_dur = 7.5 if settings.val("load_screens") == "full" else 3.0
	dialog.clear()
	state = "loading"
	get_tree().paused = true
	Engine.time_scale = 1.0
	Sfx.play("door", 0.6)


## Loading screen for the floor `floor_num` is about to become.
func _loading_floor(fn: Callable) -> void:
	if floor_num > 1 and Cities.floor_in_city(floor_num) == 0:
		_loading_drive(Cities.city_of(floor_num), fn)
	elif is_boss_floor():
		var bd := boss_def_for(floor_num)
		var tier := int(bd["tier"])
		_loading("boss%d" % tier, String(bd["name"]) + "  -  " + String(bd["game"]), "BOSS FLOOR  -  FLOOR %d  -  %s" % [floor_num, Cities.info(floor_num)["full"]], fn)
	else:
		var z: Dictionary = ZONES[zone_of(floor_num)]
		_loading(z["paint"], z["name"], "FLOOR %d  -  %s" % [floor_num, z["sub"]], fn)


## Start a run from anywhere, through the floor 1 loading screen.
func _begin_run(daily := false) -> void:
	_loading_drive(0, func(): _start_run(daily))


## The highway road trip to city `city`: the car and the skyline get nicer each city.
func _loading_drive(city: int, fn: Callable) -> void:
	var c: Dictionary = Cities.CITIES[clampi(city, 0, Cities.CITIES.size() - 1)]
	_loading("drive%d" % clampi(city, 0, 4), "ON THE ROAD", "Next stop: " + String(c["full"]), fn)


func _loading_tick(delta: float) -> void:
	load_t += delta
	Music.intensity = 0.0
	if not load_done and load_t >= 0.3:
		load_done = true
		if load_fn.is_valid():
			load_fn.call()
		# Whatever the builder wanted next (play, a cutscene, dialogue) waits
		# until the loading screen is gone.
		load_post = state
		state = "loading"
		get_tree().paused = true
	var ready := load_done and load_t >= load_dur
	var skip_after := 2.5 if load_kind.begins_with("drive") else 0.8
	if load_done and load_t > skip_after and (_jp("jump") or _jp("confirm")):
		ready = true
	if ready:
		state = load_post
		get_tree().paused = state != "play"
		Engine.time_scale = assist_speed
		iris_t = 0.0
		fade_in = 0.45
		if state == "play" and not in_hub:
			var z := zone_of(floor_num)
			if not is_boss_floor() and (floor_num == 1 or zone_of(floor_num - 1) != z):
				zone_card = ZONES[z]["name"]
				zone_card_t = 3.2


# ---------------------------------------------------------------- respawn

## Busted: slot reels slam down and spell B-U-S-T, the House collects, and you
## drop through a trapdoor into the Lobby.
func _respawn_sequence() -> void:
	state = "wipe"
	wipe_t = 0.0
	wipe_built = false
	get_tree().paused = true
	Sfx.play("swing", 0.7)


func _wipe_tick(delta: float) -> void:
	var before := wipe_t
	wipe_t += delta
	Music.intensity = 0.0
	for i in 4:
		var stop := 0.62 + 0.2 * i
		if before < stop and wipe_t >= stop:
			Sfx.play("tick", 0.7 + i * 0.1)
			if i == 3:
				Sfx.play("slam")
				shake(0.3)
	if not wipe_built and wipe_t >= 1.3:
		wipe_built = true
		respawn_drop = true
		_enter_lobby(true)
		state = "wipe"
		get_tree().paused = true
		# Start Rico up by the ceiling, over the trapdoor.
		if player and level:
			player.position = Vector2(level.start_pos.x + 32.0, level.T * 1.0 + 14.0)
			player.velocity = Vector2.ZERO
			camera.global_position = player.global_position + Vector2(0, 60)
			level.hatch_x = player.position.x
			level.hatch_t0 = level.t
	if wipe_built and wipe_t >= 1.72:
		get_tree().paused = false
		if camera and player:
			_update_camera(delta)
	if wipe_t >= 2.3:
		state = "play"
		get_tree().paused = false


# ---------------------------------------------------------------- difficulty

## How tough security is. It grows with your level and how many skills you
## own (and Heat), so the Pit keeps pace with you. The very first floor you
## ever play is gentler while you learn the controls.
func threat() -> float:
	var th := 1.0 + minf(0.35, (level_num - 1) * 0.02 + perks.size() * 0.012) + heat_run * 0.05
	if runs <= 1 and floor_num == 1 and not is_daily and not in_hub:
		th = 0.6
	return th


# ---------------------------------------------------------------- controls coach

func _coach_tick(delta: float) -> void:
	if coach_i < 0 or coach_i >= COACH.size() or player == null:
		return
	coach_step_t += delta
	var done := false
	match coach_i:
		0: done = absf(player.global_position.x - level.start_pos.x) > 64.0
		1: done = not player.is_on_floor() and player.velocity.y < -60.0
		2: done = _jp("attack")
	# Never get stuck on a step (no wall nearby, no enemy yet...).
	if done or coach_step_t > (20.0 if coach_i >= 4 else 30.0):
		_coach_next()


func _coach_next() -> void:
	coach_i += 1
	coach_step_t = 0.0
	coach_ok_t = 0.8
	Sfx.play("tick", 1.6)
	if coach_i >= COACH.size():
		coach_i = -1
		flags["coach_done"] = true
		_callout("YOU'RE A NATURAL", Color(0.5, 1, 0.7))
		_save()
