{ config, lib }:

with lib;
let
  cfgEditors = config.modules.home.editors;
in
{
  /**
    Check if editors configuration contains the language

    # Type

    ```
    cfgHasLanguage:: string -> bool
    ```

    # Examples
    :::{.example}
    ## `cfgHasLanguage` usage example

    ```nix
    cfgHasLanguage "rust"
    => true
    ```

    :::
  */
  cfgHasLanguage = language: elem language cfgEditors.languages;

  /**
    Check if editors configuration contains any of languages

    # Type

    ```
    cfgHasAnyOfLanguages:: [string] -> bool
    ```

    # Examples
    :::{.example}
    ## `cfgHasAnyOfLanguages` usage example

    ```nix
    cfgHasAnyOfLanguages [ "rust" "java" ]
    => true
    ```

    :::
  */
  cfgHasAnyOfLanguages = languages: any (l: elem l languages) cfgEditors.languages;
}
