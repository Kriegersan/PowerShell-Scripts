$vm = read-host "enter VM to upgrade"

function Upgd-Hdwr($vm){
  $spec = New-Object -TypeName VMware.Vim.VirtualMachineConfigSpec
  $spec.ScheduledHardwareUpgradeInfo = New-Object -TypeName VMware.Vim.ScheduledHardwareUpgradeInfo
  $spec.ScheduledHardwareUpgradeInfo.UpgradePolicy = "onSoftPowerOff"
  $spec.ScheduledHardwareUpgradeInfo.VersionKey = "vmx-11"
  $vm.ExtensionData.ReconfigVM_Task($spec)
}

Upgd-Hdwr($vm)
