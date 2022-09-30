fn main() {
#[cfg(windows)]
return;
println!("cargo:rustc-link-lib=X11");
println!("cargo:rustc-link-lib=Xss");
}
