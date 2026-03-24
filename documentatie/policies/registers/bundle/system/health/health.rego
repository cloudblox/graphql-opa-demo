package system.health

default live := true

default ready := false

# opa is ready once all plugins have reported OK at least once AND
# the bundle plugin is currently in an OK state
ready if {
	input.plugins_ready
	input.plugin_state.bundle == "OK"
}
