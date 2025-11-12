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

Weapon :: struct {
	name:         string,
	damage:       int,
	attack_speed: f32,
	attack_types: [4]proc(damage: int, attack_speed: f32, name: string) -> int,
}

main_attack :: proc(damage: int, attack_speed: f32, name: string) -> int {
	log.info(name, " attack with damage:", damage)
	return damage
}

secondary_attack :: proc(damage: int, attack_speed: f32, name: string) -> int {
	log.info(name, "attack with damage:", damage)
	return damage
}

alt_attack :: proc(damage: int, attack_speed: f32, name: string) -> int {
	log.info(name, "attack with damage:", damage)
	return damage
}

channel_attack :: proc(damage: int, attack_speed: f32, name: string) -> int {
	log.info(name, "attack with damage:", damage)
	return damage
}

setup_weapons :: proc() -> []Weapon {
	weapons := make([]Weapon, 4)

	weapons[0] = Weapon {
		name         = "Sword",
		damage       = 10,
		attack_speed = .5,
	}
	weapons[1] = Weapon {
		name         = "Bow",
		damage       = 12,
		attack_speed = .75,
	}
	weapons[2] = Weapon {
		name         = "War Hammer",
		damage       = 15,
		attack_speed = 1,
	}
	weapons[3] = Weapon {
		name         = "Staff",
		damage       = 8,
		attack_speed = .4,
	}

	return weapons
}
