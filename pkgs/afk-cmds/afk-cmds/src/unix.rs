use x11::xlib::{
  Atom, CWOverrideRedirect, Display, Window, XChangeWindowAttributes, XCloseDisplay,
  XDefaultRootWindow, XDefaultScreen, XDisplayHeight, XDisplayWidth, XFlush, XFree,
  XGetWindowProperty, XInternAtom, XMapWindow, XMoveResizeWindow, XOpenDisplay, XQueryTree,
  XSetWindowAttributes, XUnmapWindow, XA_CARDINAL,
};
use x11::xss::{XScreenSaverAllocInfo, XScreenSaverQueryInfo};

use std::ffi::c_void;
use std::os::raw::c_int;
use std::ptr::null;
use std::thread;
use std::time::Duration;

pub fn get_idle_time() -> u64 {
  unsafe {
    let dpy = XOpenDisplay(null());
    if dpy.is_null() {
      println!("{}","Couldn't access display in fn get_idle_time()");
      thread::sleep(Duration::from_secs(10));
      return 0;
    }
    let info = XScreenSaverAllocInfo();
    XScreenSaverQueryInfo(dpy, XDefaultRootWindow(dpy), info);
    let r = (*info).idle;
    XFree(info as *mut c_void);
    XCloseDisplay(dpy);
    return (r / 1000) as u64;
  }
}

pub fn wait_for_display() {
  loop {
    unsafe {
      let dpy = XOpenDisplay(null());
      if !dpy.is_null() {
        XCloseDisplay(dpy);
        println!("{}","Starting...");
        return;
      }
      println!("{}", "Waiting for X");
      thread::sleep(Duration::from_secs(10));
    }
  }
}

pub fn move_window(pid: u32, num: i32, count: i32) {
  let _ = pid;
  unsafe {
    let dpy: *mut Display = XOpenDisplay(null());
    if dpy.is_null() {
      println!("{}","Couldn't access display in fn move_window()");
      return;
    }
    let scr: c_int = XDefaultScreen(dpy);
    let width: c_int = XDisplayWidth(dpy, scr) / count;
    let height: c_int = XDisplayHeight(dpy, scr);
    let window = get_by_pid(dpy, pid);
    if window == 0 {
      print!("{}","Couldn't move window");
      XCloseDisplay(dpy);
      return;
    }
    let mut wattr: XSetWindowAttributes = std::mem::zeroed();
    wattr.override_redirect = 1;
    XChangeWindowAttributes(dpy, window, CWOverrideRedirect, &mut wattr);
    XUnmapWindow(dpy, window);
    XFlush(dpy);
    XMapWindow(dpy, window);
    XFlush(dpy);
    XMoveResizeWindow(dpy, window, width * num, 0, width as u32, height as u32);
    XCloseDisplay(dpy);
  }
}

pub fn hide_window(pid: u32) {
  let _ = pid;
  unsafe {
    let dpy: *mut Display = XOpenDisplay(std::ptr::null());
    let window = get_by_pid(dpy, pid);
    let mut wattr: XSetWindowAttributes = std::mem::zeroed();
    wattr.override_redirect = 1;
    XChangeWindowAttributes(dpy, window, CWOverrideRedirect, &mut wattr);
    XUnmapWindow(dpy, window);
    XFlush(dpy);
    XCloseDisplay(dpy);
  }
}

unsafe fn recursion(
  display: *mut Display,
  pid: u32,
  atom_pid: Atom,
  window: Window,
  results: &mut Vec<Window>,
) {
  let mut typew: u64 = 0;
  let mut format: i32 = 0;
  let mut n_items: u64 = 0;
  let mut bytes_after: u64 = 0;
  let mut prop_pid: *mut u8 = 0 as *mut _;
  if XGetWindowProperty(
    display,
    window,
    atom_pid,
    0,
    1,
    0,
    XA_CARDINAL,
    &mut typew,
    &mut format,
    &mut n_items,
    &mut bytes_after,
    &mut prop_pid,
  ) == 0
  {
    if prop_pid != 0 as *mut _ {
      if pid as u64 == *(prop_pid as *const u64) {
        results.push(window);
      }

      XFree(prop_pid as *mut c_void);
    }
  }
  let mut root_window: u64 = 0;
  let mut parent_window: u64 = 0;
  let mut children: *mut u64 = 0 as *mut _;
  let mut children_count: u32 = 0;
  if XQueryTree(
    display,
    window,
    &mut root_window,
    &mut parent_window,
    &mut children,
    &mut children_count,
  ) != 0
  {
    let slice = std::slice::from_raw_parts(children, children_count as usize);
    for window in slice {
      recursion(display, pid, atom_pid, *window, results);
    }
  }
}

unsafe fn get_by_pid(display: *mut Display, pid: u32) -> Window {
  if display.is_null() {
    return 0;
  }

  let root: Window = XDefaultRootWindow(display);
  let atom = XInternAtom(display, "_NET_WM_PID\0".as_ptr() as *const i8, 1);
  if atom == 0 {
    return 0;
  }

  let mut results: Vec<Window> = Vec::new();
  recursion(display, pid, atom, root, &mut results);
  if results.is_empty() {
    return 0;
  }
  return results[0];
}
