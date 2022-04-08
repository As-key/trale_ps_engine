Param(
  [String]$source_language = "",
  [String]$target_language = "",
  [String]$source_text = "",
  [String]$auth_key = ""
  )
If ($source_language -eq $target_language){
  $source
  return
}

$Byte = [System.Convert]::FromBase64String($source_text)
$source = [System.Text.Encoding]::UTF8.GetString($Byte)

If($source_language -eq "AUTO"){
  $ret = Invoke-WebRequest -Body @{ auth_key="$($auth_key)"; text="$($source)"; target_lang="$($target_language)" } https://api.deepl.com/v2/translate
}Else{
  $ret = Invoke-WebRequest -Body @{ auth_key="$($auth_key)"; text="$($source)"; source_lang="$($source_language)"; target_lang="$($target_language)" } https://api.deepl.com/v2/translate
}

$json = ConvertFrom-Json $([System.Text.Encoding]::UTF8.GetString( [System.Text.Encoding]::GetEncoding("ISO-8859-1").GetBytes($ret.Content)))

$Byte = [System.Text.Encoding]::UTF8.GetBytes($json.translations.text)
$Base64 = [System.Convert]::ToBase64String($Byte)
$Base64
