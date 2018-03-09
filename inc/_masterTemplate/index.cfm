<cfprocessingdirective pageencoding="utf-8" />

<!--- check for own domain --->
<cfquery name="getDomain" datasource="#application.dsn#">
SELECT 	* 
FROM 	mandantensprachen
WHERE 	mandant = #session.mandant# AND domain != ''
</cfquery>

<cfset ownDomain = "" />
<cfif getDomain.recordcount GT 0>
	<cfset ownDomain = getDomain.domain />
</cfif>

<cfif ownDomain NEQ "">
	<cfset xpath = cgi.PATH_INFO />
	<cfif xpath EQ "/#session.serverpath#/index.cfm" OR xpath EQ "/#session.serverpath#/ch-de" OR xpath EQ "/#session.serverpath#/ch-de/">
		<cflocation url="http://#cgi.SERVER_NAME#" addtoken="no" />
	</cfif>
</cfif>

<!--- get service-nav oberstes level --->
<cfquery name="getServiceNav" datasource="#application.dsn#">
SELECT * FROM pages
WHERE navpos = 0 AND parentid = 0 AND isactive = 1 AND mandant = #session.mandant# AND lang = '#session.lang#'
ORDER	BY navorder
</cfquery>
<!--- get themen-nav oberstes level --->
<cfquery name="getThemenNav" datasource="#application.dsn#">
SELECT * FROM pages
WHERE navpos = 1 AND parentid = 0 AND isactive = 1  AND mandant = #session.mandant# AND lang = '#session.lang#'
ORDER	BY navorder
</cfquery>
<!--- get nav 2. level --->
<cfquery name="getsubnav" datasource="#application.dsn#">
SELECT * FROM pages
WHERE parentid = #url.id# AND isactive = 1 
ORDER	BY navorder
</cfquery>
<!--- get inhalte --->
<cfquery name="getcontent" datasource="#application.dsn#">
SELECT * FROM content
WHERE pageid = #url.id# AND isactive = 1
ORDER	BY reihenfolge
</cfquery>
<!--- get actual page properties --->
<cfquery name="pageProperties" datasource="#application.dsn#">
SELECT * FROM pages
WHERE id = #url.id# AND isactive = 1 
</cfquery>
<!--- get actual sidebars --->
<cfquery name="getSidebarElems" datasource="#application.dsn#">
SELECT 	S.* 
FROM 	sidebar2pages P LEFT JOIN sidebar S ON P.sidebarid = S.id
WHERE 	P.pageid = #url.id# AND S.isactive = 1 AND S.teaserposition = 1
ORDER	BY P.reihenfolge 
</cfquery>
<!--- get teasers --->
<cfquery name="getTeasers" datasource="#application.dsn#">
SELECT 	S.* 
FROM 	teaser2pages P LEFT JOIN sidebar S ON P.sidebarid = S.id
WHERE 	P.pageid = #url.id# AND S.isactive = 1 AND S.teaserposition = 2
ORDER	BY P.reihenfolge 
</cfquery>
<!--- get actual headerpanel --->
<cfquery name="getHeaderPanels" datasource="#application.dsn#">
SELECT 	S.* 
FROM 	headerpanels2pages H LEFT JOIN headerpanels S ON H.headerpanelID = S.id
WHERE 	H.pageid = #url.id# AND S.isactive = 1
ORDER	BY H.reihenfolge 
</cfquery>
<!--- getAllLinkedContentsFromCalledContentid --->
<cfquery name="getAllLinkedContentsFromPage" datasource="#application.dsn#">
SELECT 	linkedContentID,mainContentID
FROM 	contents2content
WHERE 	mainContentID IN (SELECT id FROM content WHERE pageid = #url.id#)
</cfquery>

<!DOCTYPE html>

<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>    <html class="no-js lt-ie9" lang="en"> <![endif]-->

<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->

<head>
	<meta charset="UTF-8">
	
	<!-- Remove this line if you use the .htaccess -->
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

	<meta name="viewport" content="width=device-width">
	<meta name="robots" content="noindex,nofollow">
	
	<meta name="description" content="Designa Studio, a HTML5 / CSS3 template.">
	<meta name="author" content="Sylvain Lafitte, Web Designer, sylvainlafitte.com">
	
	<title></title>
	
	<link rel="shortcut icon" type="image/x-icon" href="favicon.ico">
	<link rel="shortcut icon" type="image/png" href="favicon.png">
	
	<link href='http://fonts.googleapis.com/css?family=Open+Sans:400italic,400,700' rel='stylesheet' type='text/css'>
	<cfoutput>
	<link rel="stylesheet" href="/#session.serverpath#/css/style.css">
	<link rel='stylesheet' href='/#session.serverpath#/js/flexslider/flexslider.css' type='text/css'>
	</cfoutput>
	
	<cfif pageProperties.template EQ 3>
	<style type="text/css">
	.col-three-quarters {
		width: 50%;
	}
	</style>
	</cfif>
	
	<!--[if lt IE 9]>
	<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
	<![endif]-->
</head>
<body>
<!-- Prompt IE 7 users to install Chrome Frame -->
<!--[if lt IE 8]><p class=chromeframe>Your browser is <em>ancient!</em> <a href="http://browsehappy.com/">Upgrade to a different browser</a> or <a href="http://www.google.com/chromeframe/?redirect=true">install Google Chrome Frame</a> to experience this site.</p><![endif]-->

<div class="container">
	<cfinclude template="inc/servicenav.cfm" />
	<cfinclude template="inc/index.cfm" />
	<cfinclude template="inc/teasers.cfm" />

	<div class="divide-top">
	<footer class="grid-wrap">
		
	
		<div class=" grid col-two-thirds">
			<ul>
				
				<cfoutput query="getServiceNav">
					<li><a href="/#session.serverpath#/#urlshortcut#/">#pagetitel#</a></li>
				</cfoutput>
			</ul>
		</div>
		
		<nav class="up grid col-one-third ">
			<a href="#navtop" title="Go back up">&uarr;</a>
			
		</nav>
	</footer>
	</div>
	
	</div>
	
	<!-- Javascript - jQuery -->
	<script src="http://code.jquery.com/jquery.min.js"></script>
	<script>window.jQuery || document.write('<script src="js/jquery-1.7.2.min.js"><\/script>')</script>
	<cfoutput>
	<script src='/#session.serverpath#/js/jquery.flexslider-min.js'></script>
	
	<!--[if (gte IE 6)&(lte IE 8)]>
	<script src="js/selectivizr.js"></script>
	<![endif]-->
	
	<script src="/#session.serverpath#/js/scripts.js"></script>	
	<script type="text/javascript" src="/#session.serverpath#/inc/yoxview/yoxview-init.js"></script>
	<script>
	$(document).ready(function(){
		$(".yoxview").yoxview({
			lang: "de"
		});
		$(".thumbBox").vAlign();
		$('.fnc').each(function(){
			classList = $(this).attr('class');	
			$(this).mouseover(function(){
				$(this).css('background-color','##ddd');
				if(classList.indexOf('fnc-content')>-1){
					$(this).dblclick(function(){
						// some action
					});
				}
			}).mouseout(function(){
				$(this).css('background-color','##fff');	
			});
		});
		
	});
	</script>	
	</cfoutput>
	
	<!-- Asynchronous Google Analytics snippet. Change UA-XXXXX-X to be your site's ID. -->
	<script>
	  var _gaq=[['_setAccount','UA-XXXXX-X'],['_trackPageview']];
	  (function(d,t){var g=d.createElement(t),s=d.getElementsByTagName(t)[0];
	  g.src=('https:'==location.protocol?'//ssl':'//www')+'.google-analytics.com/ga.js';
	  s.parentNode.insertBefore(g,s)}(document,'script'));
	</script>
	</body>
	</html>