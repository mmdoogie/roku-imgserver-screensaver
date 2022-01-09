sub RunScreenSaver()
	RunScene()
end sub

sub RunUserInterface()
	RunScene()
end sub

sub RunScene()
    screen = createObject("roSGScreen")
    port = createObject("roMessagePort")
    screen.setMessagePort(port)

    scene = screen.createScene("ImgserverScreensaver")
    screen.show()
    scene.setFocus(true)

    while(true)
        msg = wait(0, port)
        if (msg <> invalid)
            msgType = type(msg)
            if msgType = "roSGScreenEvent"
                if msg.isScreenClosed() then return
            end if
        end if
    end while
end sub
