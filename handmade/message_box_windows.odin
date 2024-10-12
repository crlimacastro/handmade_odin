package handmade

import "core:sys/windows"

message_box_icon_type :: enum {
	none        = 0x00000000,
	hand        = 0x00000010,
	question    = 0x00000020,
	exclamation = 0x00000030,
	asterisk    = 0x00000040,
	user_icon   = 0x00000080,
	warning     = exclamation,
	error       = hand,
	information = asterisk,
	stop        = hand,
}

message_box_type :: enum {
	ok                  = 0x00000000,
	ok_cancel           = 0x00000001,
	abort_retry_ignore  = 0x00000002,
	yes_no_cancel       = 0x00000003,
	yes_no              = 0x00000004,
	retry_cancel        = 0x00000005,
	cancel_try_continue = 0x00000006,
}

message_box_show_options :: struct {
	text:      string,
	caption:   string,
	icon_type: message_box_icon_type,
	box_type:  message_box_type,
}

message_box :: proc(#by_ptr opts: message_box_show_options) {
	_windows_init()
	using opts
	windows.MessageBoxW(
		nil,
		windows.utf8_to_wstring(text),
		windows.utf8_to_wstring(caption),
		windows.UINT(icon_type) | windows.UINT(box_type),
	)
}
