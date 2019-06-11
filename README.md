
The repository which contains:

* Personal config (home/)
* My essential tools to self-build (src/)
* The `config` script to manipulate above

```
Usage: config COMMAND ARGS

COMMAND

  init
    same as make-symlinks, upgrade-all

  upgrade-all
    upgrade all packages *except skip=true package* under src directory

  upgrade <pkg>
    same as running update, build, package to <pkg>

  update <pkg>
    update repository (e.g. git pull)

  build <pkg>
    build <pkg> (e.g. ./configure && make)

  package <pkg>
    package <pkg> (e.g. make install)

  make-symlinks
    make symlinks from home/ to ~/

  rm-symlinks
    remove symlinks from ~/
```
