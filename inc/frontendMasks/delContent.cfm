<!--- init component --->
<cfset flexyLib = createObject('component','admin.cfc.flexy') />
<!--- execute method --->
<cfset delContentx = flexyLib.deleteContent(content=url.actId) />