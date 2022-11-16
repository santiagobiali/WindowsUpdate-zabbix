$AllObjects = new-object PSCustomObject
$AllUpdates = 'Updates', 'Security Updates', 'Update Rollups', 'Feature Packs'

$AllUpdates | ForEach {
	Add-Member -InputObject $AllObjects -MemberType NoteProperty -Name "$($_ -replace ' ','')" -Value 0
}

$update = new-object -com Microsoft.update.Session
$searcher = $update.CreateUpdateSearcher()
$pending = $searcher.Search("IsInstalled=0")

foreach($entry in $pending.Updates) {
    foreach($category in $entry.Categories) {
		if ($category.name -in $AllUpdates) {
			$AllObjects."$($category.name -replace ' ','')"++
		}
	}
}

convertto-json $AllObjects
