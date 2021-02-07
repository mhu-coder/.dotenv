# Setup info

This configuration requires neovim >= 0.5.

## External dependencies

| Program | Plugins                                   |
|:-------:|-------------------------------------------|
| Nodejs  | pyright LSP (<15.x) <br> markdown preview <br> katex|
| Python  | cmake LSP |

## Language servers

### Python

Install:
* Install nodejs (pyright <= 1.1.94 may not work properly with nodejs >= 15.x)
* Install pyright: `sudo npm i -g pyright`

For each python project, you may need to override the default settings. To do
so, create a file named `pyrightconfig.json` at the root of the git repository.
For example, it may contain the following:

```json
{
    "reportDuplicateImport": "warning",
    "reportGeneralTypeIssues": "error",
    "reportImportCycles": "warning",
    "reportIncompatibleMethodOverrride": "warning",
    "reportIncompatibleVariableOverride": "warning",
    "reportUnnecessaryCast": "warning",
    "reportUnnecessaryIsInstance": "warning",
    "reportUnusedCallResult": "warning",
    "reportUnusedClass": "warning",
    "reportUnusedFunction": "warning",
    "reportUnusedImport": "warning",
    "reportUnusedVariable": "warning"
}
```

### Lua
Follow the install instructions on [sumneko-lua][sumneko-lua]

### C family
Install `clangd`: `sudo apt install clangd`

__Note__: Check that the version is >= 9

### CMake
Install `cmake-language-server`: `pip install cmake-language-server`

## Error check
Run the ex-command `:checkhealth` to get a health diagnosis.

[sumneko-lua]: https://github.com/sumneko/lua-language-server
