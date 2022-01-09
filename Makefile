DEVUSER=rokudev
DEVPASS=password
TARGET=10.0.1.100

deploy: clean
	7z a roku-imgserver-screensaver.zip manifest source/ components/ images/
	curl -f -sS --user "$(DEVUSER):$(DEVPASS)" --anyauth -F "mysubmit=Install" -F "archive=@roku-imgserver-screensaver.zip" -F "passwd=" "http://$(TARGET)/plugin_install" | grep color

debug:
	telnet $(TARGET) 8085

debug_ss:
	telnet $(TARGET) 8087

clean:
	rm -f roku-imgserver-screensaver.zip
