class MapNodeException : Exception
{
    MapNodeException([string]$message) : base($message) {}
    MapNodeException([string]$message, [Exception]$innerException) : base($message, $innerException) {}
}