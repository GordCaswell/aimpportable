${SegmentFile}

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
