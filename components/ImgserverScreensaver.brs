Function disableAutoflip() as Void
	print "Disabled autoflip"
	m.autoflip = false
	m.autorefresh = false
	m.flipTimer.control = "stop"
End Function

Function enableAutoflip() as Void
	print "Enabled autoflip"
	m.autoflip = true
	m.autorefresh = false
	m.flipTimer.duration = 5
	m.flipTimer.control = "start"
End Function

Function enableAutorefresh() as Void
	print "Enabled autorefresh"
	m.autoflip = false
	m.autorefresh = true
	m.flipTimer.duration = 30
	m.flipTimer.control = "start"
End Function

Function gotAutoflip() as Void
	if (m.autoflip) then
		immNextImage()
	else if (m.autorefresh) then
		realUpdateImage()
	end if
End Function

Function onKeyEvent(k as String, p as Boolean) as Boolean
	if (p <> true)
		return false
	end if

	if (k = "left")
		disableAutoflip()
		prevImage()
	else if (k = "right")
		disableAutoflip()
		nextImage()
	else if (k = "OK")
		disableAutoflip()
		getImageCount()
	else if (k = "play")
		if (m.autoflip) then
			disableAutoflip()
		else
			enableAutoflip()
		end if
	else if (k = "replay")
		if (m.autorefresh) then
			disableAutoflip()
		else
			enableAutorefresh()
		end if
	else if (k = "options")
		disableAutoflip()
		showDescsDialog()
	else
		print k
		return false
	end if

	return true
End Function

Function immNextImage() as Void
	if (m.imgCount < 1)
		return
	end if

	m.currImg += 1
	if (m.currImg >= m.imgCount)
		m.currImg = 0
	end if

	realUpdateImage()
End Function

Function nextImage() as Void
	if (m.imgCount < 1)
		return
	end if

	m.currImg += 1
	if (m.currImg >= m.imgCount)
		m.currImg = 0
    	end if

	updateImage()
End Function

Function prevImage() as Void
	if (m.imgCount < 1)
		return
	end if

	m.currImg -= 1
	if (m.currImg < 0)
		m.currImg = m.imgCount - 1
	end if

	updateImage()
End Function

Function updateImage() as Void
	m.debounceTimer.control = "stop"
	m.lbl.text = "*" + StrI(m.currImg + 1) + " /" + StrI(m.imgCount) + Chr(10) + m.fetchTask.imgDescs[m.currImg]
	m.debounceTimer.control = "start"
End Function

Function realUpdateImage() as Void
	dt = CreateObject("roDateTime")
	ts = dt.AsSeconds()
	uri = m.fetchTask.basePath + "imgserver.php?cmd=img&num=" + StrI(m.currImg,10) + "&ts=" + StrI(ts,16)
	print uri
	if (m.currBG = 1) then
		m.bg2.uri = uri
	else
		m.bg1.uri = uri
	end if
End Function

Function getImageCount() as Void
	m.fetchTask.imgCount = 0
	m.fetchTask.control = "RUN"
End Function

Function gotImageCount() as Void
	if (m.fetchTask.imgCount > 0) then
		m.imgCount = m.fetchTask.imgCount
		if (m.currImg >= m.imgCount) m.currImg = 0
		realUpdateImage()
	end if
End Function

Function showDescsDialog() as Void
	d = CreateObject("roSGNode", "StandardMessageDialog")
	d.title = "Image Descriptions"
	d.bulletText = m.fetchTask.imgDescs
	d.bulletType = "numbered"
	d.buttons = ["OK"]
	d.observeFieldScoped("buttonSelected", "hideDescsDialog")
	m.top.dialog = d
End Function

Function hideDescsDialog() as Void
	m.top.dialog.close = true
End Function

Function bg1Status() as Void
	if (m.bg1.loadStatus = "loading") then
		m.spinner.visible = true
	else if (m.bg1.loadStatus = "ready") then
		m.spinner.visible = false
		if (m.autoflip = true or m.autorefresh = true) then
			m.flipTimer.control = "start"
		end if
		m.bg1.visible = true
		m.bg2.visible = false
		m.lbl.text = StrI(m.currImg + 1) + " /" + StrI(m.imgCount)
		m.currBG = 1
	else if (m.bg1.loadStatus = "failed") then
		print "BG1 loadStatus failed!"
		getImageCount()
	end if
End Function

Function bg2Status() as Void
	if (m.bg2.loadStatus = "loading") then
		m.spinner.visible = true
	else if (m.bg2.loadStatus = "ready") then
		m.spinner.visible = false
		if (m.autoflip = true or m.autorefresh = true) then
			m.flipTimer.control = "start"
		end if
		m.bg2.visible = true
		m.bg1.visible = false
		m.lbl.text = StrI(m.currImg + 1) + " /" + StrI(m.imgCount)
		m.currBG = 2
	else if (m.bg2.loadStatus = "failed") then
		print "BG2 loadStatus failed!"
		getImageCount()
	end if
End Function

Function init()
	m.bg1 = m.top.findNode("BackgroundArt1")
	m.bg1.visible = true
	m.bg1.observeField("loadStatus", "bg1Status")

	m.bg2 = m.top.findNode("BackgroundArt2")
	m.bg2.visible = false
	m.bg2.observeField("loadStatus", "bg2Status")

	m.currBG = 1

	m.lbl = m.top.findNode("TopLabel")

	m.spinner = m.top.findNode("Spinner")
	m.spinner.poster.uri = "pkg:/images/spinner.png"

	m.autoflip = true
	m.autorefresh = false
	m.flipTimer = m.top.findNode("FlipTimer")
	m.flipTimer.observeField("fire", "gotAutoflip")

	m.debounceTimer = m.top.findNode("DebounceTimer")
	m.debounceTimer.observeField("fire", "realUpdateImage")

	m.currImg = 0
	m.imgCount = 0

	m.fetchTask = createObject("roSGNode", "ISRefreshImages")
	m.fetchTask.basePath = "http://10.0.1.50/imgserver/"
	m.fetchTask.observeField("imgCount", "gotImageCount")
	getImageCount()
End Function
