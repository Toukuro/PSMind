using namespace System.Xml
using namespace System.Xml.Serialization
using namespace System.IO
using namespace System.Text
using module "..\..\Models\NodeBase.psm1"
using module "..\..\Models\Node.psm1"
using module "..\..\Models\Map.psm1"

Describe "Xml�ŃV���A���C�Y������@�̊m�F" {
    BeforeAll {
        $map = [Map]::new()
        $map.TopNode.Children.Add([Node]::new("�P�K�w��", $map.TopNode))
        $outputPath = ( $PSCommandPath | Split-Path -Parent )
        # Write-Host "BeforeAll: outputPath=[$outputPath]"
    }

    AfterAll {
        #Remove-Module Map
        #Remove-Module Node
        #Remove-Module NodeBase
    }

    Context "System.Xml.XmlSerializer���g�����@" {
        It "AI�ɕ��������@���̂܂�" {
            $true | Should -Be $true
            Write-Host ".NET Framework, .NET Core�̃C���X�g�[�����K�v�Ȃ��߁A�p��"
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

            # Person�N���X�̃C���X�^���X���쐬
            $person = New-Object Person
            $person.Name = "John Doe"
            $person.Age = 30

            # XmlSerializer���g�p���ăI�u�W�F�N�g��XML�ɃV���A���C�Y
            $serializer = New-Object System.Xml.Serialization.XmlSerializer([Person])
            $stream = [System.IO.StringWriter]::new()
            $serializer.Serialize($stream, $person)

            # �V���A���C�Y���ꂽXML���擾
            Write-host $stream.ToString()
            #>
        }
    }

    Context "Visitor�p�^�[���ɂ�����" {
        class XmlWriteVisitor : NodeVisitor {
            [XmlTextWriter] $xmlWriter
            [String] $AppVersion

            XmlWriteVisitor([String] $fileName, [String] $appVersion) {
                $this.AppVersion = $appVersion
                $this.xmlWriter = [XmlTextWriter]::new($fileName, [Encoding]::UTF8)
                $this.xmlWriter.Formatting = [Formatting]::Indented
                #[XmlWriterSettings] $settings = $this.xmlWriter.Settings
                # $settings.OmitXmlDeclaration = $true
                # $settings.NewLineChars = "\n\r"
            }

            Close() {
                $this.xmlWriter.close()
            }

            Visit([Map] $map) {
                $this.xmlWriter.WriteStartElement("map")
                $this.xmlWriter.WriteAttributeString("version", "PSMind " + $this.AppVersion)
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

        It "XML�o��" {
            $fileName = Join-Path $outputPath "Map2.xml"
            $appVersion = "0.1"
            $visitor = [XmlWriteVisitor]::new($fileName, $appVersion)
            $map.Accept($visitor)
            $visitor.Close()
        }
    }

    Context "�p�������N���X�ƁA�����������Ɏ��I�[�o�[���[�h�̗D�揇�ʂ̊m�F" {
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

        It "MyClassA�̏ꍇ�́AMyClassA�Ŏ󂯂�" {
            $obj = [MyClassA]::new()
            $ovClass.OverloadedMethod($obj) | Should -Be "MyClassA"
        }

        It "MyClassB�̏ꍇ�́AMyClassB�Ŏ󂯂�" {
            $obj = [MyClassB]::new()
            $ovClass.OverloadedMethod($obj) | Should -Be "MyClassB"
        }

        It "MyClassC�̏ꍇ�́AMyClassC�Ŏ󂯂�" {
            $obj = [MyClassC]::new()
            $ovClass.OverloadedMethod($obj) | Should -Be "MyClassC"
        }
    }
}