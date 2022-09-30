#![windows_subsystem = "windows"]

use ctrlc;
use ctrlc::set_handler;
use serde::{Deserialize, Serialize};
use single_instance::SingleInstance;
use std::sync::Arc;
use subprocess::{Popen, PopenConfig, Redirection};

use std::env;
use std::env::current_exe;
use std::ffi::OsString;
use std::fs::File;
use std::io::Read;
use std::path::PathBuf;
use std::process::exit;
use std::sync::atomic::{AtomicBool, Ordering};
use std::thread::sleep;
use std::time::Duration;
use std::vec;
#[cfg(unix)]
use unix::*;
#[cfg(windows)]
use windows::*;

#[cfg(unix)]
mod unix;
#[cfg(windows)]
mod windows;

mod tray_icon;
use tray_icon::*;
#[derive(Deserialize, Serialize, Debug, Clone)]
pub struct ProcessInfo {
  enabled: bool,
  path: String,
  cwd: String,
  args: Vec<String>,
  show_window: bool,
  while_afk: bool,
  kill: bool,
}

#[derive(Deserialize, Serialize, Debug)]
struct Jason {
  process_info: Vec<ProcessInfo>,
  afk_seconds: u64,
}

fn read_config() -> Jason {
  let mut config_path = Default::default();
  let args: Vec<OsString> = env::args_os().collect();
  if !args.is_empty() {
    match args
      .iter()
      .position(|r| (r == &OsString::from("--config") || r == &OsString::from("-c")))
    {
      Some(x) => {
        if x < args.len() {
          config_path = PathBuf::from(&args[x + 1 as usize]);
        } else {
          println!("please specify a config file");
        }
      }
      None => {
        config_path = current_exe().expect("Could not get exe location to find config.json");
        config_path.pop();
        config_path.push("config.json");
      }
    };
  }
  if config_path.exists() {
    let mut data = String::new();
    File::open(config_path)
      .unwrap()
      .read_to_string(&mut data)
      .unwrap();
    return serde_json::from_str(&data).expect("Invalid config format");
  } else {
    println! {"{}","Couldn't read config"};
    exit(1);
  }
}

fn start(mut group: &mut Group, movable: i32) {
  if group.started {
    return;
  }
  group.started = true;
  let mut i = 0;
  for info in group.process_info.iter() {
    let mut argv = vec![OsString::from(&info.path)];
    for arg in &info.args {
      argv.push(OsString::from(arg));
    }
    let mut child = Popen::create(
      &argv,
      PopenConfig {
        cwd: Option::from(OsString::from(&info.cwd)),
        stdin: Redirection::Pipe,
        ..Default::default()
      },
    )
    .expect("couldn't start child ");
    sleep(Duration::from_secs(1));

    if info.while_afk {
      if info.show_window {
        move_window(child.pid().expect("couldn't get pid"), i, movable);
        i += 1
      } else {
        hide_window(child.pid().expect("couldn't get pid"));
      }
    }
    if info.kill {
      group.children.push(child);
    } else {
      child.detach();
    }
  }
}

fn stop(mut group: &mut Group) {
  if !group.started {
    return;
  }
  group.started = false;
  let children = &mut group.children;
  for i in 0..children.len() {
    children[i].terminate().expect("Couldn't exit process");
    let _ = children[i].wait_timeout(Duration::from_secs(1));
  }
  if !children.is_empty() {
    children.clear();
  }
}

struct Group {
  process_info: Vec<ProcessInfo>,
  children: Vec<Popen>,
  started: bool,
}

fn main() {
  wait_for_display();
  let running_arc = Arc::new(AtomicBool::new(true));
  let pause_arc = Arc::new(AtomicBool::new(false));
  let r_clone = running_arc.clone();
  let p_clone = pause_arc.clone();

  let instance = SingleInstance::new("afk-cmds").unwrap();
  if !instance.is_single() {
    println!("Another instance is running");
    exit(1);
  }
  let mut json = read_config();
  tray_icon(r_clone, p_clone);
  //catch ctrl-c as gracefully as possible
  let running_clone = running_arc.clone();
  set_handler(move || {
    println!("{}", "Exit signal received exiting....");
    running_clone.store(false, Ordering::Relaxed)
  })
  .unwrap();

  let mut afk = Group {
    process_info: vec![],
    children: vec![],
    started: false,
  };
  let mut active = Group {
    process_info: vec![],
    children: vec![],
    started: false,
  };
  let mut movable = 0;
  for info in &json.process_info {
    if !info.enabled {
      continue;
    }
    if info.while_afk {
      afk.process_info.push(info.clone());
      if info.show_window {
        movable += 1;
      }
    } else {
      active.process_info.push(info.clone());
    }
  }
  json.process_info.clear();
  println!("{}", "Started");
  while running_arc.load(Ordering::Relaxed) {
    if pause_arc.load(Ordering::Relaxed) {
      sleep(Duration::from_secs(1));
      continue;
    };

    let idle_time = get_idle_time();
    if idle_time >= json.afk_seconds {
      stop(&mut active);
      start(&mut afk, movable);
    } else {
      stop(&mut afk);
      start(&mut active, 0);
      sleep(Duration::from_secs(1))
    }
    sleep(Duration::from_secs(1));
  }
  stop(&mut afk);
  stop(&mut active);
  println!("{}", "Exited normally");
  exit(0);
}
