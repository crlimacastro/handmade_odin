package handmade_odin

import "handmade"

main :: proc() {
	window, ok := handmade.window_create({name = "Hello, World!"})
	if !ok {
		return
	}
	for {
		event := handmade.poll_events()
		if event == handmade.event_quit {
			break
		}
	}
}
