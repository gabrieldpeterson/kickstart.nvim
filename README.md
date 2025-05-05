# kickstart.nvim

## Gabe's instructions
*** Begin Gabe's notes
https://www.youtube.com/watch?v=m8C0Cq9Uv9o

***Note: Don't use the default terminal. Use a terminal emulator like Kitty***
## Kitty
### Install JetBrains Mono Nerd Font
```
brew install --cask font-jetbrains-mono-nerd-font
```

### Set font as default
Add to the settings config
```
map ctrl+shift+t new_tab_with_cwd
font_family JetBrainsMono Nerd Font Mono
font_size 14
allow_remote_control yes
listen_on unix:/tmp/kitty-socket
```

# Kickstart
https://github.com/nvim-lua/kickstart.nvim
Fork, then clone your directory
In MacOS, clone to `~/.config`, then rename `kickstart.nvim` to `nvim`

## Help
` sh` (space sh) to view help

# Telescope Fuzzy Finder
![[default-telescope-kickstart-keymaps.png]]
# Language Server Protocol (LSP)
`gd` go to definition
`gr` go to reference
` ws` find symbols in current document
` ws` find symbols in current workspace
`K` find documentation provided by LSP

In the `init.lua` uncomment out the 
```
--clangd = {}
and 
--pyright = {}
by removing the --
```

Make sure the install the correct language support
MacOS:
```
brew install llvm
brew install pyright
```

# Autocomplete
Uses nvim-cmp
`<C-n>` next item in autocomplete
`<C-p>` previous item in autocomplete
`<C-y>` to accept

# Comments
Can add special highlighting by `NOTE:` `TODO:` `FIXME:`

# Helpful Additions
`va)` will visually select around the next parenthesis
`yinq` will yank inside the next quote
`ci'` will change inside the quote

![[mini-neovim-keys.png]]

# C++ Debugging
Init `init.lua`, uncomment the line `--require 'kickstart.plugins.debug'`

On MacOS we'll use the built-in LLDB that comes with XCode Find the LLDB, use the following commands in the terminal

```
sudo find /Applications/Xcode.app -name lldb-vscode 2>/dev/null 
sudo find /Library/Developer/CommandLineTools -name lldb-vscode 2>/dev/null
```

