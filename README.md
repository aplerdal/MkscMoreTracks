# MkscMoreTracks
An asm hack of mksc to add more tracks.

IPS patches will be published in the releases tab when the hack works.
https://github.com/aplerdal/MkscMoreTracks/releases

## Building
You will a mksc rom named `mksc.gba` in the same folder as the code. Then, if you are windows you can drag the `MoreTracks.s` file onto `armips.exe` in file explorer to generate `MoreTracks.gba`.

If you are on linux you will have to build armips yourself. The repository is https://github.com/Kingcom/armips . Once you build, you can run
```sh
armips MoreTracks.s
```
to build `MoreTracks.gba`.

If you need help with building message `antimattur` on discord.
