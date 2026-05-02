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
import "core:math/rand"
import "core:strings"
import "core:sync"
import "core:time"

import sapp "bald:sokol/app"
import sg "bald:sokol/gfx"
import sglue "bald:sokol/glue"
import slog "bald:sokol/log"

Weapon :: struct {
	using item:   Item,
	damage:       int,
	attack_speed: f32,
	weapon_type:  WeaponType,
	attack_bases: ^[AttackKind]AttackBase,
	mods:         WeaponModifiers,
}

WeaponType :: union {
	MeleeWeapon,
	RangedWeapon,
}

WeaponModifiers :: struct {
	damage_mult:     f32,
	speed_mult:      f32,
	knockback_add:   f32,
	crit_chance_add: f32,
	crit_mult_add:   f32,
	// different elementals effects go here
}

default_modifiers :: proc() -> WeaponModifiers {
	return WeaponModifiers{damage_mult = 1.0, speed_mult = 1.0}
}

MeleeWeapon :: struct {
	reach: f32,
	angle: f32,
}

RangedWeapon :: struct {
	range: f32,
}

AttackProcs :: struct {
	main:      proc(w: ^Weapon) -> int,
	secondary: proc(w: ^Weapon) -> int,
	alt:       proc(w: ^Weapon) -> int,
	channel:   proc(w: ^Weapon) -> int,
}

AttackKind :: enum {
	Main,
	Secondary,
	Alt,
	Channel,
}

AttackResult :: struct {
	damage:    int,
	knockback: f32,
	cast_time: f32,
	is_crit:   bool,
}

apply_weapon_modifiers :: proc(weapon: ^Weapon, raw: f32, kind: AttackKind) -> f32 {
	damage := raw
	switch wep in weapon.weapon_type {
	case MeleeWeapon:
		if kind == .Channel do damage *= (1 + wep.reach * 0.1)
	case RangedWeapon:
		if kind == .Alt do damage *= (1 + wep.range * 0.05)
	}
	return damage
}

perform_attack :: proc(weapon: ^Weapon, kind: AttackKind) -> AttackResult {
	base := weapon.attack_bases[kind]
	mods := weapon.mods

	// Base attack values scaled by runtime modifiers
	raw_damage := f32(weapon.damage) * base.damage_mult * mods.damage_mult
	final_damage := apply_weapon_modifiers(weapon, raw_damage, kind)

	is_crit := rand.float32() < math.min(mods.crit_chance_add + base.crit_chance, 1.0)
	if is_crit do final_damage *= base.crit_mult + mods.crit_mult_add

	return AttackResult {
		damage = int(final_damage),
		knockback = base.knockback + mods.knockback_add,
		cast_time = weapon.attack_speed * base.speed_mult * mods.speed_mult,
		is_crit = is_crit,
	}
}
