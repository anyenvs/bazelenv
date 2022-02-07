# bazelenv

[Bazel](https://github.com/bazelbuild/bazel/releases) version manager.

Inspired by and adopted from the tools below:

* [helmenv](https://github.com/yuya-takeyama/helmenv)
* [tfenv](https://github.com/Zordrak/tfenv)

## Installation

1. Add `variables` into `~/.bash_profile` or `~/.bashrc` and source the file

  ```sh
  $ echo 'export BAZELENV_ROOT=${HOME}/.bazelenv' >> ~/.bash_profile
  $ echo "export PATH=${BAZELENV_ROOT}/bin:$PATH" >> ~/.bash_profile
  $ . ~/.bash_profile
  ```

2. Check out bazelenv into any path (here is `${HOME}/.bazelenv`)
  ```sh
  $ git clone --branch=main --depth=1 https://github.com/anyenvs/bazelenv.git ${BAZELENV_ROOT}
  ```

## Usage

```
Usage: bazelenv <command> [<args>]

Some useful bazelenv commands are:
   local       Set or show the local application-specific Bazel version
   global      Set or show the global Bazel version
   install     Install the specified version of Bazel
   uninstall   Uninstall the specified version of Bazel
   version     Show the current Bazel version and its origin
   versions    List all Bazel versions available to bazelenv

See `bazelenv help <command>' for information on a specific command.
For full documentation, see: https://github.com/anyenvs/bazelenv#readme
```

## License

* bazelenv
  * The MIT License
* [helmenv](https://github.com/yuya-takeyama/helmenv)
  * The MIT License
* [tfenv](https://github.com/Zordrak/tfenv)
  * The MIT License
