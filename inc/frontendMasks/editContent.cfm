<!--- RECHTE UND MASKENFREIGABEN --->
<cfquery name="getMandantenModules" datasource="#application.dsn#">
SELECT 	* 
FROM 	mandantenmodules
WHERE	mandantenID = '#session.mandant#'
</cfquery>
<cfset MandantenModules = "" />
<cfoutput query="getMandantenModules">
	<cfset MandantenModules = listAppend(MandantenModules,moduleid) />
</cfoutput>
<!--- wenn der mandant dieses users das modul headerpanels hat. der wert 4 ist hardgecodede moduleID --->
<cfif ListFind(MandantenModules,4)>
	<cfset HasHeaderPanels = true />
<cfelse>
	<cfset HasHeaderPanels = false />
</cfif> 
<!--- wenn der mandant dieses users das modul gallerymanagement hat. der wert 6 ist hardgecodede moduleID --->
<cfif ListFind(MandantenModules,6)>
	<cfset HasGallery = true />
<cfelse>
	<cfset HasGallery = false />
</cfif> 
<!--- wenn der mandant dieses users das modul teasermanagagement hat. der wert 3 ist hardgecodede moduleID --->
<cfif ListFind(MandantenModules,3)>
	<cfset HasSidebar = true />
<cfelse>
	<cfset HasSidebar = false />
</cfif> 
<!--- ENDE RECHTE UND MASKENFREIGABEN --->


<cfquery name="mandantenfunktionsfreigaben" datasource="#application.dsn#" result="returnQuery">
SELECT 	* 
FROM 	mandantenfunktionsfreigaben
WHERE	mandant = '#session.mandant#'
</cfquery>
<cfloop list="#returnQuery.columnlist#" index="i">
	<cfif evaluate('mandantenfunktionsfreigaben.' & i) EQ 1>
		<cfset "#i#" = true />
	<cfelse>
		<cfset "#i#" = false />
	</cfif>
</cfloop>


	
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
	<script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
	<script src="http://code.jquery.com/jquery-migrate-1.1.1.min.js"></script>
	<script>window.jQuery || document.write('<script src="js/jquery-1.7.2.min.js"><\/script>')</script>
	<link href='http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/themes/start/jquery-ui.css' type='text/css' rel='Stylesheet' />
	<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.1/jquery-ui.min.js"></script>
	<script type="text/javascript" src="/admin/js/scripts.js"></script>
	
	<!--temlpate-->
	<style type="text/css" >
		html, body{
			/* height immer im BODY da vererbung an die anderen Elemente elementar!!*/
			
					
		}
			
		body{
			padding: 0;
			margin:0;
			background:#e5e5e5;
			font-family:Verdana, Geneva, sans-serif;
			/*font-family:; */
			font-size:100.01%;
			font-weight:400;
			
		}
			
		#wrapper{
			
			margin: 0 auto;
			font-size:76%;
			background-color:silver;
			padding:2%;
			padding-bottom:50px;
		}
			
		.clear{
			clear:both;
		}
			
		a{
			color:#06C;
			font-size:1em;
			text-decoration:none;
		}
	
		a:hover{
			color:#E33;
			text-decoration: underline;
			background:#D9d9d9;
		}
		
		#servicenav{
			float:right;
		}
		
		#servicenav ul{
			
		}
		
		#servicenav ul li{
			float:left;
		}
			
		#servicenav ul li a{
			text-decoration:none;
		}
		#headerpanel{
			height:200px;
			background-color:#09C;
		}		
		
		#themennav-wrapper{
			margin-bottom:20px;
			font-size: 1.4em;
			background:#DDD;
			
		}
		
		#themennav-wrapper ul{
			border-top: #666 1px solid;
			list-style-type:none;
		}
		
		#themennav-wrapper ul li{
			float:left;
			margin-left:50px;
			text-decoration:none;
		}
			
		#themennav-wrapper ul li a{
			text-decoration:none;
			list-style-type:none;
		}
		
		#themennav-wrapper ul li a:hover{
			text-decoration:none;
			background:#F9F9F9;	
			-webkit-transition:all ease-in  200ms;
			-moz-transition:all ease-in  200ms;
		}
		#themennav-wrapper ul li a:active{
			text-decoration:none;
			-webkit-transition:all ease-out 300ms;
			-moz-transition:all ease-out  300ms;
			color:#D90217;
			background:#EEDE;
		}
		
		#navBar{
			width:220px;
			margin-right:20px;
			float:left;
		}
		
		#content-wrapper{
			float:left;
			width:96%;
			/*margin-right:30px;*/ 
		/*border:#06F 1px solid;*/	
			padding: 2%;
			border-bottom-right-radius: 45px;
		}
		
		#sideBar{
			width:220px;
			float:left;
		}
		
		#logout{
			background-color:#E5E5E5;
			letter-spacing:2px;
			list-style-type:none;
			}
		
		#logout:hover{
		-webkit-transition:all ease-in  300ms;
		-moz-transition:all ease-in  300ms;
		background-color:#FEFEFE;
	}
	
		.welcome{
			font-size:0.8em;
			letter-spacing:1.5px;
			padding-right: 15px;
			text-align:right;
			}
	
		#flexy_head{
			font-size:9.4em;
			letter-spacing:6px;
			color:#E5E5E5;
			text-shadow:2px 2px #666;
			margin-left:-12px;
			}
	
			
		#backendpanel{
			font-size:2.4em;
			letter-spacing:10px;
			color:#E5E5E5;
			text-shadow:2px 0px #888;
			margin-left:-6px;
			margin-top:-10px;
			}
		
		#headwrapper{
			display:block;
			border: 4px solid #E5E5E5;
			margin-right:300px;
			margin-bottom:20px;
			margin-top:0px;
			padding-right:40px;
			border-bottom-right-radius:90px;
			border-left:none;
			border-top: none;
			}
			
	</style>
	
	<cfif isdefined("form.fieldnames")>
		<cfinclude template="/admin/inc/prc_pageprocessing.cfm" />
		<script>
			parent.location.reload();
			parent.$.fancybox.close();
		</script>
	<cfelse>
		<cfquery name="getSettings" datasource="#application.dsn#">
		SELECT 	* 
		FROM 	settings
		WHERE 	mandant = #url.mandant#
		</cfquery>
		
		<cfset session.mandant = url.mandant />
		<cfset session.lang = getSettings.defaultlang  />
		<cfset url.editcontent = url.actid />
	</cfif>
	
</head>

<body>
	<div id="wrapper">
	<cfif NOT isdefined("form.fieldnames")>
		<cfinclude template="/admin/inc/inc_editContent.cfm">
	<cfelse>
		Seite wird neu geladen...
	</cfif>
	</div>
	
</body>
</html>

	
	
	