<cfparam name="url.editMagazinPage" default="0" />
<cfparam name="url.device" default="ipad" />
<cfparam name="url.orientation" default="portrait" />

<cfswitch expression="#url.device#">
	<cfcase value="galaxyTab">
		<cfif url.orientation EQ "portrait">
			<cfset canvasWidth = 800 />
			<cfset canvasHeight = 1280 />
			
		<cfelse>
			<cfset canvasWidth = 1280 />
			<cfset canvasHeight = 800 />	
			
		</cfif>
	</cfcase>
	<cfcase value="ipad">
		<cfif url.orientation EQ "portrait">
			<cfset canvasWidth = 768 />
			<cfset canvasHeight = 1024 />
			<cfset width = "997" /> 
			<cfset height = "1276" />
			<cfset bgimage = "bg_ipad_hoch.png">
			<cfset padding = "125px 115px 125px 115px" />
		<cfelse>
			<cfset canvasWidth = 1024 />
			<cfset canvasHeight = 768 />		
			<cfset width = "1276" />
			<cfset height = "997" />
			<cfset bgimage = "bg_ipad_quer.png">
			<cfset padding = "125px 115px 125px 115px" />	
		</cfif>
	</cfcase>
	<cfcase value="surface">
		<cfif url.orientation EQ "portrait">
			<cfset canvasWidth = 768 />
			<cfset canvasHeight = 1366 />
		<cfelse>
			<cfset canvasWidth = 1366 />
			<cfset canvasHeight = 768 />		
		</cfif>
	</cfcase>
</cfswitch>

<cfset toolbarWidth = 220 />
<cfset toolbarHeight = height-125 />
<cfset canvasWidthX = width />
<cfset canvasHeightX = height />
<cfset wrapper = canvasWidthX + toolbarWidth + 20>

<!--- zu bearbeitende magazinseiten aus db lesen (aufgrund seiner übermittelten ID) --->
<cfif isdefined("url.editMagazinPage") AND isNumeric(url.editMagazinPage) AND url.editMagazinPage GT 0>
	<cfquery name="editMagazinePage" datasource="#application.dsn#">
	SELECT	*
	FROM	magazinseiten
	WHERE	id = #url.editMagazinPage#
	</cfquery>
</cfif>

<!--- get all elems from db --->
<cfquery name="getAllElems" datasource="#application.dsn#">
SELECT	*
FROM	magazininhaltselemente
WHERE	magazinPageID = #url.editMagazinPage# AND
		orientation = <cfif url.orientation EQ "portrait">1<cfelseif url.orientation EQ "landscape">0</cfif>
</cfquery>

<cfhtmlhead text="
	<style type='text/css'>
		.layoutElem:hover{
			border:1px solid grey;
		}
	</style>
