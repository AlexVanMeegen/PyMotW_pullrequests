# Mounting the filesystem of blaustein / JURECA / ...

A very handy alias to mount blaustein to `$HOME/remote`:
```
alias sshfs-blaustein="sshfs -o idmap=user a.van.meegen@blaustein.inm.kfa-juelich.de:/home/a.van.meegen $HOME/remote"
```
The same for JURECA:
```
alias sshfs-jureca="sshfs -o idmap=user vanmeegen1@judac.fz-juelich.de:/p/project/cjinb33/jinb3329 $HOME/remote"
```
To unmount any of the above:
```
alias sshfs-unmount="fusermount -u $HOME/remote"
```

# Causing conflicts
```
alias emacs="vim"
```
