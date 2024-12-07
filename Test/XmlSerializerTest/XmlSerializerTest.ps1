using namespace System.Xml
using namespace System.Xml.Serialization
using namespace System.IO
using module "..\..\Models\Node.psm1"
using module "..\..\Models\Map.psm1"

Describe "XmlSerializer�ɂ��V���A���C�Y" {
    BeforeAll {
        $map = [Map]::new()
        $map.TopNode.Children.Add([Node]::new("�P�K�w��", $map.TopNode))
        $outputPath = ( $PSCommandPath | Split-Path -Parent )
        # Write-Host "BeforeAll: outputPath=[$outputPath]"
    }

    It "AI�ɕ��������@���̂܂�" {
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
    }

<#
    Context "�R�}���h���b�g���g�p�����ꍇ" {
        $fileName = Join-Path $outputPath 'Map2.xml'
        $map | ConvertTo-Xml > $fileName
    }
#>
}