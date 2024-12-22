using System.Xml;
using System.Xml.Serialization;

[XmlElement()]
class Node {
    public Node Parent {get;}
    public List<Node> Children {get;}
    public string Text {get; set;}
    Node(string text, Node parent) {
        Text = text;
        Parent = parent;
        Children = new List<Node>();
    }

    Node(string text) {
        Node(text, null)
    }
}

[XmlRoot()]
class Map {
    public Node TopNode {get;}

    Map() {
        TopNode = new Node("トップノード");
    }
}