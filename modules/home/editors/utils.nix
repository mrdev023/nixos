{ config, lib }:

with lib;
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
  cfgHasLanguage = language: elem language config.languages;

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
  cfgHasAnyOfLanguages = languages: any (l: elem l languages) config.languages;
}
