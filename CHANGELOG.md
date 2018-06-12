## v0.12.0

- Present the return type of function, method and variable on the completion window.


## v0.11.1

- Recover from degrading on handling placeholders.


## v0.11.0

- Add support for completion on SPM-based project.


## v0.10.0

- Improve presentation of candidates:
    - Use `descriptionKey` for the abbreviation of candidate to present the signature of function.
    - Present the kind of candidate.


## v0.9.0

- Add support for switching the version of Swift.
- Drop experimental support for Xcode project because of the issue on completion server.
- Drop support for Vim.


## v0.8.0

- Support completion for whole parameters of initializer, method and function with `(`.


## v0.7.1

- Fix: Filter new-line characters in complesion candidate, especially in method definition.
- Fix: Avoid conversion of placeholders to neosnippet-style when neosnippet is disabled.
