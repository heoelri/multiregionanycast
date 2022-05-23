# Anycast Routing Examle

## TODO

* VPN Connectivity
* Client VM
* Deploy Mission-Critical Connected
* Deploy Router as VMSS for zone-redundancy

## Considerations

* VPN Gateway deployment can take a while - up to 40mins

## Requirements

* VPN Gateway SKU needs to be set to 'HighPerformance'
* VPN Gateway needs to be set to `active_active = true` when used in combination with Azure RouteServer
* ActiveActive VPN Gateway must be created with two IP configurations.
