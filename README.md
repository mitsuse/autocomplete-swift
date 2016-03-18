# autocomplete-swift

[![License][license-badge]][license]
[![Release][release-badge]][release]

Autocompletion for Swift in Vim, especially with [neocomplete][github-neocomplete].

![completion-gif](/_images/completion.gif)


## Requirements

- [SourceKitten][github-sourcekitten]
- [neosnippet][github-neosnippet]
- [neocomplete][github-neocomplete] (optional, but recommended)


## Usage

### Autocomplete with neocomplete (recommended)

By combining [neocomplete][github-neocomplete] with this,
autocompletion feature is enabled triggered by typing characters.


### Omni completion

Vim's omni completion is supported.
Please type `<C-x><C-o>` in insert mode near `.`, `:`, `->` etc.


## Completion

Autocomplete-swift supports types of completion as follow:

- Type name
- Type/Instance member
- Function/method parameter
- Top-level function/constant/variable

This plugin provides completion in single file.
Frameworks/SDKs are not supported currently.


## Placeholder

This plugin supports for jumping to and editing placeholders in arguments of method
([neosnippet][github-neosnippet] is required).


## TODO

- Display more information of candidate (For example, the kind of candidate etc).
- Add support for framework/SDK by communicating with [SourceKittenDaemon][github-sourcekittendaemon].
- Add support for [neovim][web-neovim].


## License

Please read [LICENSE][license].

[license-badge]: https://img.shields.io/badge/license-MIT-yellowgreen.svg?style=flat-square
[license]: LICENSE
[release-badge]: https://img.shields.io/github/tag/mitsuse/neocomplete-swift.svg?style=flat-square
[release]: https://github.com/mitsuse/neocomplete-swift/releases
[github-sourcekitten]: https://github.com/jpsim/SourceKitten
[github-sourcekittendaemon]: https://github.com/terhechte/SourceKittenDaemon
[github-neocomplete]: https://github.com/Shougo/neocomplete.vim
[github-neosnippet]: https://github.com/Shougo/neosnippet.vim
[web-neovim]: https://neovim.io/