">
<cfoutput>
<div id="wrapper" style="width:#wrapper#px;background-color:white;"><!---  --->
		<div id="outerCanvas" style="">

	<div id="toolset" style="float:left;padding-right:20px;width:#toolbarWidth#px;height:#toolbarHeight#px;overflow-y:auto;">
		<div id="cd" style="position:relative;height:105px;padding-left:1em;padding-top:20px;">
			<strong style="font-weight:bold;font-size:20px;">HTML5-FOLIO for tablets &copy;</strong><br/>by reziprok
			<a href="javascript:void(0);" onclick="loadDeviceSpecificCanvas($('##canvas').attr('class').split(' ')[0],#url.editMagazinPage#,'portrait');" style="display:block;position:absolute;top:60px;right:20px;width:36px;height:30px;">
				<img src="/admin/img/rotate.png">
			</a>
		</div>
		<div id="globalSettings" style="padding:1em;border-bottom:1px solid silver;">
			<a href="javascript:void(0);" onclick="loadDeviceSpecificCanvas('iPad',#url.editMagazinPage#,'portrait');" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">iPad</a>
			<a href="javascript:void(0);" onclick="loadDeviceSpecificCanvas('galaxyTab',#url.editMagazinPage#,'portrait');" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">GTab</a>
			<a href="javascript:void(0);" onclick="loadDeviceSpecificCanvas('surface',#url.editMagazinPage#,'portrait');" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">Surface</a>
			<!--- <a href="" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;">&nbsp;</a>
			 ---><div style="clear:both;"></div>
		</div>
		<div id="globalSettings" style="padding:1em;border-bottom:1px solid silver;">
			<a href="javascript:void(0);" onclick="pageProp(#url.editMagazinPage#);" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">P</a>
			<a href="javascript:void(0);" onclick="addElem();" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">+</a>
			<!--- <a href="" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;">&nbsp;</a>
			<a href="" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;">&nbsp;</a>
			 ---><div style="clear:both;"></div>
		</div>
		<div id="pageSettings" style="padding:1em;border-bottom:1px solid silver;">
			<a href="" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid steelblue;float:left;margin-right:0.5em;width:30px;height:30px;">&nbsp;</a>
			<a href="" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid steelblue;float:left;margin-right:0.5em;width:30px;height:30px;">&nbsp;</a>
			<a href="" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid steelblue;float:left;margin-right:0.5em;width:30px;height:30px;">&nbsp;</a>
			<a href="" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid steelblue;float:left;margin-right:0.5em;width:30px;height:30px;">&nbsp;</a>
			<div style="clear:both;"></div>
		</div>
		<div id="pageSettings" style="padding:1em;border-bottom:1px solid silver;">
			<span style="display:inline-block;width:20px;">X:</span><input type="text" style="width:30px;border:1px solid silver;border-radius:3px;" name="x" />&nbsp;&nbsp;
			<span style="display:inline-block;width:20px;">Y:</span><input type="text" style="width:30px;border:1px solid silver;border-radius:3px;" name="y" /><br/>
			<span style="display:inline-block;width:20px;">W: </span><input type="text" style="width:30px;border:1px solid silver;border-radius:3px;" name="w" />&nbsp;&nbsp;
			<span style="display:inline-block;width:20px;">H: </span><input type="text" style="width:30px;border:1px solid silver;border-radius:3px;" name="h" />
		</div>
		<div id="layers" style="padding:1em;">
			<ul style="margin:0;padding:0;list-style-type:none;">
				<cfloop query="getAllElems">
					<cfquery name="getAllElemsByResolution" datasource="#application.dsn#">
					SELECT	*
					FROM	magazininhaltselemente_#url.device#
					WHERE	magazinInhaltsElementID = #id#
					</cfquery>
					<li style="border-bottom:1px solid silver;padding:0.2em;padding-left:1em;position:relative;">
						<div id="elem-#id#" class="layerElem" rel="#id#-<cfif getAllElemsByResolution.recordcount NEQ 0>#getAllElemsByResolution.id#<cfelse>0</cfif>" onclick="showLabelForm('elem#id#');"><cfif elemName NEQ "">#elemName#<cfelse>[No Layer-Label]</cfif></div>
						<div style="position:absolute;top:0;right:0;width:20px;cursor:pointer;" onclick="delElem(#currentrow#,#id#);void(0);">
							x
						</div>
						<div style="position:absolute;top:0;right:20px;width:20px;">
							e
						</div>
						<!--- <ul style="margin:0;padding:0;list-style-type:none;">
							<li style="border-bottom:1px solid silver;padding:0.2em;padding-left:1em;position:relative;">
								ein subLayer
								<div style="position:absolute;top:0;right:0;width:20px;">
									x
								</div>
								<div style="position:absolute;top:0;right:20px;width:20px;">
									e
								</div>
							</li>
							<li style="border-bottom:1px solid silver;padding:0.2em;padding-left:1em;position:relative;">
								ein subLayer
								<div style="position:absolute;top:0;right:0;width:20px;">
									x
								</div>
								<div style="position:absolute;top:0;right:20px;width:20px;">
									e
								</div>
							</li>
							<li style="padding:0.2em;padding-left:1em;position:relative;">
								ein subLayer
								<div style="position:absolute;top:0;right:0;width:20px;">
									x
								</div>
								<div style="position:absolute;top:0;right:20px;width:20px;">
									e
								</div>
							</li>
						</ul> --->
					</li>
				</cfloop>
			</ul>
		</div>
	</div>