If none are installed, download CodeLLDB at [https://github.com/vadimcn/codelldb/releases](https://github.com/vadimcn/codelldb/releases "https://github.com/vadimcn/codelldb/releases") Select the Darwin arm64 release Download and extract to

```~/.local/share/nvim/dap_adapters/codelldb/```

With the command

```
unzip ~/Downloads/codelldb-darwin-arm64.vsix -d ~/.local/share/nvim/dap_adapters/codelldb
```

Ensure it's executable

```
chmod +x ~/.local/share/nvim/dap_adapters/codelldb/extension/adapter/codelldb
```

Run the following commands to allow MacOS to run them
```
xattr -d com.apple.quarantine ~/.local/share/nvim/dap_adapters/codelldb/extension/adapter/codelldb

// To recursively get all files in codelldb out of quarantine
xattr -r -d com.apple.quarantine ~/.local/share/nvim/dap_adapters/codelldb
```

Verify the path

```
find ~/.local/share/nvim/dap_adapters/codelldb/extension -type f -name codelldb
```

Add the following, with the verified path, in `init.lua`

```
local dap = require('dap')

dap.adapters.lldb = {
  type = 'server',
  port = "${port}",
  executable = {
    command = vim.fn.expand("~/.local/share/nvim/dap_adapters/codelldb/extension/adapter/codelldb"),
    args = {"--port", "${port}"},
  },
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
}
dap.configurations.c = dap.configurations.cpp
```

## Add Keyboard Shortcuts 

Add to `init.lua` below the above code
```
-- Continue or start debugging (F5)
vim.keymap.set('n', '<F5>', dap.continue, { desc = "Start/Continue Debugging" })

-- Step Over (F10)
vim.keymap.set('n', '<F10>', dap.step_over, { desc = "Step Over" })

-- Step Into (F11)
vim.keymap.set('n', '<F11>', dap.step_into, { desc = "Step Into" })

-- Step Out (Shift+F11)
vim.keymap.set('n', '<S-F11>', dap.step_out, { desc = "Step Out" })

-- Toggle Breakpoint (Leader + b)
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })

-- Set Conditional Breakpoint (Leader + B)
vim.keymap.set('n', '<leader>B', function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { desc = "Conditional Breakpoint" })

-- Open Debugger REPL (Leader + dr)
vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = "Open Debugger REPL" })

-- Run Last Debug Session (Leader + dl)
vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = "Run Last Debug Session" })

-- Toggle DAP UI (Leader + du)
vim.keymap.set('n', '<leader>du', function()
  require('dapui').toggle()
end, { desc = "Toggle DAP UI" })
```

*** End Gabe's notes

## Introduction

A starting point for Neovim that is:

* Small
* Single-file
* Completely Documented

**NOT** a Neovim distribution, but instead a starting point for your configuration.

## Installation

### Install Neovim

Kickstart.nvim targets *only* the latest
['stable'](https://github.com/neovim/neovim/releases/tag/stable) and latest
['nightly'](https://github.com/neovim/neovim/releases/tag/nightly) of Neovim.
If you are experiencing issues, please make sure you have the latest versions.

### Install External Dependencies

External Requirements:
- Basic utils: `git`, `make`, `unzip`, C Compiler (`gcc`)
- [ripgrep](https://github.com/BurntSushi/ripgrep#installation)
- Clipboard tool (xclip/xsel/win32yank or other depending on the platform)
- A [Nerd Font](https://www.nerdfonts.com/): optional, provides various icons
  - if you have it set `vim.g.have_nerd_font` in `init.lua` to true
- Emoji fonts (Ubuntu only, and only if you want emoji!) `sudo apt install fonts-noto-color-emoji`
- Language Setup:
  - If you want to write Typescript, you need `npm`
  - If you want to write Golang, you will need `go`
  - etc.

> **NOTE**
> See [Install Recipes](#Install-Recipes) for additional Windows and Linux specific notes
> and quick install snippets

### Install Kickstart

> **NOTE**
> [Backup](#FAQ) your previous configuration (if any exists)

Neovim's configurations are located under the following paths, depending on your OS:

| OS | PATH |
| :- | :--- |
| Linux, MacOS | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
| Windows (cmd)| `%localappdata%\nvim\` |
| Windows (powershell)| `$env:LOCALAPPDATA\nvim\` |

#### Recommended Step

[Fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo) this repo
so that you have your own copy that you can modify, then install by cloning the
fork to your machine using one of the commands below, depending on your OS.

> **NOTE**
> Your fork's URL will be something like this:
> `https://github.com/<your_github_username>/kickstart.nvim.git`

You likely want to remove `lazy-lock.json` from your fork's `.gitignore` file
too - it's ignored in the kickstart repo to make maintenance easier, but it's
[recommended to track it in version control](https://lazy.folke.io/usage/lockfile).

#### Clone kickstart.nvim
> **NOTE**
> If following the recommended step above (i.e., forking the repo), replace
> `nvim-lua` with `<your_github_username>` in the commands below

<details><summary> Linux and Mac </summary>

```sh
git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

</details>

<details><summary> Windows </summary>

If you're using `cmd.exe`:

```
git clone https://github.com/nvim-lua/kickstart.nvim.git "%localappdata%\nvim"
```

If you're using `powershell.exe`

```
git clone https://github.com/nvim-lua/kickstart.nvim.git "${env:LOCALAPPDATA}\nvim"
```

</details>

### Post Installation

Start Neovim

```sh
nvim
```

That's it! Lazy will install all the plugins you have. Use `:Lazy` to view
the current plugin status. Hit `q` to close the window.

#### Read The Friendly Documentation

Read through the `init.lua` file in your configuration folder for more
information about extending and exploring Neovim. That also includes
examples of adding popularly requested plugins.

> [!NOTE]
> For more information about a particular plugin check its repository's documentation.


### Getting Started

[The Only Video You Need to Get Started with Neovim](https://youtu.be/m8C0Cq9Uv9o)

### FAQ

* What should I do if I already have a pre-existing Neovim configuration?
  * You should back it up and then delete all associated files.
  * This includes your existing init.lua and the Neovim files in `~/.local`
    which can be deleted with `rm -rf ~/.local/share/nvim/`
* Can I keep my existing configuration in parallel to kickstart?
  * Yes! You can use [NVIM_APPNAME](https://neovim.io/doc/user/starting.html#%24NVIM_APPNAME)`=nvim-NAME`
    to maintain multiple configurations. For example, you can install the kickstart
    configuration in `~/.config/nvim-kickstart` and create an alias:
    ```
    alias nvim-kickstart='NVIM_APPNAME="nvim-kickstart" nvim'
    ```
    When you run Neovim using `nvim-kickstart` alias it will use the alternative
    config directory and the matching local directory
    `~/.local/share/nvim-kickstart`. You can apply this approach to any Neovim
    distribution that you would like to try out.
* What if I want to "uninstall" this configuration:
  * See [lazy.nvim uninstall](https://lazy.folke.io/usage#-uninstalling) information
* Why is the kickstart `init.lua` a single file? Wouldn't it make sense to split it into multiple files?
  * The main purpose of kickstart is to serve as a teaching tool and a reference
    configuration that someone can easily use to `git clone` as a basis for their own.
    As you progress in learning Neovim and Lua, you might consider splitting `init.lua`
    into smaller parts. A fork of kickstart that does this while maintaining the
    same functionality is available here:
    * [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim)
  * Discussions on this topic can be found here:
    * [Restructure the configuration](https://github.com/nvim-lua/kickstart.nvim/issues/218)
    * [Reorganize init.lua into a multi-file setup](https://github.com/nvim-lua/kickstart.nvim/pull/473)

### Install Recipes

Below you can find OS specific install instructions for Neovim and dependencies.

After installing all the dependencies continue with the [Install Kickstart](#Install-Kickstart) step.

#### Windows Installation

<details><summary>Windows with Microsoft C++ Build Tools and CMake</summary>
Installation may require installing build tools and updating the run command for `telescope-fzf-native`

See `telescope-fzf-native` documentation for [more details](https://github.com/nvim-telescope/telescope-fzf-native.nvim#installation)

This requires:

- Install CMake and the Microsoft C++ Build Tools on Windows

```lua
{'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
```
</details>
<details><summary>Windows with gcc/make using chocolatey</summary>
Alternatively, one can install gcc and make which don't require changing the config,
the easiest way is to use choco:

1. install [chocolatey](https://chocolatey.org/install)
either follow the instructions on the page or use winget,
run in cmd as **admin**:
```
winget install --accept-source-agreements chocolatey.chocolatey
```

2. install all requirements using choco, exit the previous cmd and
open a new one so that choco path is set, and run in cmd as **admin**:
```
choco install -y neovim git ripgrep wget fd unzip gzip mingw make
```
</details>
<details><summary>WSL (Windows Subsystem for Linux)</summary>

```
wsl --install
wsl
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip neovim
```
</details>

#### Linux Install
<details><summary>Ubuntu Install Steps</summary>

```
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip neovim
```
</details>
<details><summary>Debian Install Steps</summary>

```
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip curl

# Now we install nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo mkdir -p /opt/nvim-linux-x86_64
sudo chmod a+rX /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

# make it available in /usr/local/bin, distro installs to /usr/bin
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/
```
</details>
<details><summary>Fedora Install Steps</summary>

```
sudo dnf install -y gcc make git ripgrep fd-find unzip neovim
```
</details>

<details><summary>Arch Install Steps</summary>

```
sudo pacman -S --noconfirm --needed gcc make git ripgrep fd unzip neovim
```
</details>

