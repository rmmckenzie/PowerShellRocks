$d = Import-CSV $csvImportRootPath\$csvFileName -Header "First Name [Required]", "Last Name [Required]", "Email Address [Required]", "Org Unit Path [Required]" | Select -skip 1

foreach($school in $d){
    $ou = $school."Org Unit Path [Required]"
    $ou
}