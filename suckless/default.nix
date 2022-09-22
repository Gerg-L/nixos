(final: super: rec {
 st = (super.st.override {  patches = [
#scrolling 
     (super.fetchpatch {
      url = "https://st.suckless.org/patches/scrollback/st-scrollback-0.8.5.diff";
      sha256 = "sha256-ZZAbrWyIaYRtw+nqvXKw8eXRWf0beGNJgoupRKsr2lc=";
      })
#scrolling with shift+scrollwheel
     (super.fetchpatch {
      url = "https://st.suckless.org/patches/scrollback/st-scrollback-mouse-20220127-2c5edf2.diff";
      sha256 = "sha256-CuNJ5FdKmAtEjwbgKeBKPJTdEfJvIdmeSAphbz0u3Uk=";
      })
     (super.fetchpatch {
      url = "https://st.suckless.org/patches/bold-is-not-bright/st-bold-is-not-bright-20190127-3be4cf1.diff";
      sha256 = "sha256-IhrTgZ8K3tcf5HqSlHm3GTacVJLOhO7QPho6SCGXTHw=";
      })
     (super.fetchpatch {
      url = "https://st.suckless.org/patches/anysize/st-anysize-20220718-baa9357.diff";
      sha256 = "sha256-yx9VSwmPACx3EN3CAdQkxeoJKJxQ6ziC9tpBcoWuWHc=";
      })
     (super.fetchpatch {
      url = "https://st.suckless.org/patches/desktopentry/st-desktopentry-0.8.5.diff";
      sha256 = "sha256-JUFRFEHeUKwtvj8OV02CqHFYTsx+pvR3s+feP9P+ezo=";
      })
      (super.fetchpatch {
      url = "https://st.suckless.org/patches/boxdraw/st-boxdraw_v2-0.8.5.diff";
      sha256 = "sha256-WN/R6dPuw1eviHOvVVBw2VBSMDtfi1LCkXyX36EJKi4=";
      })
     ];
 }).overrideAttrs (oldAttrs: rec {
   configFile = super.writeText "config.h" (builtins.readFile ./st/config.h);
   postPatch = "${oldAttrs.postPatch}\ncp ${configFile} config.h\n";
   });
})
