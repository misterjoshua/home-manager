{ inputs, ... }:
{
  flake.modules.homeManager.shell = (inputs.import-tree ./_shell);
}
