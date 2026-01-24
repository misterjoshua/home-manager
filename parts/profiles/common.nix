{ inputs, ... }:
{
  flake.modules.homeManager.commonProfile = (inputs.import-tree ./_common);
}
