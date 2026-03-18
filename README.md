# BNLC Bootstrapper
A simple bootstrapper designed for Downloading BNLC on Winlator, for users without a PC.

To learn more, visit: https://github.com/HikariCalyx/trill/wiki/Bootstrapper

## Why create this?
We understand some users may not have access to PC for downloading BNLC, and original Steam does not run well and prone to crash on Winlator - even if you use Steamlator.

## Is it safe to use?
- Other than NSIS, the only additional program we use is official SteamCMD binary. You can find the digital signature of Valve from SteamCMD binary.
- You can review the source code from this repository, and build yourself to comply your need.
- Despite that, it's strongly recommended to enable Steam Guard on Steam Mobile App.
- If you're paranoid enough that you even don't trust NSIS, we also provide manual method.

## Build
1. Download and install NSIS depends on your OS.
2. Download SteamCMD for Windows from here: https://developer.valvesoftware.com/wiki/SteamCMD
3. Clone this repository.
4. Put steamcmd.exe at same directory of given nsi file.
5. Build it with this command:
```bash
makensis bnlc_installer.nsi
```
