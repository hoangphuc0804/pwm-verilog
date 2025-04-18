# PWM Controller in Verilog
## Synthesized and implemented on Arty Z7-20 with a 125MHz clock, the PWM controller has:
Four buttons with 10ms debounce time, two for increasing and decreasing duty cycle, two for increasing and decreasing switching frequency

The duty cycle resolution is 8 bits, or equivalently 256 levels, from 0% to 100%

The switching frequency resolution is 8 bits, or equivalently 256 levels, from 953.6743164Hz to 244.1406250kHz

## Configure button debounce time
The parameter `n` is given by:
```math
n = \frac{f_{clock}}{2 \cdot f_{debounce}} - 1
```
For example, my clock frequency is 125MHz, and I need a 10ms button debounce time, or equivalently 100Hz, then my parameter `n` is:
```math
n = \frac{125 \cdot 10^{6}}{2 \cdot 100} - 1 = 624999
```

## Configure duty cycle resolution
The parameter `duty_size` is the resolution of the duty cycle

For example, if `duty_size = 8`, then the duty cycle resolution is 8 bits

Some constants related to duty cycle resolution should also be configured, I did not use Verilog math functions instead because it might not be synthesizable

## Configure switching frequency resolution
The parameter `cycl_size` is the resolution of the switching frequency

For example, if `cycl_size = 8`, then the switching frequency resolution is 8 bits

Some constants related to switching frequency resolution should also be configured, I did not use Verilog math functions instead because it might not be synthesizable
