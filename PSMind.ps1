using module PSLogger
using module ".\Models\PSMindModel.psm1"
using module ".\Forms\PSMindForm.psm1"

# get logger and set loglevel
[PSLogger] $logger = [PSLogger]::GetLogger()
$logger.LogLevel = [PSLogLevel]::Debug

# output start message
$logger.WriteInfo("PSMind Started.")

# todo: create PSMindModel
$model = [PSMindModel]::new()
$logger.WriteInfo("  current version $($model.Version)")
# todo: create PSMindForm
$form = [PSMindForm]::new($model)

# todo: show PSMindForm
$form.Form.ShowDialog()

# output terminate message
$logger.WriteInfo("PSMind Terminated.")