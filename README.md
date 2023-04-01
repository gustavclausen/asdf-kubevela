<div align="center">

# asdf-kubevela [![Build](https://github.com/gustavclausen/asdf-kubevela/actions/workflows/build.yml/badge.svg)](https://github.com/gustavclausen/asdf-kubevela/actions/workflows/build.yml) [![Lint](https://github.com/gustavclausen/asdf-kubevela/actions/workflows/lint.yml/badge.svg)](https://github.com/gustavclausen/asdf-kubevela/actions/workflows/lint.yml)

[kubevela](https://kubevela.io/docs) plugin for the
[asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add kubevela
# or
asdf plugin add kubevela https://github.com/gustavclausen/asdf-kubevela.git
```

kubevela:

```shell
# Show all installable versions
asdf list-all kubevela

# Install specific version
asdf install kubevela latest

# Set a version globally (on your ~/.tool-versions file)
asdf global kubevela latest

# Now kubevela commands are available
vela version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on
how to install & manage versions.

# Contributing

Contributions of any kind welcome! See the
[contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/gustavclausen/asdf-kubevela/graphs/contributors)!

# License

See [LICENSE](LICENSE) ©
[Gustav Kofoed Clausen](https://github.com/gustavclausen/)
