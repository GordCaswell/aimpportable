${SegmentFile}

; ReadINIStrWithDefault 1.1 (2009-05-12)
;
; Substitutes a default value if the INI is undefined
; Copyright 2008-2009 John T. Haller of PortableApps.com
; Released under the BSD
;
; Usage: ${ReadINIStrWithDefault} OUTPUT_VALUE INI_FILENAME SECTION_NAME ENTRY_NAME DEFAULT_VALUE
;
; History:
; 1.1 (2009-05-12): Fixed error with $0 and $2 being swapped

Function ReadINIStrWithDefault
	;Start with a clean slate
	ClearErrors
	
	;Get our parameters
	Exch $0 ;DEFAULT_VALUE
	Exch
	Exch $1 ;ENTRY_NAME
	Exch 2
	Exch $2 ;SECTION_NAME
	Exch  3
	Exch $3 ;INI_FILENAME
	Push $4 ;OUTPUT_VALUE
	
	;Read from the INI
	ReadINIStr $4 $3 $2 $1
	IfErrors 0 +3
		StrCpy $4 $0
		ClearErrors

	;Keep the variable for last
	StrCpy $0 $4
	
	;Clear the stack
	Pop $4
	Pop $3
	Exch 2
	Pop $2
	Pop $1
	
	;Reset the last variable and leave our result on the stack
	Exch $0
FunctionEnd

!macro ReadINIStrWithDefault OUTPUT_VALUE INI_FILENAME SECTION_NAME ENTRY_NAME DEFAULT_VALUE
  Push `${INI_FILENAME}`
  Push `${SECTION_NAME}`
  Push `${ENTRY_NAME}`
  Push `${DEFAULT_VALUE}`
  Call ReadINIStrWithDefault
  Pop `${OUTPUT_VALUE}`
!macroend

!define ReadINIStrWithDefault '!insertmacro "ReadINIStrWithDefault"'

${SegmentInit}
	;Check for improper install/upgrade without running the PA.c Installer which can cause issues	
	${ReadINIStrWithDefault} $R0 "$EXEDIR\App\AppInfo\appinfo.ini" "Installer" "Run" "true"
	
	${If} $R0 == "false"
	${OrIf} ${FileExists} "$EXEDIR\*.version"
		;Upgrade or install sans the PortableApps.com Installer which can cause compatibility issues
		${ReadINIStrWithDefault} $0 "$EXEDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion" "0.0.0.0"
		${ReadINIStrWithDefault} $1 "$SETTINGSDIRECTORY\AIMPPortableSettings.ini" "AIMPPortableSettings" "InvalidPackageWarningShown" "0.0.0.0"
		${VersionCompare} $0 $1 $2
		${If} $2 == 1
		${OrIf} $R0 == "false"			
			MessageBox MB_OK|MB_ICONEXCLAMATION `Integrity Failure Warning: AIMP Portable was installed or upgraded without using its installer and some critical files may have been modified.  This could cause data loss, personal data left behind on a shared PC, functionality issues, and/or may be a violation of the application's license. Please visit PortableApps.com to obtain the official release of this application to install or upgrade. If you wish to use this application in its current unsupported state, please click OK to continue.`
			WriteINIStr "$SETTINGSDIRECTORY\AIMPPortableSettings.ini" "AIMPPortableSettings" "InvalidPackageWarningShown" $0
			DeleteINISec "$EXEDIR\App\AppInfo\appinfo.ini" "Installer"
		${EndIf}
	${EndIf}
!macroend

${SegmentPrePrimary}
	ExpandEnvStrings $0 "%PAL:DataDir%"
	ExpandEnvStrings $1 "%PAL:AppDir%"
	ExpandEnvStrings $4 "%PAL:LastDrive%"
	ExpandEnvStrings $5 "%PAL:Drive%"
	ExpandEnvStrings $2 "%PAL:LastPortableAppsBaseDir%"
	ExpandEnvStrings $3 "%PAL:PortableAppsBaseDir%"
	ExpandEnvStrings $6 "%PAL:LastDrive%%PAL:LastPackagePartialDir%"
	ExpandEnvStrings $7 "%PAL:Drive%%PAL:PackagePartialDir%"
	
	${WordReplace} $2 "$4\" "\" "+" $8
	${WordReplace} $3 "$5\" "\" "+" $9
	
	${If} ${FileExists} "$0\Profile\AudioLibrary\Local.db"
		${If} $6 != $7
			nsExec::Exec `"$1\Bin\sqlite3.exe" "$0\Profile\AudioLibrary\Local.db" "UPDATE mediabase SET sName = '$7' || SUBSTR(sName,(LENGTH('$6')+1)) WHERE sName LIKE '$6%';"`
		${EndIf}
		${If} $2 != $3
			nsExec::Exec `"$1\Bin\sqlite3.exe" "$0\Profile\AudioLibrary\Local.db" "UPDATE mediabase SET sName = '$3' || SUBSTR(sName,(LENGTH('$2')+1)) WHERE sName LIKE '$2%';"`
		${EndIf}
		${If} $4 != $5
			nsExec::Exec `"$1\Bin\sqlite3.exe" "$0\Profile\AudioLibrary\Local.db" "UPDATE mediabase SET sName = '$5' || SUBSTR(sName,(LENGTH('$4')+1)) WHERE sName LIKE '$4%';"`
		${EndIf}
		${If} $8 != $9
			nsExec::Exec `"$1\Bin\sqlite3.exe" "$0\Profile\AudioLibrary\Local.db" "UPDATE mediabase SET sName = '$9' || SUBSTR(sName,(LENGTH('$8')+1)) WHERE sName LIKE '$8%';"`
		${EndIf}
	${EndIf}

	;${ReadUserConfig} $0 MusicLibraryDirectory
	;${If} $0 != ""
	;	${ParseLocations} $0
	;${Else}
	;	ReadEnvStr $0 PortableApps.comMusic
	;${EndIf}
	;${IfNot} ${FileExists} $0
	;	StrCpy $0 "$CurrentDrive\"
	;${EndIf}
	;ReadINIStr $1 $DataDirectory\Profile\AIMPlib.ini ScanSettings SearchPath0
	;${If} $0 != $1
	;	WriteINIStr $DataDirectory\Profile\AIMPlib.ini ScanSettings SearchPath0 $0
	;${EndIf}
	
	;${ReadUserConfig} $0 RecordedAudioDirectory
	;${If} $0 != ""
	;  ${ParseLocations} $0
	;${Else}
	;	ReadEnvStr $0 PortableApps.comMusic
	;${EndIf}
	;${IfNot} ${FileExists} $0
	;	StrCpy $0 "$DataDirectory\AIMP Recorded\"
	;${EndIf}
	;ReadINIStr $1 $DataDirectory\Profile\AIMP.ini AIMPSoundOut CaptureDestFolder
	;${If} $0 != $1
	;	WriteINIStr $DataDirectory\Profile\AIMP.ini AIMPSoundOut CaptureDestFolder $0
	;${EndIf}
	;ReadINIStr $1 $DataDirectory\Profile\AIMPate.ini AIMPSoundOut CaptureDestFolder
	;${If} $0 != $1
	;	WriteINIStr $DataDirectory\Profile\AIMPate.ini AIMPSoundOut CaptureDestFolder $0
	;${EndIf}
	;ReadINIStr $1 $DataDirectory\Profile\AIMPlib.ini AIMPSoundOut CaptureDestFolder
	;${If} $0 != $1
	;	WriteINIStr $DataDirectory\Profile\AIMPlib.ini AIMPSoundOut CaptureDestFolder $0
	;${EndIf}
!macroend
