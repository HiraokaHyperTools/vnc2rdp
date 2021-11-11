; Generated by MakeNsisDlg

; Editor control variables
var         RdpBinding
var Control_RdpBinding
var         VncServer
var Control_VncServer
var         VncPassword
var Control_VncPassword
var         NoShared
var Control_NoShared

Function LoadVars
  ; RdpBinding
  ClearErrors
  ReadRegStr $RdpBinding HKLM "Software\${APP}" "RdpBinding"
  ${If} ${Errors}
  ${OrIf} $RdpBinding == ''
    StrCpy $RdpBinding "0.0.0.0:3389"
  ${EndIf}
  ; VncServer
  ClearErrors
  ReadRegStr $VncServer HKLM "Software\${APP}" "VncServer"
  ${If} ${Errors}
  ${OrIf} $VncServer == ''
    StrCpy $VncServer "127.0.0.1:5900"
  ${EndIf}
  ; VncPassword
  ClearErrors
  ReadRegStr $VncPassword HKLM "Software\${APP}" "VncPassword"
  ${If} ${Errors}
  ${OrIf} $VncPassword == ''
    StrCpy $VncPassword ""
  ${EndIf}
  ; NoShared
  ClearErrors
  ReadRegStr $NoShared HKLM "Software\${APP}" "NoShared"
  ${If} ${Errors}
  ${OrIf} $NoShared == ''
    StrCpy $NoShared "0"
  ${EndIf}
FunctionEnd

Function SaveVars
  WriteRegStr HKLM "Software\${APP}" "RdpBinding" $RdpBinding
  WriteRegStr HKLM "Software\${APP}" "VncServer" $VncServer
  WriteRegStr HKLM "Software\${APP}" "VncPassword" $VncPassword
  WriteRegStr HKLM "Software\${APP}" "NoShared" $NoShared
FunctionEnd

!macro InsertConfigPage
  Page custom ConfigPageEnter ConfigPageLeave
!macroend

Function ConfigPageEnter
  nsDialogs::Create 1018
  Pop $1

  ${If} $1 == error
    Abort
  ${EndIf}

  StrCpy $1 0

  ; RdpBinding
  ${NSD_CreateLabel}    0u "$1u" 60u 12u "RDP binding"
  Pop $0
  ${NSD_CreateText}    60u "$1u" 190u 12u "$RdpBinding"
  Pop $Control_RdpBinding
  IntOp $1 $1 + 13

  ; VncServer
  ${NSD_CreateLabel}    0u "$1u" 60u 12u "VNC server"
  Pop $0
  ${NSD_CreateText}    60u "$1u" 190u 12u "$VncServer"
  Pop $Control_VncServer
  IntOp $1 $1 + 13

  ; VncPassword
  ${NSD_CreateLabel}    0u "$1u" 60u 12u "VNC password"
  Pop $0
  ${NSD_CreateText}    60u "$1u" 190u 12u "$VncPassword"
  Pop $Control_VncPassword
  IntOp $1 $1 + 13

  ; NoShared
  ${NSD_CreateCheckBox} 60u "$1u" 190u 12u "VNC noshared"
  Pop $Control_NoShared
  StrCpy $1 ${BST_CHECKED}
  ${If} $NoShared = 0
    StrCpy $1 ${BST_UNCHECKED}
  ${EndIf}
  ${NSD_SetState} Control_$NoShared $1
  IntOp $1 $1 + 13

  nsDialogs::Show
  Pop $0
FunctionEnd

Function ConfigPageLeave
  ; RdpBinding
  ${NSD_GetText} $Control_RdpBinding $RdpBinding 
  ; VncServer
  ${NSD_GetText} $Control_VncServer $VncServer 
  ; VncPassword
  ${NSD_GetText} $Control_VncPassword $VncPassword 
  ; NoShared
  ${NSD_GetText} $Control_NoShared $NoShared 
FunctionEnd
