use std::sync::Arc;
use core::sync::atomic::{AtomicBool,Ordering};
use gtk::prelude::*;
use libappindicator::{AppIndicator, AppIndicatorStatus};
use std::thread;

pub fn tray_icon(running_arc:Arc<AtomicBool>, pause_arc:Arc<AtomicBool>) {
    thread::spawn(move || {
    gtk::init().unwrap();
    let mut indicator = AppIndicator::new("afk-cmds",  ""); //temporary logo
    indicator.set_status(AppIndicatorStatus::Active);
    let mut menu = gtk::Menu::new();
    let pause = gtk::CheckMenuItem::with_label("Paused");
    pause.connect_activate(move |_| {
      pause_arc.store(!pause_arc.load(Ordering::Relaxed), Ordering::Relaxed);
    });
    menu.append(&pause);

    let quit = gtk::MenuItem::with_label("Quit");
    quit.connect_activate(move |_| {
      running_arc.store(false, Ordering::Relaxed);
    });
    menu.append(&quit);

    indicator.set_menu(&mut menu);
    menu.show_all();
    gtk::main()
  });
}
