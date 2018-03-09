<cfprocessingdirective pageencoding="utf-8" />

<cfquery name="wartungsCheck" datasource="#application.dsn#">
SELECT	*
FROM	maintainance
WHERE 	id = 1
</cfquery>

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

<cfif session.module NEQ "inc_welcome">
	<cfquery name="feldfreigaben" datasource="#application.dsn#" result="returnQuery">
	SELECT 	* 
	FROM 	mandantenfeldfreigaben
	WHERE	<!--- mandant = '#session.mandant#' AND --->
			moduleID = #session.moduleid#
	</cfquery>
<cfelse>
	<cfif session.admin EQ 1>
		<cfquery name="getLoggedInUsers" datasource="#application.dsn#">
		SELECT 	* 
		FROM 	userLoggedIn
		</cfquery>
	</cfif>
</cfif>

<!DOCTYPE html>
<html><head>
	
	<meta charset="UTF-8">
	<title>Flexy Backend Panel v2.1</title>
	
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> 
	
	<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
	<meta name="apple-mobile-web-app-capable" content="yes" />
	<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
	<link href='http://fonts.googleapis.com/css?family=Open+Sans:300,400&subset=latin,latin-ext' rel='stylesheet' type='text/css'>
	<link href='http://fonts.googleapis.com/css?family=Exo:400,900,700,600,500,200&subset=latin,latin-ext' rel='stylesheet' type='text/css'>
	<link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/themes/start/jquery-ui.css" type="text/css" rel="Stylesheet" />
	<link rel='stylesheet' href='/admin/js/jquery.fancybox-1.3.4/fancybox/jquery.fancybox-1.3.4.css' type='text/css'>
	
	<link rel="stylesheet" href="/admin/css/kube.css" />
	<link rel="stylesheet" href="/admin/css/kube-overrides.css" />
	<link rel="stylesheet" href="/admin/css/styles.css" />
	<link rel="stylesheet" href="/admin/css/ui-lightness/jquery-ui-1.10.4.min.css" />
	<!--- <link rel="stylesheet" href="/admin/css/fsadmin.css" /> --->
	<link rel="stylesheet" href="/admin/css/mediaqueries.css" />
	<link rel="stylesheet" href="inc/MultiLevelPushMenu/css/component.css" />
	
	<script type="text/javascript" src="/admin/js/modernizr.js"></script>
	<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>
	<script src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
	<script src="/admin/js/jquery-ui-1.10.4.min.js"></script>
	<script src="/admin/js/jquery.popupoverlay.js"></script>
	
	<script type="text/javascript" src="/admin/js/jquery.fancybox-1.3.4/fancybox/jquery.fancybox-1.3.4.js"></script>
	<script type="text/javascript" src="/admin/js/cfSessionTimeout.js"></script>
	<script type="text/javascript" src="/admin/js/scripts.js"></script>
	
	<cfif isdefined("url.alreadyLoggedIn") AND session.loggedIn EQ false AND not isdefined("url.admin")>
		<script>
			function closeBox(){
				$.fancybox.close();
				window.clearTimeout(m);
			}
			
			$(document).ready(function(){
				$.fancybox({
					content: 'Es ist bereits ein Benutzer mit denselben Angaben am System angemeldet.',
					onClosed: function(){
						window.clearTimeout(t);
						window.clearTimeout(m);
					},
					onComplete: function(){
						 m = setTimeout('closeBox()',5000);
					}
				});
			});
		</script>
	</cfif>
	
	<cfif session.loggedIn EQ true>
		<cfset d = ((application.timeout*60000)-60000) />
		<cfset w = 4 />
		
		<!--- message listener --->
		<script>
			var t=setTimeout('checkForMessage()',20000)
			
			function closeBox(){
				$.fancybox.close();
				window.clearTimeout(m);
			}
			
			function checkForMessage(){
				$.get('/admin/inc/ajax_checkMessage.cfm',{},function(data){
					if(data!=''){
						$.fancybox({
							content: data,
							onClosed: function(){
								 window.clearTimeout(t);
								 window.clearTimeout(m);
							},
							onComplete: function(){
								 m = setTimeout('closeBox()',10000);	
							}
						});
					}
				});	
			}
	
			var l=setTimeout('informUserOfSessionTimeout()',<cfoutput>#d#</cfoutput>);
				
			function informUserOfSessionTimeout(){
				$.fancybox({
					content: 'Ihre Session läuft in ca. 1 Minute ab. Bitte speichern Sie Ihre getätigten Eingaben, ansonsten Sie automatisch abgemeldet werden und die Mutationen verloren gehen.',
					onComplete: function(){	
						//$("#fancybox-wrap, #fancybox-overlay").delay(5000).fadeOut(); 	
						m = setTimeout('closeBox()',8000);	
						}
				});	
				window.clearTimeout(l);
			}
			$(document).ready(function() {	
				$('span#timeout').sessionTimeout({
					warningTime: <cfoutput>#w#</cfoutput>, // seconds
					onWarning: function(){
						$.fancybox({
							content: 'Sie werden in wenigen Augenblicken ausgeloggt!',
							showCloseButton: false,
							hideOnOverlayClick: false
						});	
					},
					onExpire: function(){
						location.href='/admin/?logout=true';	
					}
				});
			});
		</script>
	</cfif>
	
	<style type="text/css">

	</style>
	
	<script>
		jQuery.fn.center = function () {
			this.css("position","absolute");
			this.css("top", Math.max(0, (($(this).parent().height() - $(this).outerHeight()) / 2) + 
			 $(window).scrollTop()) + "px");
			this.css("left", Math.max(0, (($(this).parent().width() - $(this).outerWidth()) / 2) + 
			$(window).scrollLeft()) + "px");
			return this;
		}
		
	
		$(document).ready(function(){
			// load dashboard
			
			// profile toggler
			$('#profile>img')
			.on('click',function(){
				$(this).next().slideToggle()	
			})	
			
		
		})
	</script>

</head>

<body>

	<div id="headerbar">
		<div style="padding:10px 10px;">
			<div id="corporate">
				<strong>Felix Flexy CMS</strong> - Backend Panel version 2.1 <br /> 2014 &copy; by mrz & flx
			</div>
			<div id="header-right">
				
				<cfif session.loggedIn EQ true>
					<cfoutput>
						<div class="user-welcome">
							<cfoutput>
								<div>Hello <strong>#session.UserPreName#</strong> !</div>
							</cfoutput>
						</div>
						<div id="profile">
							<img src="/admin/img/profile.png" alt="profile" / id="img-menu">
							<div id="profile-menu">
								<ul>
									<li>
										Loggedin User:<br/>
										<strong>#session.UserPreName#</strong>
									</li>
									<li>
										Project:<br/>
										<a href="/#session.serverpath#"><strong>#session.serverpath#</strong></a>
									</li>
									<li>
										Mandant:<br/>
										Futurescreen DIA
									</li>
									<li>
										Language:<br/>
										<strong>#session.lang#</strong><br/>
										<cfquery name="getLangs" datasource="#application.dsn#">
										SELECT	*
										FROM	mandantensprachen
										WHERE	mandant = #session.mandant#
										</cfquery>
										<cfif getLangs.recordcount GT 1>
											<select name="langswitch" onChange="location.href='#cgi.SCRIPT_NAME#?lang='+$(this).val();" style="width:100%;">
												<cfloop query="getLangs">
													<option value="#languageParam#" <cfif languageParam EQ session.lang>selected="selected"</cfif>>
														#language#
													</option>
												</cfloop>
											</select>
										</cfif>
									</li>
									<li>
										Timeout:<br/>
										<span id="timeout"></span> Min.
									</li>
									<li>
										<a href="">Edit User</a>
									</li>
									<li>
										<a href="#cgi.SCRIPT_NAME#?logout=true">logout</a>
									</li>
								</ul>
							</div>
						</div>
					</cfoutput>
				</cfif>
			</div>
		</div>
	</div>
	<div id="admin-wrapper">
		<div id="main-wrapper" class="units-row">
			<div id="wrapper-left" class="unit-20">
				<cfif session.loggedIn EQ true>
				<cfoutput>
					<ul>
						<cfif session.admin EQ 1>
							<li>
								<a href="#cgi.SCRIPT_NAME#?module=inc_welcome">
									Home
								</a>
							</li>
						</cfif>
						<cfloop list="#session.moduleList#" index="i">
						<cfquery name="getModules" datasource="#application.dsn#">
						SELECT	*
						FROM	modules
						WHERE	id = #i#
						</cfquery>
						<cfif (getModules.variable EQ "mandantenmanagement" AND session.admin EQ 1) OR getModules.variable NEQ "mandantenmanagement">
						<li>
							<a href="#cgi.SCRIPT_NAME#?module=inc_#getModules.variable#">
								#getModules.module#
							</a>
						</li>
						</cfif>
						</cfloop>
					</ul>
				</cfoutput>
				</cfif>
			</div>
			<div id="wrapper-right" class="unit-80">
				<div id="content" class="admin-content">
					<cfif session.loggedIn EQ false>
						<cfinclude template="/admin/inc/inc_login.cfm">
					<cfelse>
						<cfinclude template="/admin/inc/#session.module#.cfm">
					</cfif>
				</div>
			</div>
		</div>
	</div>
	<footer>
		<div class="units-row">
			<div  class="unit-100">
				<p class="footer">..wördpress mached alli andere! - 
					<i>du bisch Flexy! ;-) </i>
				</p>			
			</div>
		</div>
	</footer>
</body>
</html>
