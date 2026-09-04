# Repository Guidelines

## Dotfile management

- Use Mise's native `[dotfiles]` configuration for new dotfile mappings.
- Put cross-platform mappings in `mise.toml` and platform-specific mappings in
  the matching `mise.<os>.toml` file.
- Treat Dotter as legacy. Avoid adding new Dotter packages or mappings when
  Mise can manage the file. Keep unrelated Dotter migrations out of focused
  changes.

## Commits

- Use the Conventional Commits format for every commit subject: `type(optional-scope): concise description`.
- Include a meaningful commit body that describes what changed and why. Do not create commits with only a subject line.
- Keep each commit focused on one logical change.
