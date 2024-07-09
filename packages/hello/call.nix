{ callPackage }:
{
  callPackage = f: x: callPackage f ({ bar = "foo"; } // x);
  args = {
    foo = "bar";
  };
}
