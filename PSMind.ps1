using module PSLogger

# set version no.
[String] $version = "0.1"

# get logger and set loglevel
[PSLogger] $logger = [PSLogger]::GetLogger()
$logger.LogLevel = [PSLogLevel]::Debug

# output start message
$logger.WriteInfo("PSMind, Version $version Started.")

# todo: create PSMindModel
# todo: create PSMindForm
# todo: show PSMindForm

# output terminate message
$logger.WriteInfo("PSMind Terminated.")