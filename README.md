# autocomplete-swift

[![License][license-badge]][license]
[![Release][release-badge]][release]

Autocompletion for Swift in [NeoVim][web-neovim] with [deoplete][github-deoplete].

![completion-gif](/_images/completion.gif)


## Announcement

**Autocompletion-swift will drop support for Vim and completion with omni-function**.
Please use this plugin in NeoVim with deoplete.vim.


## Installation

Autocomplete-swift uses [SourceKitten][github-sourcekitten] as its back-end.
Therefore this plugin supports macOS only.
SourceKitten can be installed with [Homebrew][github-homebrew].

Please execute the following command:

```bash
$ brew install sourcekitten
```

To install autocomplete-swift,
it is recommended to use plugin manager such as [dein.vim][github-dein].
In the case of dein.vim, please add the following codes into `init.vim` and configure them:

```vim
call dein#add('Shougo/deoplete.vim')
call dein#add('mitsuse/autocomplete-swift')
```

This plugin also supports jumping to placeholders in arguments of method.
The following configuration is required:

```vim
" Jump to the first placeholder by typing `<C-k>`.
autocmd FileType swift imap <buffer> <C-k> <Plug>(autocomplete_swift_jump_to_placeholder)
```

If you use [neosnippet][github-neosnippet],
you should enable [key-mappings of neosnippets][github-neosnippet-config] instead of using the above code.
Autocomplete-swift gets along with neosnippet by converting placeholders into its ones.


## Features

### Completion

Autocomplete-swift supports types of completion as follow:

- Type name
- Type/Instance member
- Function/method parameter
- Top-level function/constant/variable
- Keyword such as `protocol`, `extension` etc.


### Placeholder

This plugin supports jumping to placeholders in arguments of method.
Please read [Installation](#installation).


### Xcode Project Support

Autocomplete-swift experimentally supports completion with framework/SDK
by communicating with [SourceKittenDaemon][github-sourcekittendaemon].

After launching SourceKittenDaemon,
execute `call sourcekitten_daemon#enable({port_number})` in NeoVim.


#### Xcode <= 7.3.1

Please use the original [SourceKittenDaemon][github-sourcekittendaemon].


#### Xcode 8.0+

You can use [the forked version of SourceKittenDaemon][github-mitsuse/sourcekittendaemon] for Xcode 8.0 as a **workaround**.
Please checkout `support-xcode8.0` branch.

It can switch toolchains with `TOOLCHAINS` variable.
For excample, set `com.apple.dt.toolchain.Swift_2_3` to the variable for Swift 2.3.


## TODO

- Display more information of candidate (For example, the kind of candidate etc).
- Make configurable. For example, autocomplete-swift will get `max_candiates` for neocomplete from a variable.
- Add support for Linux.


## Related project

In the GIF on the beginning,
I use snippets for Swift contained in [neosnippet-snippets][github-neosnippet-snippets]
in addition to autocomplete-swift.


## License

Please read [LICENSE][license].

[license-badge]: https://img.shields.io/badge/license-MIT-yellowgreen.svg?style=flat-square
[license]: LICENSE
[release-badge]: https://img.shields.io/github/tag/mitsuse/neocomplete-swift.svg?style=flat-square
[release]: https://github.com/mitsuse/neocomplete-swift/releases
[github-sourcekitten]: https://github.com/jpsim/SourceKitten
[github-sourcekittendaemon]: https://github.com/terhechte/SourceKittenDaemon
[github-mitsuse/sourcekittendaemon]: https://github.com/mitsuse/SourceKittenDaemon/tree/support-xcode8.0
[github-homebrew]: https://github.com/Homebrew/homebrew
[github-neosnippet]: https://github.com/Shougo/neosnippet.vim
[github-neosnippet-config]: https://github.com/Shougo/neosnippet.vim#configuration
[github-neosnippet-snippets]: https://github.com/Shougo/neosnippet-snippets
[github-deoplete]: https://github.com/Shougo/deoplete.nvim
[github-dein]: https://github.com/Shougo/dein.vim
[web-neovim]: https://neovim.io/
