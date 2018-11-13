#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=networkmapper.ico
#AutoIt3Wrapper_Outfile=padua-domain-login-x32.exe
#AutoIt3Wrapper_Outfile_x64=padua-domain-login-x64.exe
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Comment=This version is for St. Anthony Catholic Church only.
#AutoIt3Wrapper_Res_Description=Use this utility to logon to your windows domain.
#AutoIt3Wrapper_Res_Fileversion=0.1.0.0
#AutoIt3Wrapper_Res_ProductName=Domain Login Utility
#AutoIt3Wrapper_Res_ProductVersion=0.1.0
#AutoIt3Wrapper_Res_CompanyName=FringeTek
#AutoIt3Wrapper_Res_LegalCopyright=FringeTek
#AutoIt3Wrapper_Res_LegalTradeMarks=FringeTek
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Field=Author|Richard Shebora
#AutoIt3Wrapper_Res_Icon_Add=C:\bin\padua\networkmapper.ico
#AutoIt3Wrapper_Res_File_Add=C:\bin\padua\banner.gif
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

#Region ### START Koda GUI section ### Form=\\server\netlogon\autoitscripts\domain\padua-domain-login.kxf
Global $FormDomainLogin = GUICreate("Domain Login", 361, 251, -1, -1)
Global $Banner = GUICtrlCreatePic("\\server\netlogon\padua\banner.gif", 0, 0, 360, 70)
GUICtrlSetTip(-1, "St. Anthony of Padua Catholic Church (support@stanthonyparish.org)")
Global $username = GUICtrlCreateInput("", 140, 112, 120, 21)
GUICtrlSetTip(-1, "This is your network login name. Usually your first initial and last name together.")
Global $password = GUICtrlCreateInput("", 140, 140, 120, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_PASSWORD))
GUICtrlSetTip(-1, "The password associated with your username entered above.")
Global $LabelUsername = GUICtrlCreateLabel("Username:", 75, 115, 55, 17)
Global $LabelPassword = GUICtrlCreateLabel("Password:", 75, 142, 53, 17)
Global $ButtonSave = GUICtrlCreateButton("Save", 272, 112, 40, 22)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetTip(-1, "Save your username for the next time you login.")
Global $ButtonLogin = GUICtrlCreateButton("Login", 73, 190, 48, 22)
GUICtrlSetTip(-1, "Click this button to login to your network drives.")
Global $ButtonDisconnect = GUICtrlCreateButton("Disconnect", 147, 190, 72, 22)
GUICtrlSetTip(-1, "Disconnect from network drives but stay logged-in to your desktop.")
Global $ButtonCancel = GUICtrlCreateButton("Cancel", 246, 190, 48, 22)
GUICtrlSetTip(-1, "Do nothing and close this window.")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

#Region ### Login Variables
Global $SCRIPTNAME = "Network Login Script"
Global $DOMAIN = "PADUA"
Global $RET2   = @CRLF&@CRLF
Global $BANNER = "St. Anthony of Padua Catholic Church" & $RET2 & "Network Drive Mapper" & @CRLF & "support@stanthonyparish.org" & $RET2
#EndRegion ### END Login Variables ###

#Region ### Devices Array
Global $MappedDevices[7][4] = [ ['H:','server'  ,''                  ,''], _
							    ['O:','w2k3-pds','Parish'            ,''], _
								['P:','w2k3-dbs','PublicStaff'       ,''], _
								['Q:','w2k3-qbs','Accounting'        ,''], _
								['R:','w2k3-dbs','ReligiousEducation',''], _
								['S:','w2k3-dbs','HumanResources'    ,''], _
								['X:','w2k3-dbs','Binary'            ,''] ]
#EndRegion ### END Devices Array ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $ButtonSave
			Exit
		Case $ButtonLogin
			Global $user = GUICtrlRead($username)
			Global $passwd = GUICtrlRead($password)
			If $user <> "" Then
				DriveDel()
				Sleep(2000)
				$MappedDevices[0][2] = $user&"\Documents"
				For $Y = 0 to 6 Step 1
					$DRIVE = $MappedDevices[$Y][0]
					$SERVER = '\\'&$MappedDevices[$Y][1]&'\'&$MappedDevices[$Y][2]
					$DOMAIN = $DOMAIN&"\"
					DriveAdd($DRIVE,$SERVER,$DOMAIN,$user,$passwd,$RET2)
				Next
			Else
				MsgBox(0, "Failure", "FAILED!" & $RET2 & "You must enter a Username!")
			EndIf
		Case $ButtonDisconnect
			DriveDel()
		Case $ButtonCancel
			Exit
	EndSwitch
WEnd

Func DriveDel()
	For $Y = 0 to 6 Step 1
		DriveMapDel($MappedDevices[$Y][0])
	Next
EndFunc

Func DriveAdd($DRIVE,$SERVER,$DOMAIN,$user,$passwd,$RET2)
   DriveMapAdd($DRIVE,$SERVER,0,$user,$passwd)
   Local $ERRORMSG = $DRIVE &$RET2& "Error Code: " & @error &@CRLF& "Extended Error Code: " & @extended &@CRLF& "Please contact your IT Support"
   If @extended = 53 Then
	   MsgBox(0, "Failure", "FAILED!" & $RET2 & "Invalid Remote UNC for " & $ERRORMSG)
	   Return
   ElseIf @extended = 1219 Then
	   MsgBox(0, "Failure", "FAILED!" & $RET2 & "Bad username or password for " & $ERRORMSG)
	   Return
   ElseIf @extended = 1326 Then
	   MsgBox(0, "Failure", "FAILED!" & $RET2 & "?Bad username or password for " & $ERRORMSG)
	   Return
   ElseIf @extended = 2202 Then
	   MsgBox(0, "Failure", "FAILED!" & $RET2 & "Cannot leave username and password blank for " & $ERRORMSG)
	   Return
   ElseIf @extended = 2250 Then
	   MsgBox(0, "Failure", "FAILED!" & $RET2 & "Access is Denied " & $ERRORMSG)
	   Return
   ElseIf @error = 1 Then
	  MsgBox(0, "Failure", "FAILED!" & $RET2 & "Failed to Connect to " & $ERRORMSG)
	   Return
   ElseIf @error = 2 Then
	  MsgBox(0, "Failure", "FAILED!" & $RET2 & "Access Denied " & $ERRORMSG)
	   Return
   ElseIf @error = 3 Then
	  MsgBox(0, "Failure", "FAILED!" & $RET2 & "Already Assigned " & $ERRORMSG)
	   Return
   ElseIf @error = 4 Then
	  MsgBox(0, "Failure", "FAILED!" & $RET2 & "Invalid Device Name " & $ERRORMSG)
	   Return
   ElseIf @error = 5 Then
	  MsgBox(0, "Failure", "FAILED!" & $RET2 & "Invalid Remote Share " & $ERRORMSG)
	   Return
   ElseIf @error = 6 Then
	  MsgBox(0, "Failure", "FAILED!" & $RET2 & "Invalid Password" & $ERRORMSG)
	   Return
   EndIf
   If DriveStatus($DRIVE) <> "READY" Then
	  DriveMapDel($DRIVE)
   EndIf
EndFunc
