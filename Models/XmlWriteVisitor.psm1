using namespace System.Xml
using namespace System.Text

using module ".\NodeBase.psm1"
using module ".\Node.psm1"
using module ".\Map.psm1"

class XmlWriteVisitor : NodeVisitor {
    [XmlWriter] $xmlWriter
    [String] $AppVersion

    XmlWriteVisitor([String] $fileName, [String] $appVersion) {
        $this.AppVersion = $appVersion
        [XmlWriterSettings] $settings = [XmlWriterSettings]::new()
        $settings.Encoding = [UTF8Encoding]::new($false)
        $settings.OmitXmlDeclaration = $true
        $settings.Indent = $true
        $this.XmlWriter = [XmlWriter]::Create($fileName, $settings)
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
