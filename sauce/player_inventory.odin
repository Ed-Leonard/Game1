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


inventory_setup :: proc() -> [4]proc() -> int {

	attack_slots: [4]proc() -> int

	return attack_slots
}
