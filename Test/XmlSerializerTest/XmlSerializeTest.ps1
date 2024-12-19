using namespace System.Xml
using namespace System.Xml.Serialization
using namespace System.IO
using namespace System.Text
using module PSLogger

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

    Context "XmlTextReader��Builder�p�^�[���œǍ��ޕ��@�̊m�F" {
        It "XmlTextReader�̓���m�F" {
            $fileName = Join-Path $outputPath "Map2.xml"
            $xmlReader = [XmlTextReader]::new($fileName)
            while ($xmlReader.Read()) {
                switch ($xmlReader.NodeType) {
                    ([XmlNodeType]::Element) {
                        Write-Host "Element:" $xmlReader.Name ", isEmptyElement:" $xmlReader.IsEmptyElement
                        while ($xmlReader.MoveToNextAttribute()) {
                            if ($xmlReader.NodeType -eq [XmlNodeType]::Attribute) {
                                Write-Host "  Attribute:" $xmlReader.Name ", Value:" $xmlReader.Value
                            }
                        }
                    }
                    ([XmlNodeType]::EndElement) {
                        Write-Host "EndElement:" $xmlReader.Name
                    }
                }
            }
            $xmlReader.Close()
        }

        class MapBuilder {
            [Map] $Map = $null
            [Node] $CurrentNode = $null
            [PSLogger] $Logger

            MapBuilder() {
                $this.Logger = [PSLogger]::new()
                $this.Logger.LogLevel = [PSLogLevel]::Debug
            }
            [void] CreateMap([String] $version) {
                $this.Logger.WriteDebug("CreateMap: occured")
                $this.Map = [Map]::new()
                $this.Map.TopNode = $null
            }

            [void] CreateNode([String] $text) {
                $this.Logger.WriteDebug("CreateNode: occured")
                if ($null -eq $this.CurrentNode) {
                    $this.Logger.WriteDebug("CreateNode: 1st Node Created.")
                    $newNode = [Node]::new($text)
                }
                else {
                    $this.Logger.WriteDebug("CreateNode: Node Created.")
                    $newNode = [Node]::new($text, $this.CurrentNode.Parent)
                    if ($null -ne $this.CurrentNode.Parent) {
                        $this.CurrentNode.Parent.Children.Add($newNode)
                    }
                }
                $this.CurrentNode = $newNode
                if ($null -eq $this.Map.TopNode) {
                    $this.Logger.WriteDebug("CreateNode: Set TopNode")
                    $this.Map.TopNode = $this.CurrentNode
                }
            }

            [void]CreateChildNode([String] $text) {
                $this.Logger.WriteDebug("CreateChildNode: occured")
                if ($null -eq $this.CurrentNode) {
                    $this.Logger.WriteDebug("CreateChildNode: CurrentNode is NUL")
                    return
                }
                $newNode = [Node]::new($text, $this.CurrentNode)
                $this.CurrentNode.Children.Add($newNode)
                $this.CurrentNode = $newNode
            }

            [void]MoveParent() {
                $this.Logger.WriteDebug("MoveParent: occured")
                if ($null -ne $this.CurrentNode.Parent) {
                    $this.Logger.WriteDebug("MoveParent: Move to Parent")
                    $this.CurrentNode = $this.CurrentNode.Parent
                }
            }
        }

        class NodeDirector {
            [MapBuilder] $builder

            NodeDirector([MapBuilder] $builder) {
                $this.builder = $builder
            }

            [Map] Construct($fileName) {
                [XmlTextReader] $xmlReader = [XmlTextReader]::new($fileName)
                [bool] $isEmptyElement = $true
                [bool] $isEmptyPrevElement = $true

                while ($xmlReader.Read()) {
                    switch ($xmlReader.NodeType) {
                        ([XmlNodeType]::Element) {
                            switch ($xmlReader.Name) {
                                ("map") {
                                    [Hashtable] $attributes = $this.ReadAttributes($xmlReader)
                                    $this.builder.CreateMap($attributes['version'])
                                }
                                ("node") {
                                    $isEmptyPrevElement = $isEmptyElement
                                    $isEmptyElement = $xmlReader.IsEmptyElement
                                    Write-Host "isEmptyPrevElement: $isEmptyPrevElement , isEmptyElement: $isEmptyElement"
                                    $this.InstructToCreateNode($xmlReader, !$isEmptyPrevElement)
                                }
                            }
                        }
                        ([XmlNodeType]::EndElement) {
                            if ("node" -eq $xmlReader.Name) {
                                $this.builder.MoveParent()
                            }
                        }
                    }
                }
                $xmlReader.Close()
                return $this.builder.Map
            }

            InstructToCreateNode([XmlTextReader] $reader, [bool] $asChildElement) {
                [Hashtable] $attributes = $this.ReadAttributes($reader)
                if ($true -eq $asChildElement) {
                    $this.builder.CreateChildNode($attributes['TEXT'])
                } else {
                    $this.builder.CreateNode($attributes['TEXT'])
                }
            }

            [Hashtable] ReadAttributes([XmlTextReader] $reader) {
                [Hashtable] $attributes = [Hashtable]::new()
                while ($reader.MoveToNextAttribute()) {
                    if ($reader.NodeType -eq [XmlNodeType]::Attribute) {
                        $attributes.Add($reader.Name, $reader.Value)
                    }
                }
                return $attributes
            }
        }
        It "Bulder�p�^�[���ɂ��XML�Ǎ��̊m�F" {
            $fileName = Join-Path $outputPath "Map2.xml"
            $builder = [MapBuilder]::new()
            $director = [NodeDirector]::new($builder)
            [Map] $map = $director.Construct($fileName)

            $map.TopNode | Should -Not -BeNullOrEmpty
            $map.TopNode.Text | Should -Be "�V�K�}�C���h�}�b�v"
            $map.TopNode.Children.Count | Should -Be 1
            $map.TopNode.Children[0].Text | Should -Be "�P�K�w��"
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