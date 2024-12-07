using namespace System.Xml
using namespace System.Xml.Serialization
using namespace System.IO
using module "..\..\Models\Node.psm1"
using module "..\..\Models\Map.psm1"

Describe "XmlSerializerによるシリアライズ" {
    BeforeAll {
        $map = [Map]::new()
        $map.TopNode.Children.Add([Node]::new("１階層目", $map.TopNode))
        $outputPath = ( $PSCommandPath | Split-Path -Parent )
        # Write-Host "BeforeAll: outputPath=[$outputPath]"
    }

    It "AIに聞いた方法そのまま" {
        $source =
@"
    using System;
    using System.Xml;
    using System.Xml.Serialization;
    using System.IO;

    public class Person
    {
        [XmlElement(ElementName = "FullName")]
        public string Name { get; set; }

        [XmlAttribute(AttributeName = "PersonAge")]
        public int Age { get; set; }
    }
"@

        Add-Type -TypeDefinition $source -Language CSharp

        # Personクラスのインスタンスを作成
        $person = New-Object Person
        $person.Name = "John Doe"
        $person.Age = 30

        # XmlSerializerを使用してオブジェクトをXMLにシリアライズ
        $serializer = New-Object System.Xml.Serialization.XmlSerializer([Person])
        $stream = [System.IO.StringWriter]::new()
        $serializer.Serialize($stream, $person)

        # シリアライズされたXMLを取得
        Write-host $stream.ToString()
    }

<#
    Context "コマンドレットを使用した場合" {
        $fileName = Join-Path $outputPath 'Map2.xml'
        $map | ConvertTo-Xml > $fileName
    }
#>
}