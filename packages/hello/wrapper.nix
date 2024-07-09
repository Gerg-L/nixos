{
  symlinkJoin,
  foo,
  bar,
  hello-unwrapped,
}:
symlinkJoin {
  name = "hello-wrapped";
  paths = [ hello-unwrapped ];
  postBuild = ''
    ln -s $out/bin/hello $out/bin/hello-wrapped
  '';

  passthru = {
    inherit foo bar;
  };
}
