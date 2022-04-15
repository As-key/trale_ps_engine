
# TRALE_ps_engine
This is a project for a translation engine and definition files that can be used in TRALE.<br>
It does not include TRALE itself.

このプロジェクトは、TRALE向けの翻訳エンジンを扱っています。<br>
TRALE本体のソースコードは含みません。
<br><br>

定義したps1/jsonファイルは、TRALE本体と同じ場所にあるengineフォルダに格納してください。</br>

### TRALE Web site :
https://trale.org/
<br><br>

# JSON File

## TRALEで呼び出すps1はJSONファイルで定義されます。
JSONファイルを構成する要素は４種類です。<br>
	
	"Info"
	"Option"
	"SourceLanguage"
	"TargetLanguage"

各要素は次の型で表現されます。<br>
	
	{
		"name": "",
		"value": "",
		"note": "",
	}

## InfoではAPIの定義を行います。
API本体(エンジンファイル本体)に対して、複数のJSONファイルを定義することで、<br>
定義ファイル毎に細かい動作条件を変更する事も可能です。<br>

	"Info": {
		"name": "DeepL API Free V2 (ps1)",  //TRALEのAPI選択リストに表示されます。
		"value": "DeepL_API_Free.ps1",  //利用するAPI本体を記載します。
		"note": "Translation using the API of DeepL free."  //TRALEのAPI説明欄に表示される説明文です。
	},
	......

## Optionでは引数を定義します。この定義は配列として複数定義可能です。
翻訳エンジンのAuth keyや、設定ファイルを指定する為に利用します。<br>
引数名、引数パラメータとして利用されますので、名称は英数字及び_で簡潔に表現してください。<br>
特殊文字を指定したい場合は、エンジンファイル本体に記述するなどしてください。<br>

	"Option": [
	{
		"name": "Auth_key",  //変数名
		"value": "",
		"note": "Set the Auth key that you obtained on the account page of DeepL."　　//変数の説明
	},
	......

## SourceLanguageとTargetLanguageには、言語に対するコードを指定します。
	SourceLanguage
	TargetLanguage

### この定義は配列で定義可能です。
	"TargetLanguage": [
		{
			"name": "bg",  //TARLE側の言語コード
			"value": "BG",  //API本体(翻訳エンジン)に渡される言語コード
			"note": "Bulgarian"
		},
	......

基本には翻訳エンジンの仕様に合わせて言語コードを定義してください。<br>
例えばDEEPLでは、<br>
英語(Source)→日本語(Target)の翻訳を行う場合、<br>
Source=EN, Target=JA 指定しますが、<br>
日本語(Source)→英語(Target)の翻訳を行う場合は、<br>
Source=JA, Target=EN-US (又はEN-GB) といった指定になります。<br>
TRALE上では、EN,EN-US,EN-GBは別々に管理されますので、<br>
全てENとして管理したい場合は次のように定義しておくと。取り扱いが簡単です。<br>

	"TargetLanguage": [
		{
			"name": "en",
			"value": "EN-US",
			"note": "English"
		},
	......
<br>

# PS1 File
翻訳エンジンなどを呼び出す実体です。<br>
<br>

## エラーコードについて

Invoke-WebRequest のリクエストエラー等のエラー情報を返却したい場合、


    Setting
        01:Application Setting
            04:Enable translation engine's error = true

とする事で、標準出力されたエラーを翻訳結果の代わりに取得する事が出来ます。<br>
(この設定はデフォルトはfalseとなっており、エラー検出時はエラーポップアップのみとなっています。)<br></br>
<br>

## 文章の受け渡しについて
実際に翻訳対象となる文章データは、BASE64エンコードされた状態でAPI本体(翻訳エンジン)に渡されます。<br>
サンプル（テンプレートファイル）では、<br>


    # BASE64エンコードされたデータをUTF8にデコード
    $Byte = [System.Convert]::FromBase64String($source_text)
    $source = [System.Text.Encoding]::UTF8.GetString($Byte)

    # UTF8のデータをBASE64エンコード
    $Byte = [System.Text.Encoding]::UTF8.GetBytes($json.translations.text)
    $Base64 = [System.Convert]::ToBase64String($Byte)

    # BASE64エンコードされたデータをTRALEに返却
    $Base64

といった実装を行っています。
