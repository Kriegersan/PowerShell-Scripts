 Function ConvertTo-GBPEuro

{

param ([int]$Pounds)

 

$Currency = New-WebServiceProxy -Uri http://www.webservicex.net/CurrencyConvertor.asmx?WSDL

$GBPEURConversionRate = $Currency.ConversionRate('GBP','EUR')

$Euros = $Pounds * $GBPEURConversionRate

Write-Host “$Pounds British Pounds convert to $Euros Euros”

}

 

Function ConvertTo-EuroGBP

{

param ([int]$Euros)

 

$Currency = New-WebServiceProxy -Uri http://www.webservicex.net/CurrencyConvertor.asmx?WSDL

$EURGBPConversionRate = $Currency.ConversionRate('EUR','GBP')

$Pounds = $Euros * $EURGBPConversionRate

Write-Host “$Euros Euros convert to $Pounds British Pounds”

}

 

Function ConvertTo-GBPUSD

{

param ([int]$Pounds)

 

$Currency = New-WebServiceProxy -Uri http://www.webservicex.net/CurrencyConvertor.asmx?WSDL

$GBPUSDConversionRate = $Currency.ConversionRate('GBP','USD')

$USD = $Pounds * $GBPUSDConversionRate

Write-Host “$Pounds British Pounds convert to $USD US Dollars”

}

 

Function ConvertTo-USDGBP

{

param ([int]$USD)

 

$Currency = New-WebServiceProxy -Uri http://www.webservicex.net/CurrencyConvertor.asmx?WSDL

$USDGBPConversionRate = $Currency.ConversionRate('USD','GBP')

$Pounds = $USD * $USDGBPConversionRate

Write-Host “$USD US Dollars convert to $Pounds British Pounds”

}