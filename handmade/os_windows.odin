package handmade

import "base:intrinsics"
import "base:runtime"
import "core:sys/windows"

@(private)
_windows_is_initialized :: proc() -> bool {
	return _windows_instance_atom != {}
}

@(private)
_windows_init :: proc() {
	if _windows_is_initialized() {return}
	instance := windows.HINSTANCE(windows.GetModuleHandleW(nil))
	icon: windows.HICON = windows.LoadIconW(instance, windows.MAKEINTRESOURCEW(101))
	if icon == nil {icon = windows.LoadIconW(nil, windows.wstring(windows._IDI_APPLICATION))}
	cursor := windows.LoadCursorW(nil, windows.wstring(windows._IDC_ARROW))
	instance_class := windows.WNDCLASSW {
		style = windows.CS_HREDRAW | windows.CS_VREDRAW | windows.CS_OWNDC,
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
				return {}
			case:
				return windows.DefWindowProcW(handle, msg, wparam, lparam)
			}
		},
		hInstance = instance,
		hIcon = icon,
		hCursor = cursor,
		lpszClassName = intrinsics.constant_utf16_cstring("instance_class"),
	}
	_windows_instance_atom = windows.RegisterClassW(&instance_class)
}

@(private)
_windows_get_instance :: proc() -> windows.HINSTANCE {
	_windows_init()
	return windows.HINSTANCE(windows.GetModuleHandleW(nil))
}

@(private)
_windows_get_instance_atom :: proc() -> windows.ATOM {
	_windows_init()
	return _windows_instance_atom
}

@(private="file")
_windows_instance_atom: windows.ATOM
