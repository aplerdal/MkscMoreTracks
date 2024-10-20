# MkscMoreTracks
An asm hack of Mario Kart: Super Circuit that adds more tracks.

Not intended to be used individually. Planned for use in AdvancedEdit6

IPS patches will be published in the releases tab when the hack works.
https://github.com/aplerdal/MkscMoreTracks/releases
## Todo
- [ ] Fix tracks loading as incorrect mode (SNES rather than MKSC)
- [ ] Create documentation and better examples
## Building
You will need a mksc rom named `mksc.gba` in the same folder as the code. Then, if you are on Windows you can drag the `MoreTracks.s` file onto `armips.exe` in File Explorer to generate `MoreTracks.gba`.

If you are on linux you will have to build armips yourself. The repository can be found at https://github.com/Kingcom/armips . Once you build armips, you can run
```sh
armips MoreTracks.s
```
to build `MoreTracks.gba`.

If you need help with building message `antimattur` on discord.
