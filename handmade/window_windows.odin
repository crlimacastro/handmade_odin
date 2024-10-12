package handmade

import "base:intrinsics"
import "base:runtime"
import "core:sys/windows"

window :: struct {
	handle: windows.HWND,
}

window_create_options :: struct {
	name:           string,
	hide_on_create: bool,
}

window_create :: #force_inline proc(#by_ptr opts: window_create_options) -> (window, bool) {
	_windows_init()
	using opts


	window_class := windows.WNDCLASSW {
		lpfnWndProc = proc "system" (
			handle: windows.HWND,
			msg: windows.UINT,
			wparam: windows.WPARAM,
			lparam: windows.LPARAM,
		) -> windows.LRESULT {
			context = runtime.default_context()
			switch msg {
				case windows.WM_DESTROY:
					windows.PostQuitMessage(0)
			case:
				return windows.DefWindowProcW(handle, msg, wparam, lparam)
			}
			return {}
		},
		hInstance = _windows_get_instance(),
		lpszClassName = intrinsics.constant_utf16_cstring("window_class"),
	}
	if windows.RegisterClassW(&window_class) == {} {return {}, false}

	handle := windows.CreateWindowW(
		windows.LPCWSTR(uintptr(_windows_get_instance_atom())),
		windows.utf8_to_wstring(name),
		windows.WS_OVERLAPPED |
		windows.WS_CAPTION |
		windows.WS_SYSMENU |
		windows.WS_MINIMIZEBOX |
		windows.WS_MAXIMIZEBOX |
		windows.CS_HREDRAW |
		windows.CS_VREDRAW,
		windows.CW_USEDEFAULT,
		windows.CW_USEDEFAULT,
		windows.CW_USEDEFAULT,
		windows.CW_USEDEFAULT,
		nil,
		nil,
		_windows_get_instance(),
		nil,
	)

	if handle == nil {return {}, false}

	window := window {
		handle = handle,
	}
	if !hide_on_create {
		window_show(&window)
	}
	return window, true
}

window_show :: proc(w: ^window) {
	_windows_init()
	windows.ShowWindow(w.handle, windows.SW_SHOWDEFAULT)
	windows.UpdateWindow(w.handle)
}
