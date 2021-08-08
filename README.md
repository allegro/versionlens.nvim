# versionlens.nvim

Is plugin inspired by [VSCode VersionLens](https://marketplace.visualstudio.com/items?itemName=pflannery.vscode-versionlens)

## The Problem
Often you need check on available updates for packages in your project lockfiles.
This plugin let you do this without leaving editor by showing virtual text next to current version.

## How it is done?
versionlens.nvim benefit from latest neovim featres to provide async fetch of updates data.
We also use treesitter to easly parse lockfiles to find all packages we need to check.
Async calls are done by Plenary Jobs so you can edit your files while plugin check updates for you.

## Extensibility
Plugin is meant to use with multiple languages lockfiles.
It is done by providers api which is abstract for doing language spacific fech and parsing and returnig structurized data for renderer.


## Currently supported languages
* javascript/typescript - nodejs

## Installation
Simply install via your favorite plugin manager.

### Requirements:
* neovim 0.5.0+
* [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
* [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

Example for `vim-plug`:
```vim
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'allegro/versionlens.nvim'
```

### Minimal config
```lua
require'versionlens'.setup{
  enabled_providers = { 'npm' },
}
```

### Config API
```lua
require'versionlens'.setup{
  enabled_providers = {
    'providar_name',
    -- or
    -- { name = 'provider_name' }
    -- or
    -- { name = 'provider_name', '--cmd-line-arg' }
    -- or
    -- { name = 'provider_name', args = '--cmd-line-arg' }
    -- or
    -- { 'provider_name', args = '--cmd-line-arg' }
  },
  render_up_to_date = true, -- false - skip rendering uptodate lenses
  signs = {
    need_update = "🔺",
    up_to_date = "✅",
  },
}
```

## How it works?
To show lenses use:
`:VersionLensRender`

To apply version from lens to your file use:
`:VersionLensApply`

TODO:
* rust provider
* java(gradle) provider
* tests
* (un)install jobs from editor

Created by [Paweł Mizio](https://github.com/pmizio)
