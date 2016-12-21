# autocomplete-swift

[![License][license-badge]][license]
[![Release][release-badge]][release]

Autocompletion for Swift in [NeoVim][web-neovim] with [deoplete][github-deoplete].

![completion-gif](/_images/completion.gif)


## Announcement

- The support for **completion on SPM-based project** is added.
- Autocompletion-swift **droped support for Vim** and completion with omni-function.
Please **use this plugin in NeoVim** with deoplete.nvim.


## Installation

Autocomplete-swift uses [SourceKitten][github-sourcekitten] as its back-end.
Therefore this plugin supports macOS only.
SourceKitten can be installed with [Homebrew][github-homebrew].
This plugin also requires [PyYaml][web-pyyaml].

Please execute the following commands:

```bash
$ brew install sourcekitten
$ pip install pyyaml
```

To install autocomplete-swift,
it is recommended to use plugin manager such as [dein.vim][github-dein].
In the case of dein.vim, please add the following codes into `init.vim` and configure them:

```vim
call dein#add('Shougo/deoplete.nvim')
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
- Function/method/initializer parameter
- Top-level function/constant/variable
- Keyword such as `protocol`, `extension` etc.
- Method definition


### Placeholder

This plugin supports jumping to placeholders in arguments of method.
Please read [Installation](#installation).


### Custom Toolchain

The custom toolchain is available for completion.
For example, if you want to use Swift 2.3, 
call `autocomplete_swift#use_toolchain('Swift_2_3')` or
`autocomplete_swift#use_custom_toolchain('com.apple.dt.toolchain.Swift_2_3')`.


### Support for Swift Package Manager (SPM)

When you are editing a file managed with SPM, autocomplete-swift enables SPM-based completion.
It means that you can obtain candidates which come from dependencies (other files or libraries).


### Xcode Project Support

The previous version supported completion with framework/SDK experimentally,
but the feature is removed because the completion server has fatal bugs.


## TODO

- Display more information of candidate (For example, the kind of candidate etc).
- Make configurable. For example, autocomplete-swift will get `max_candiates` for deoplete from a variable.
- Add support for Linux.
- Add support for framework/SDK with [Yata][github-yata], which is a completion server for Swift under development.


## Related project

In the GIF on the beginning,
I use snippets for Swift contained in [neosnippet-snippets][github-neosnippet-snippets]
in addition to autocomplete-swift.


## License

Please read [LICENSE][license].

[license-badge]: https://img.shields.io/badge/license-MIT-yellowgreen.svg?style=flat-square
[license]: LICENSE
[release-badge]: https://img.shields.io/github/tag/mitsuse/autocomplete-swift.svg?style=flat-square
[release]: https://github.com/mitsuse/autocomplete-swift/releases
[github-sourcekitten]: https://github.com/jpsim/SourceKitten
[github-sourcekittendaemon]: https://github.com/terhechte/SourceKittenDaemon
[github-homebrew]: https://github.com/Homebrew/homebrew-core
[github-neosnippet]: https://github.com/Shougo/neosnippet.vim
[github-neosnippet-config]: https://github.com/Shougo/neosnippet.vim#configuration
[github-neosnippet-snippets]: https://github.com/Shougo/neosnippet-snippets
[github-deoplete]: https://github.com/Shougo/deoplete.nvim
[github-dein]: https://github.com/Shougo/dein.vim
[github-yata]: https://github.com/mitsuse/yata
[web-neovim]: https://neovim.io/
[web-pyyaml]: http://pyyaml.org/
