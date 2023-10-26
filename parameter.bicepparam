using 'main.bicep'

param publicIpName = 'myPublicIP'
param OSVersion = '2022-datacenter-azure-edition'
param vmSize = 'Standard_B2s'
param vmName = 'simple-vm'
param adminUsername = 'azureuser'
//コード内に直接秘匿情報を書くのは適切ではありませんが、説明をシンプルにするため便宜上記載しています。
param adminPassword = 'SamplePass123!'
