use std::mem::size_of;
use winapi;
use winapi::shared::minwindef::{DWORD, LPARAM, LPDWORD, TRUE};
use winapi::shared::windef::HWND;
pub use winapi::shared::winerror::{ERROR_ACCESS_DENIED, ERROR_BAD_PATHNAME};
use winapi::um::winuser::{
  GetWindow, IsWindowVisible, SetWindowPos, GW_OWNER, HWND_BOTTOM, HWND_TOP, SWP_HIDEWINDOW,
  SWP_NOSENDCHANGING, SWP_SHOWWINDOW,
};
use winapi::um::{
  sysinfoapi::GetTickCount64,
  winuser,
  winuser::{GetLastInputInfo, GetSystemMetrics, LASTINPUTINFO, SM_CXSCREEN, SM_CYSCREEN},
};

pub fn get_idle_time() -> u64 {
  unsafe {
    let last_input = &mut LASTINPUTINFO {
      cbSize: 0,
      dwTime: 0,
    } as *mut LASTINPUTINFO;
    (*last_input).cbSize = size_of::<LASTINPUTINFO>() as u32;
    let _ = GetLastInputInfo(last_input);
    return (GetTickCount64() - ((*last_input).dwTime) as u64) / 1000;
  }
}

pub fn move_window(pid: u32, num: i32, count: i32) {
  unsafe {
    let width = (GetSystemMetrics(SM_CXSCREEN)) / count;
    let height = GetSystemMetrics(SM_CYSCREEN);
    let window = find_window(pid);
    SetWindowPos(
      window,
      HWND_TOP,
      (width * num) - 7,
      0,
      width + 15,
      height,
      SWP_SHOWWINDOW + SWP_NOSENDCHANGING,
    );
  }
}

pub fn hide_window(pid: u32) {
  unsafe {
    let window = find_window(pid);
    SetWindowPos(
      window,
      HWND_BOTTOM,
      0,
      0,
      10,
      10,
      SWP_HIDEWINDOW + SWP_NOSENDCHANGING,
    );
  }
}

struct HandleData {
  process_id: LPDWORD,
  window_handle: HWND,
}

fn is_main_window(handle: HWND) -> bool {
  unsafe {
    return GetWindow(handle, GW_OWNER) == 0 as HWND && (IsWindowVisible(handle) == TRUE);
  }
}

unsafe fn find_window(pid: u32) -> HWND {
  let mut data = HandleData {
    process_id: pid as LPDWORD,
    window_handle: 0 as HWND,
  };
  winuser::EnumWindows(
    Some(enum_windows_proc),
    &mut data as *mut HandleData as LPARAM,
  );
  return data.window_handle;
}

extern "system" fn enum_windows_proc(handle: HWND, l_param: LPARAM) -> i32 {
  let data = unsafe { &mut *(l_param as *mut HandleData) };
  let process_id: LPDWORD = 0 as LPDWORD;
  unsafe { GetWindowThreadProcessId(handle, &process_id) };
  if data.process_id != process_id || !is_main_window(handle) {
    return 1;
  }
  data.window_handle = handle;
  return 0;
}

extern "system" {
  fn GetWindowThreadProcessId(hWnd: HWND, lpdwProcessId: &LPDWORD) -> DWORD;
}

pub fn wait_for_display() {
  return;
}
