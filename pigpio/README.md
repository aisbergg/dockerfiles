# PiGPIO (aisberg/pigpio)
*[PiGPIO](http://abyz.me.uk/rpi/pigpio/)* is a library for the *Raspberry Pi* which allows control of the General Purpose Input Outputs (GPIO). This is the dockerized version that runs the PiGPIO daemon inside a Docker Container.

## Build the image
Using *Docker Compose* the image can be simply build by running the following command:
```
docker-compose build
```

The equivalent `docker build` command is:
```
docker build -t aisberg/pigpio .
```

## Usage
Using *Docker Compose* the daemon can be started as follows:
```
docker-compose up -d
```

The equivalent `docker run` command is:
```
docker run -d --device "/dev/mem:/dev/mem" --device "/dev/vcio:/dev/vcio" --cap-add aisberg/pigpio [OPTIONS]
```

### Options
Options be specified by adding commands on container start. For example:
```
docker run ... aisberg/pigpio -s 10
```

Possible options are:

Options | Description | Default Value
--|---|--
`-a value` | DMA memory allocation mode (0=AUTO, 1=PMAP, 2=MBOX) | AUTO
`-b value` | GPIO sample buffer size in milliseconds (100-10000) | 120
`-c value` | Library internal settings | 0
`-d value` | Primary DMA channel (0-14) | 14
`-e value` | Secondary DMA channel (0-14) | 6
`-f` | Disable fifo interface | enabled
`-k` | Disable local and remote socket interface | enabled
`-l` | Disable remote socket interface | enabled
`-m` | Disable alerts (sampling) | enabled
`-n IP address` | Allow IP address to use the socket interface (Hostname or IPv4). If the `-n` option is not used all addresses are allowed (unless overridden by the `-k` or `-l` options). Multiple `-n` options are allowed. If `-k` has been used `-n` has no effect. If `-l` has been used only `-n` localhost has any effect
`-s value` | Sample rate (1, 2, 4, 5, 8, or 10 ms) | 5
`-t value` | Clock peripheral (0=PWM 1=PCM ). pigpio uses one or both of PCM and PWM. If PCM is used then PWM is available for audio. If PWM is used then PCM is available for audio. If waves or hardware PWM are used neither PWM nor PCM will be available for audio. | PCM
`-v -V` | Display pigpio version and exit |
`-x mask` | GPIO which may be updated (A 54 bit mask with (1\<\<n) set if the user may update GPIO #n). Use `-x -1` to allow all GPIO | Default is the set of user GPIO for the board revision.

More information can be found on the [PiGPIO Website](http://abyz.me.uk/rpi/pigpio/pigpiod.html)

## License
This project is licensed under the MIT License. See the [LICENSE](../LICENSE) file for details.
