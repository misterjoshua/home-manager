{ ... }:
{
  plugins.blink-cmp = {
    enable = true;
    settings = {
      # Default keymap. <C-space> etc.
      keymap.preset = "default";

      # Add brackets when accepting completions for function calls.
      completion.accept.auto_brackets.enabled = true;
      completion.accept.auto_brackets.semantic_token_resolution.enabled = true;

      # Show documentation.
      completion.documentation.auto_show = true;

      # Show signature help.
      signature.enabled = true;

      # Buffer completions are lower priority.
      sources.providers.buffer.score_offset = -7;
    };
  };

}
