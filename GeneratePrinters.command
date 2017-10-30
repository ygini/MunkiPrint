#!/bin/bash

munki_base_folder=$(defaults read com.googlecode.munki.munkiimport repo_path)

root_folder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
source_for_printers="${root_folder}/printers"
munki_pkginfo_printers_folder="${munki_base_folder}/pkgsinfo/printers"

while read line
do
	echo "Creating printer munki file from ${line}"
	echo ""

	full_settings_path="${source_for_printers}/${line}"
	munki_name=$(/usr/libexec/PlistBuddy -c "print name" "${full_settings_path}")
	munki_version=$(/usr/libexec/PlistBuddy -c "print version" "${full_settings_path}")
	pkginfo_path="${munki_pkginfo_printers_folder}/printer_${munki_name}-${munki_version}.plist"

	"${root_folder}/printer-pkginfo/printer-pkginfo" --plist "${full_settings_path}" > "${pkginfo_path}"

done < <(ls "${source_for_printers}")

makecatalogs

exit 0
