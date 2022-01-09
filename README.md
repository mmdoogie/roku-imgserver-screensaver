# roku-imgserver-screensaver
Roku screensaver that grabs a list of image descriptions from a server, then requests and displays them.  Has auto-advanced, auto-refresh, list of images, etc.

## Tool Requirements
If you want to use the `Makefile` provided, it uses `7z` to zip up the files, `curl` to deploy to the device, and `telnet` to access the debug console. You'll need `make` of course as well.

To do it manually, you'll need your favorite zip program, web browser, and telnet client.

## Prerequisites
* You'll need to have the companion [imgserver](https://github.com/mmdoogie/roku-imgserver-screensaver-server) deployed and accessible before the channel can use it.  See the instructions over there for that.

* Your Roku device has to have Developer Mode enabled to be able to deploy a custom channel.

1. Follow the instruction in Step 1 from [Roku: Developer environment setup](https://developer.roku.com/docs/developer-program/getting-started/developer-setup.md) to enable it and set a password.
2. If using the `Makefile`, update the variables at the top with the password you just set and the correct IP or hostname for the device.
3. Update the `components/ImgserverScreensaver.brs` file setting the line near the bottom `m.fetchTask.basePath = "http://10.0.1.50/imgserver/"` to point to your imgserver.

## Deployment
### Automatic (Makefile)
`make` to deploy, the channel will run automatically.
`make debug` to open the console if it doesn't behave as expected and you need to debug.

### Manual
1. Make a zip file containing the manifest file and the components, images, and source folders.
2. Browse to your device's IP address or hostname.  Log in using the password you set in developer settings.
3. Upload your zip file and press Install.
4. If you need to access the debug console, use a telnet client to connect to your device's IP address or hostname at port 8085.
