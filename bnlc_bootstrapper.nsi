!include "MUI2.nsh"
!include "nsDialogs.nsh"
!include "LogicLib.nsh"
!include "FileFunc.nsh"
!include "x64.nsh"
!include "WinVer.nsh"

Name "BNLC Bootstrapper"
OutFile "BNLC_Bootstrapper.exe"
InstallDir "$APPDATA\SteamCMD"

VIProductVersion "1.0.0.0"
VIAddVersionKey "ProductName" "BNLC Bootstrapper"
VIAddVersionKey "FileVersion" "1.0.0.0"
VIAddVersionKey "FileDescription" "BNLC Boostrapper"
VIAddVersionKey "LegalCopyright" "© Hikari Calyx Tech"

Var USERNAME
Var PASSWORD
Var hwndUser
Var hwndPass

!define MUI_ABORTWARNING

Page Custom LoginPage LoginPageLeave
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

Function .onInit
  ${IfNot} ${AtLeastWin10}
    MessageBox MB_ICONSTOP "This bootstrapper requires Windows 10 or newer."
    Abort
  ${EndIf}
FunctionEnd

Function LoginPage
    nsDialogs::Create 1018
    Pop $0

    ${NSD_CreateLabel} 0 0 100% 12u "Steam Username:"
    ${NSD_CreateText} 0 12u 100% 12u ""
    Pop $hwndUser

    ${NSD_CreateLabel} 0 30u 100% 12u "Steam Password:"
    ${NSD_CreatePassword} 0 42u 100% 12u ""
    Pop $hwndPass

    ${NSD_CreateLabel} 0 65u 100% 48u \
        "Your login credentials will only be saved on your device, and will only be sent to Valve.$\r$\n$\r$\nWe strongly recommend you to turn on Steam Guard.$\r$\n$\r$\nDuring installation, please allow login request on Steam Mobile App when you're asked to do so."
    Pop $1

    nsDialogs::Show
FunctionEnd

Function LoginPageLeave
    ${NSD_GetText} $hwndUser $USERNAME
    ${NSD_GetText} $hwndPass $PASSWORD

    ${If} $USERNAME == ""
        MessageBox MB_ICONEXCLAMATION "Please enter a username."
        Abort
    ${EndIf}

    ${If} $PASSWORD == ""
        MessageBox MB_ICONEXCLAMATION "Please enter a password."
        Abort
    ${EndIf}
FunctionEnd

Section "Main"
    SetOutPath "$INSTDIR"

    StrCpy $0 "$TEMP\game_download.txt"
    FileOpen $1 $0 w

    FileWrite $1 "@ShutdownOnFailedCommand 1$\r$\n"
    FileWrite $1 "@NoPromptForPassword 0$\r$\n"
    FileWrite $1 "login $USERNAME $PASSWORD$\r$\n"
    FileWrite $1 "app_update 1798010 validate$\r$\n"
    FileWrite $1 "app_update 1798020 validate$\r$\n"
    FileWrite $1 "quit$\r$\n"

    FileClose $1

    SetOutPath "$APPDATA\SteamCMD"
    File "steamcmd.exe"
    Pop $3

    ${If} ${RunningX64}
        ReadRegStr $4 HKLM "Software\Wow6432Node\Valve\Steam" "InstallPath"
        ${If} $4 == ""
            WriteRegStr HKLM "Software\Wow6432Node\Valve\Steam" "InstallPath" "$APPDATA\SteamCMD"
        ${EndIf}
    ${Else}
        ReadRegStr $4 HKLM "Software\Valve\Steam" "InstallPath"
        ${If} $4 == ""
            WriteRegStr HKLM "Software\Valve\Steam" "InstallPath" "$APPDATA\SteamCMD"
        ${EndIf}
    ${EndIf}
    
    ExecShell "open" "cmd.exe" '/k "$APPDATA\SteamCMD\steamcmd.exe +runscript \"$TEMP\game_download.txt\""' SW_SHOWNORMAL

SectionEnd
