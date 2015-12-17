!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\Data\settings\*.*"
		CreateDirectory "$INSTDIR\Data\Recorded"
	${EndIf}
	${If} ${FileExists} "$INSTDIR\Data\Profile\AIMP3.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${If} $0 == "3.10.1074.2"
			WriteINIStr "$INSTDIR\Data\Profile\AIMP3.ini" "PlsSettings" "SaveAbsoluteFileNames" "0"
		${EndIf}
	${EndIf}
!macroend