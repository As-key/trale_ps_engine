Param(
  [String]$source_language = "",
  [String]$target_language = "",
  [String]$source_text = "",
  [String]$auth_key = "",
  [String]$region = ""
  )
If ($source_language -eq $target_language){
  $source
  return
}

###
# Usually the character encoding of the arguments is UTF8.
# The strings to be translated (both in and out) are BASE64 encoded.
# The value returned to TRALE should also be BASE64 encoded.+
#

$Byte = [System.Convert]::FromBase64String($source_text)
$source = [System.Text.Encoding]::UTF8.GetString($Byte)

$endpoint = 'https://api.cognitive.microsofttranslator.com'

$path = '/translate?api-version=3.0'
$params = '&from=' + $source_language + '&to=' + $target_language
$constructed_url = $endpoint + $path + $params

$headers = @{}
$headers.Add("Ocp-Apim-Subscription-Key",$auth_key)
$headers.Add("Content-Type","application/json")
$headers.Add("Ocp-Apim-Subscription-Region",$region)

$Byte = [System.Text.Encoding]::UTF8.GetBytes("[{'Text':'$($source)'}]")
$ret = Invoke-WebRequest -Uri $constructed_url -Headers $headers -Body $Byte -Method Post 

$json = ConvertFrom-Json $([System.Text.Encoding]::UTF8.GetString( [System.Text.Encoding]::GetEncoding("ISO-8859-1").GetBytes($ret.Content)))

$Byte = [System.Text.Encoding]::UTF8.GetBytes($json.translations.text)
$Base64 = [System.Convert]::ToBase64String($Byte)
$Base64
