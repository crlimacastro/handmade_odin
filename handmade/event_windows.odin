package handmade

import "core:sys/windows"

poll_events :: proc() -> int {
	_windows_init()
	msg: windows.MSG
	for windows.GetMessageW(&msg, nil, 0, 0) > 0 {
		windows.TranslateMessage(&msg)
		windows.DispatchMessageW(&msg)
	}
	return int(msg.wParam)
}
