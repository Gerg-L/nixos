(final: super: rec {
 st = (super.st.override { extraLibs = with super; [ xorg.libXcursor harfbuzz ];
 }).overrideAttrs (oldAttrs: rec {  
  src = ./st;
  });
 dwm = (super.dwm.override {}).overrideAttrs (oldAttrs: rec {
  src = ./dwm;
 });
})
