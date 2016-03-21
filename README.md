# autocomplete-swift

[![License][license-badge]][license]
[![Release][release-badge]][release]

Autocompletion for Swift in Vim, especially with [neocomplete][github-neocomplete].

![completion-gif](/_images/completion.gif)


## Requirements

Autocomplete-swift uses SourceKitten as its back-end,
and neosnippet to jump placeholders.
SourceKitten is available in OS X,
therefore this plugin supports OS X only.

- Xcode 7.x
- [SourceKitten][github-sourcekitten]
- [neosnippet][github-neosnippet]

You can use autocomplete-swift via Vim's omni-completion,
but I recommend to use with neocomplete to enable autocompletion.

- [neocomplete][github-neocomplete] (optional, but recommended)


## Usage

The completion feature of autocomplete-swift is available in several ways.

### Omni-completion

Autocomplete-swift supports Vim's omni-completion.
Completion is triggered by typing `<C-x><C-o>` near `.`, `:`, `->` etc.


### neocomplete

To enable *automatic* completion,
autocomplete-swift requires [neocomplete][github-neocomplete].


## Completion

Autocomplete-swift supports types of completion as follow:

- Type name
- Type/Instance member
- Function/method parameter
- Top-level function/constant/variable
- Keyword such as `protocol`, `extension etc.

This plugin provides completion in single file.
Frameworks/SDKs are not supported currently.


## Placeholder

This plugin supports jumping to and editing placeholders in arguments of method
([neosnippet][github-neosnippet] is required).


## TODO

- Display more information of candidate (For example, the kind of candidate etc).
- Add support for framework/SDK by communicating with [SourceKittenDaemon][github-sourcekittendaemon].
- Add support for [neovim][web-neovim].
- Add support for placeholder without [neosnippet][github-neosnippet].


## Related project

The GIF in the beginning also uses snippets for Swift contained in [neosnippet-snippets][github-neosnippet-snippets].


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
[github-neosnippet-snippets]: https://github.com/Shougo/neosnippet-snippets
[web-neovim]: https://neovim.io/
