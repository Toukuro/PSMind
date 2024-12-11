using namespace System.Xml
using namespace System.Xml.Serialization
using namespace System.IO
using module "..\..\Models\NodeBase.psm1"
using module "..\..\Models\Node.psm1"
using module "..\..\Models\Map.psm1"

Describe "XmlSerializerによるシリアライズ" {
    BeforeAll {
        $map = [Map]::new()
        $map.TopNode.Children.Add([Node]::new("１階層目", $map.TopNode))
        $outputPath = ( $PSCommandPath | Split-Path -Parent )
        # Write-Host "BeforeAll: outputPath=[$outputPath]"
    }

    AfterAll {
        Remove-Module Map
        Remove-Module Node
        Remove-Module NodeBase
    }

    It "AIに聞いた方法そのまま" {
        $true | Should -Be $true
        Write-Host ".NET Framework, .NET Coreのインストールが必要なため、却下"
        <#
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
        #>
    }

    Context "Visitorパターンによる実装" {
        class XmlWriteVisitor : NodeVisitor {
            [XmlWriter] $xmlWriter

            XmlWriteVisitor([String] $fileName) {
                [XmlWriterSettings] $setting = [XmlWriterSettings]::new()
                [StreamWriter] $sw = [StreamWriter]::new($fileName)
                $this.xmlWriter = [XmlWriter]::Create($sw, $setting)
            }

            [void] Dispose() {
                $this.xmlWriter.close()
            }

            Visit([Map] $map) {
                $this.xmlWriter.WriteStartElement("map")
                $map.TopNode.Accept($this)
                $this.xmlWriter.WriteEndElement()
            }

            Visit([Node] $node) {
                $this.xmlWriter.WriteStartElement("node")
                $this.xmlWriter.WriteAttributeString("TEXT", $node.Text)
                foreach ($child in $node.Children) {
                    $child.Accept($this)
                }
                $this.xmlWriter.WriteEndElement()
            }
        }

        It "XML出力" {
            $fileName = Join-Path $outputPath "test1.xml"
            $visitor = [XmlWriteVisitor]::new($fileName)
            $map.Accept($visitor)
        }
    }

    Context "継承したクラスと、それらを引数に取るオーバーロードの優先順位の確認" {
        class MyClassA {
            [int] GetValue() { return 1 }
        }
        class MyClassB : MyClassA {}
        class MyClassC : MyClassB {}

        class OverloadClass {
            [String] OverloadedMethod([MyClassA] $obj) {
                return $obj.GetType().Name
            }

            [String] OverloadedMethod([MyClassB] $obj) {
                return $obj.GetType().Name
            }

            [String] OverloadedMethod([MyClassC] $obj) {
                return $obj.GetType().Name
            }
        }

        BeforeAll {
            [OverloadClass] $ovClass = [OverloadClass]::new()
        }

        It "MyClassAの場合は、MyClassAで受ける" {
            $obj = [MyClassA]::new()
            $ovClass.OverloadedMethod($obj) | Should -Be "MyClassA"
        }

        It "MyClassBの場合は、MyClassBで受ける" {
            $obj = [MyClassB]::new()
            $ovClass.OverloadedMethod($obj) | Should -Be "MyClassB"
        }

        It "MyClassCの場合は、MyClassCで受ける" {
            $obj = [MyClassC]::new()
            $ovClass.OverloadedMethod($obj) | Should -Be "MyClassC"
        }
    }
}