sub init()
	m.top.functionName = "refreshImages"
	m.top.imgCount = 0
end sub

sub refreshImages()
	print "Img Count Fetch Task Started"

	http = CreateObject("roUrlTransfer")

	print "Getting imgCount"
	fullUrl = m.top.basePath + "imgCount.php"
	http.SetUrl(fullUrl)
	newIC = http.GetToString()
	print "Got imgCount "; newIC
	m.top.imgCount = newIC

	print "Getting imgDescs"
	fullUrl = m.top.basePath + "imgDescs.php"
	http.SetUrl(fullUrl)
	newID = ParseJson(http.GetToString())
	print "Got imgDescs "; newID
	m.top.imgDescs = newID
end sub
