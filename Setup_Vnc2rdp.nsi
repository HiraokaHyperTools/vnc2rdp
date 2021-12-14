; example2.nsi
;
; This script is based on example1.nsi, but it remember the directory, 
; has uninstall support and (optionally) installs start menu shortcuts.
;
; It will install example2.nsi into a directory that the user selects.
;
; See install-shared.nsi for a more robust way of checking for administrator rights.
; See install-per-user.nsi for a file association example.

;--------------------------------

!define APP "vnc2rdp"
!define SERVICE "${APP}"

!system 'MySign "build-vs\Release\vnc2rdp.exe" "build-vs\getopt_mb_uni_src\Release\getopt.dll"'
!finalize 'MySign "%1"'
;SetCompress off

; The name of the installer
Name "${APP}"

; The file to write
OutFile "Setup_${APP}.exe"

; Request application privileges for Windows Vista and higher
RequestExecutionLevel admin

; Build Unicode installer
Unicode True

; The default installation directory
InstallDir "$PROGRAMFILES\${APP}"

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\${APP}" "Install_Dir"

XPStyle on

!include "LogicLib.nsh"
!include "nsDialogs.nsh"

!include "makeNsisDlg.nsh"

;--------------------------------

; Pages

Page directory
Page components
!insertmacro InsertConfigPage
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

Function .onInit
  Call LoadVars
FunctionEnd

Section
  SectionIn RO
  SetOutPath $INSTDIR
  File "/ONAME=nssm-alt.exe" "nssm\win32\nssm.exe"
SectionEnd

Section "Stop service: ${SERVICE}"
  ExecWait 'nssm-alt.exe stop "${SERVICE}"' $0
  DetailPrint "Result: $0"
SectionEnd

Section "Uninst service: ${SERVICE}"
  ExecWait 'nssm-alt.exe remove "${SERVICE}" confirm' $0
  DetailPrint "Result: $0"
SectionEnd

; The stuff to install
Section "Copy files"

  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File "build-vs\Release\vnc2rdp.exe"
  File "build-vs\getopt_mb_uni_src\Release\getopt.dll"

  File "H:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Redist\MSVC\14.16.27012\x86\Microsoft.VC141.CRT\vcruntime140.dll"
  File "C:\Program Files (x86)\Windows Kits\10\Redist\10.0.19041.0\ucrt\DLLs\x86\*.dll"

  ; Write the installation path into the registry
  WriteRegStr HKLM "SOFTWARE\${APP}" "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP}" "DisplayName" "${APP}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP}" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP}" "NoRepair" 1
  WriteUninstaller "$INSTDIR\uninstall.exe"

  Call SaveVars
  
SectionEnd

Section "Install service: ${SERVICE}"
  StrCpy $1 ""
  ${If} $NoShared <> 0
    StrCpy $1 "-n"
  ${EndIf}

  File "nssm\win32\nssm.exe"
  ExecWait 'nssm.exe install "${SERVICE}" "$INSTDIR\${APP}.exe" -l "$RdpBinding" -p "$VncPassword" $1 $VncServer' $0
  DetailPrint "Result: $0"
SectionEnd

Section "Start service: ${SERVICE}"
  ExecWait 'nssm-alt.exe start "${SERVICE}"' $0
  DetailPrint "Result: $0"
SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP}"
  DeleteRegKey HKLM "SOFTWARE\${APP}"

  ; Remove files and uninstaller
  Delete "$INSTDIR\vnc2rdp.exe"
  Delete "$INSTDIR\getopt.dll"
  Delete "$INSTDIR\uninstall.exe"

  ; Remove directories
  RMDir "$INSTDIR"

SectionEnd
