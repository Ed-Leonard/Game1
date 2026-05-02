package main

import "bald:draw"
import "bald:input"
import "bald:sound"
import "bald:utils"
import "bald:utils/logger"
import "bald:utils/shape"

import "base:builtin"
import "base:runtime"
import "core:fmt"
import "core:log"
import "core:math"
import "core:math/linalg"
import "core:strings"
import "core:sync"
import "core:time"

import sapp "bald:sokol/app"
import sg "bald:sokol/gfx"
import sglue "bald:sokol/glue"
import slog "bald:sokol/log"

AttackBase :: struct {
	damage_mult: f32,
	speed_mult:  f32,
	knockback:   f32,
	crit_chance: f32,
	crit_mult:   f32,
}

SWORD_ATTACKS := [AttackKind]AttackBase {
	.Main = {
		damage_mult = 1.0,
		speed_mult = 1.0,
		knockback = 0.5,
		crit_chance = 0.1,
		crit_mult = 2.0,
	},
	.Secondary = {
		damage_mult = 0.5,
		speed_mult = 1.5,
		knockback = 0.2,
		crit_chance = 0.05,
		crit_mult = 1.5,
	},
	.Alt = {
		damage_mult = 1.5,
		speed_mult = 0.8,
		knockback = 1.0,
		crit_chance = 0.2,
		crit_mult = 2.5,
	},
	.Channel = {
		damage_mult = 3.0,
		speed_mult = 0.3,
		knockback = 2.0,
		crit_chance = 0.3,
		crit_mult = 3.0,
	},
}

make_sword :: proc() -> Weapon {
	return Weapon {
		item = {name = "Sword"},
		damage = 10,
		attack_speed = 0.5,
		weapon_type = MeleeWeapon{reach = 1.5, angle = 90.0},
		attack_bases = &SWORD_ATTACKS,
		mods = default_modifiers(),
	}
}

CROSSBOW_ATTACKS := [AttackKind]AttackBase {
	.Main = {
		damage_mult = 0.8,
		speed_mult = 1.2,
		knockback = 0.1,
		crit_chance = 0.05,
		crit_mult = 1.5,
	},
	.Secondary = {
		damage_mult = 0.4,
		speed_mult = 2.0,
		knockback = 0.0,
		crit_chance = 0.02,
		crit_mult = 1.2,
	},
	.Alt = {
		damage_mult = 1.2,
		speed_mult = 1.0,
		knockback = 0.3,
		crit_chance = 0.1,
		crit_mult = 2.0,
	},
	.Channel = {
		damage_mult = 4.0,
		speed_mult = 0.2,
		knockback = 1.5,
		crit_chance = 0.25,
		crit_mult = 3.5,
	},
}

make_crossbow :: proc() -> Weapon {
	return Weapon {
		item = {name = "Crossbow"},
		damage = 15,
		attack_speed = 1.0,
		weapon_type = RangedWeapon{range = 10.0},
		attack_bases = &CROSSBOW_ATTACKS,
		mods = default_modifiers(),
	}
}
