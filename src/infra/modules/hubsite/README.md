# Requirements

* VPN Gateway SKU needs to be set to 'HighPerformance'
* VPN Gateway needs to be set to `active_active = true` when used in combination with Azure RouteServer
* VPN Gateway in active-active mode needs two `ip_configuration` blocks.