</cfoutput>
<div style="float:left;background:transparent url('/admin/img/<cfoutput>#bgimage#</cfoutput>') left top no-repeat;<cfoutput>width:#canvasWidthX#px;height:#canvasHeightX#px;</cfoutput>">
	<div style="padding:<cfoutput>#padding#</cfoutput>;" id="canvas-wrapper">
		<div id="canvas" class="<cfoutput>#url.device# #url.orientation#</cfoutput>" style="margin-right:20px;float:left;margin-top:0em;width:<cfoutput>#canvasWidth#</cfoutput>px;height:<cfoutput>#canvasHeight#</cfoutput>px;border:1px solid black;background-color:white;position:relative;<cfif evaluate("editMagazinePage.bgimage_" & url.device & "_" & url.orientation) NEQ "">background-image:url('/<cfoutput>#session.serverpath#</cfoutput>/upload/img/<cfoutput>#evaluate("editMagazinePage.bgimage_" & url.device & "_" & url.orientation)#</cfoutput>');</cfif><cfif editMagazinePage.bgcolor NEQ "">background-color:<cfoutput>###editMagazinePage.bgcolor#</cfoutput></cfif>"><!--- background-size:<cfoutput>#canvasWidth#px #canvasHeight#px</cfoutput>; --->
			&nbsp;
			<cfif getAllElems.recordcount GT 0>
				<cfoutput query="getAllElems">
					<cfquery name="getAllElemsByResolution" datasource="#application.dsn#">
					SELECT	*
					FROM	magazininhaltselemente_#url.device#
					WHERE	magazinInhaltsElementID = #id#
					</cfquery>
					<div id="layoutElem-#currentrow#" class="layoutElem" rel="#id#-<cfif getAllElemsByResolution.recordcount NEQ 0>#getAllElemsByResolution.id#<cfelse>0</cfif>" style="overflow:hidden;cursor:crosshair;opacity:#opacity#;padding:10px;background-color:###bgcolor#;position:absolute;top:#getAllElemsByResolution.posx#px;left:#getAllElemsByResolution.posy#px;width:#getAllElemsByResolution.width#px;height:#getAllElemsByResolution.height#px;z-index:#getAllElemsByResolution.zIndex#;"><div class="elemContent" style="cursor:pointer;">
						<cfif image NEQ "">
							<img src="/mirza-in-progress/upload/img/#image#" alt="" style="max-width:100%;" />
						<cfelse>
							#content#
						</cfif>
					</div>
					<a href="javascript:void(0);" style="display:block;position:absolute;top:5px;right:25px;" onclick="bringToFront(#currentrow#,#id#,<cfif getAllElemsByResolution.id NEQ "">#getAllElemsByResolution.id#<cfelse>0</cfif>);void(0);">[z]</a>
					<a href="javascript:void(0);" style="display:block;position:absolute;top:5px;right:5px;" onclick="delElem(#currentrow#,#id#);void(0);">[x]</a></div>
				</cfoutput>
				<script>
				$(document).ready(function(){
					$('.layoutElem').draggable({
						containment: "#canvas", 
						grid: [ 10,10 ],
						scroll: false,
						stop:	function(event,ui){
									xZindex = 1;
									xTop = parseInt(ui.position.top);
									xLeft = parseInt(ui.position.left);
									//$('span',this).html('z-index:'+xZindex+'<br/>top:'+xTop+'<br/>left:'+xLeft);
									//post data into db and update record
									$.post('/admin/inc/ajax_updateMagazinElement.cfm',{
										id: 	$(this).attr('rel').split('-')[0],
										posX: 	xTop,
										posY: 	xLeft,
										pageID:	<cfoutput>#url.editMagazinPage#</cfoutput>,
										orientation: $('#canvas').attr('class').split(' ')[1],
										device: $('#canvas').attr('class').split(' ')[0],
										resElemID: $(this).attr('rel').split('-')[1]
									});	
								}
					}); 
					$('.layoutElem,layerelem').resizable({
						 containment: "#canvas",
						 grid: 10,
						 stop:	function(event,ui){
								xWidth = parseInt(ui.size.width);
								xHeight = parseInt(ui.size.height);
								//$('b',this).html('width:'+xWidth+'<br/>height:'+xHeight);
								//post data into db and update record
								$.post('/admin/inc/ajax_updateMagazinElement.cfm',{
									id: 	$(this).attr('rel').split('-')[0],
									width: 	xWidth,
									height:	xHeight,
									pageID:	<cfoutput>#url.editMagazinPage#</cfoutput>,
									orientation: $('#canvas').attr('class').split(' ')[1],
									device: $('#canvas').attr('class').split(' ')[0],
									resElemID: $(this).attr('rel').split('-')[1]
								});					
						}//,
						/*minWidth: $('div.elemContent',$(this)).width(),*/
						//minHeight: $('div.elemContent',this).height()
					});
					// get form
					$('.layoutElem,.layerElem').click(function(){
						_this = $(this);
						 $.fancybox({
							'autoDimensions': true,
							'centerOnScroll': true,
							'type':'ajax',
							'href':'/admin/inc/ajax_magazinForm.cfm?device='+$('#canvas').attr('class').split(' ')[0]+'&id='+_this.attr('rel').split('-')[0]+'&divid='+_this.attr('id')+'&orientation='+$('#canvas').attr('class').split(' ')[1]+'&reselemid='+_this.attr('rel').split('-')[1]
						});
					});
					
				});
				</script>
			</cfif> 
		</div>
	</div>
</div>
<div style="clear:both;"></div>
</div>
	</div>