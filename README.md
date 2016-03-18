# autocomplete-swift

[![License][license-badge]][license]
[![Release][release-badge]][release]

Autocompletion for Swift in Vim with [neocomplete][github-neocomplete]

![completion-gif](/_images/completion.gif)


## Requirements

- [SourceKitten][github-sourcekitten]
- [neosnippet][github-neosnippet]
- [neocomplete][github-neocomplete] (recommended)


## Usage

### Autocomplete with neocomplete (recommended)

By installing [neocomplete][github-neocomplete] and combining it with autocomplete-swift,
autocompletion feature is enabled triggered by typing characters.


### Omni completion

Start completion by type `<C-x><C-o>` in insert mode near `.`, `:`, `->` etc.


## Completion

- Type name
- Type/Instance member
- Function/method parameter
- Top-level function/constant/variable
- Jump to and edit placeholders by using [neosnippet][github-neosnippet].

This plugin provides completion in single file.
Frameworks/SDKs are not supported currently.


## Placeholder

This plugin supports for jumping to and editing placeholders ([neosnippet][github-neosnippet] is required).


## TODO

- Display more information of candidate (For example, the kind of candidate etc).
- Add support for framework/SDK.


## License

Please read [LICENSE][license].

[license-badge]: https://img.shields.io/badge/license-MIT-yellowgreen.svg?style=flat-square
[license]: LICENSE
[release-badge]: https://img.shields.io/github/tag/mitsuse/neocomplete-swift.svg?style=flat-square
[release]: https://github.com/mitsuse/neocomplete-swift/releases
[github-sourcekitten]: https://github.com/jpsim/SourceKitten
[github-neocomplete]: https://github.com/Shougo/neocomplete.vim
[github-neosnippet]: https://github.com/Shougo/neosnippet.vim
