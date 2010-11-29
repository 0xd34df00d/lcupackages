function Requires()
{
	return ["qt", "qt.core", "qt.gui"];
}

function SupportedInterfaces()
{
	return ["IPlugin2", "org.Deviant.LeechCraft.IPlugin2/1.0"];
}

function GetName()
{
	return "Private Browsing";
}

function GetInfo()
{
	return qsTr("Private browsing mode for Poshuku: disables storing history.");
}

function GetUniqueID()
{
	return "org.LeechCraft.Poshuku.Scriptable.PrivateBrowsing";
}

function GetPluginClasses()
{
	return ["org.LeechCraft.Poshuku.Plugins/1.0"];
}

function PropName()
{
	return "Plugins/" + GetUniqueID() + "/PrivateBrowsing";
}

function hookMoreMenuFillEnd(proxy, menu, webView, browserWidget)
{
	action = menu.addAction("Private browsing");
	action.checkable = true;

	function setPrivateBrowsing (pb) { this.setProperty(PropName(), pb); }

	action.toggled.connect(browserWidget, setPrivateBrowsing);
}

function hookAddingToHistory (proxy, title, url, date, browserWidget)
{
	if (browserWidget.property(PropName()))
		proxy.CancelDefault()
}
