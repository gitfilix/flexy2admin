<cfparam name="url.editMagazinPage" default="0" />
<cfparam name="url.device" default="ipad" />
<cfparam name="url.orientation" default="portrait" />

<cfswitch expression="#url.device#">
	<cfcase value="galaxyTab">
		<cfif url.orientation EQ "portrait">
			<cfset canvasWidth = 800 />
			<cfset canvasHeight = 1280 />
			<cfset width = "1052" /> 
			<cfset height = "1563" />
			<cfset bgimage = "bg_gtab_hoch.png">
			<cfset padding = "130px 120px" />
		<cfelse>
			<cfset canvasWidth = 1280 />
			<cfset canvasHeight = 800 />	
			<cfset width = "1563" />
			<cfset height = "1052" />
			<cfset bgimage = "bg_gtab_quer.png">
			<cfset padding = "130px 130px" />	
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
			<cfset padding = "115px 125px 115px 125px" />	
		</cfif>
	</cfcase>
	<cfcase value="nexus4">
		<cfif url.orientation EQ "portrait">
			<cfset canvasWidth = 384 />
			<cfset canvasHeight = 592 />
			<cfset width = "997" /> 
			<cfset height = "1276" />
			<cfset bgimage = "bg_nexus4_hoch.png">
			<cfset padding = "125px 115px 125px 115px" />
		<cfelse>
			<cfset canvasWidth = 592 />
			<cfset canvasHeight = 384 />		
			<cfset width = "1276" />
			<cfset height = "997" />
			<cfset bgimage = "bg_nexus4_quer.png">
			<cfset padding = "115px 125px 115px 125px" />	
		</cfif>
	</cfcase>
	<cfcase value="iphone3">
		<cfif url.orientation EQ "portrait">
			<cfset canvasWidth = 320 />
			<cfset canvasHeight = 480 />
			<cfset width = "997" /> 
			<cfset height = "1276" />
			<cfset bgimage = "bg_iphone3_hoch.png">
			<cfset padding = "125px 115px 125px 115px" />
		<cfelse>
			<cfset canvasWidth = 480 />
			<cfset canvasHeight = 320 />		
			<cfset width = "1276" />
			<cfset height = "997" />
			<cfset bgimage = "bg_iphone3_quer.png">
			<cfset padding = "115px 125px 115px 125px" />	
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
ORDER	BY zIndex DESC
</cfquery>

<cfhtmlhead text="
	<style type='text/css'>
		.layoutElem:hover{
			outline:2px solid grey;
		}
	</style>
">
<cfoutput>
<div id="wrapper" style="width:#wrapper#px;background-color:white;"><!---  --->
		<div id="outerCanvas" style="">

	<div id="toolset" style="float:left;padding-right:20px;width:#toolbarWidth#px;height:#toolbarHeight#px;overflow-y:auto;">
		<div id="cd" style="position:relative;height:105px;padding-left:1em;padding-top:20px;">
			<strong style="font-weight:bold;font-size:20px;">HTML5-FOLIO for tablets &copy;</strong><br/>by reziprok
			<a href="javascript:void(0);" onclick="loadDeviceSpecificCanvas($('##canvas').attr('class').split(' ')[0],#url.editMagazinPage#,'<cfif url.orientation EQ "landscape">portrait<cfelse>landscape</cfif>');" style="display:block;position:absolute;top:60px;right:20px;width:36px;height:30px;">
				<img src="/admin/img/rotate.png">
			</a>
		</div>
		<div id="globalSettings" style="padding:1em;border-bottom:1px solid silver;">
			Device<br/>
			<a href="javascript:void(0);" onclick="loadDeviceSpecificCanvas('iPad',#url.editMagazinPage#,'portrait');" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">iPad</a>
			<a href="javascript:void(0);" onclick="loadDeviceSpecificCanvas('galaxyTab',#url.editMagazinPage#,'portrait');" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">GTab</a>
			<a href="javascript:void(0);" onclick="loadDeviceSpecificCanvas('surface',#url.editMagazinPage#,'portrait');" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">Surface</a>
			<!--- <a href="" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;">&nbsp;</a>
			 ---><div style="clear:both;"></div>
		</div>
		<div id="globalSettings" style="padding:1em;border-bottom:1px solid silver;">
			Settings<br/>
			<a href="javascript:void(0);" onclick="pageProp(#url.editMagazinPage#);" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">P</a>
			<div style="clear:both;"></div>
		</div>
		<div id="grid" style="padding:1em;border-bottom:1px solid silver;">
			Grid<br/>
			<a href="javascript:void(0);" onclick="$('.grid').remove();" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">G-0</a>
			<a href="javascript:void(0);" onclick="createGrid(10);" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">G-10</a>
			<a href="javascript:void(0);" onclick="createGrid(20);" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">G-20</a>
			<a href="javascript:void(0);" onclick="createGrid(25);" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">G-25</a>
			<a href="javascript:void(0);" onclick="createGrid(30);" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">G-30</a>
			<div style="clear:both;"></div>
		</div>
		<div id="pageSettings" style="padding:1em;border-bottom:1px solid silver;">
			Add Element<br/>
			<a href="javascript:void(0);" onclick="addElem(1);" style="margin-bottom:10px;text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">A</a>
			<a href="javascript:void(0);" onclick="addElem(2);" style="margin-bottom:10px;text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">I</a>
			<a href="javascript:void(0);" onclick="addElem(3);" style="margin-bottom:10px;text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">G</a>
			<a href="javascript:void(0);" onclick="addElem(4);" style="margin-bottom:10px;text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">V</a>
			<a href="javascript:void(0);" onclick="addElem(5);" style="margin-bottom:10px;text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">YT</a>
			<a href="javascript:void(0);" onclick="addElem(6);" style="margin-bottom:10px;text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">H</a>
			<a href="javascript:void(0);" onclick="addElem(7);" style="margin-bottom:10px;text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">iF</a>
			<a href="javascript:void(0);" onclick="addElem(8);" style="margin-bottom:10px;text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">PDF</a>
			<div style="clear:both;"></div>
		</div>
		<div id="pageSettings" style="padding:1em;border-bottom:1px solid silver;">
			<span style="display:inline-block;width:20px;">X:</span><input type="text" style="width:30px;border:1px solid silver;border-radius:3px;" name="x" id="x" />&nbsp;&nbsp;
			<span style="display:inline-block;width:20px;">Y:</span><input type="text" style="width:30px;border:1px solid silver;border-radius:3px;" name="y" id="y" />&nbsp;&nbsp;<span style="display:inline-block;width:20px;">Z:</span><input type="text" style="width:30px;border:1px solid silver;border-radius:3px;" name="z" id="z" /><br/>
			<span style="display:inline-block;width:20px;">W: </span><input type="text" style="width:30px;border:1px solid silver;border-radius:3px;" name="w" id="w" />&nbsp;&nbsp;
			<span style="display:inline-block;width:20px;">H: </span><input type="text" style="width:30px;border:1px solid silver;border-radius:3px;" name="h" id="h" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" value="Set" style="width:30px;border:1px solid silver;border-radius:3px;" name="set" id="set" />
		</div>
		<div id="layers" style="padding:1em;">
			<ul style="margin:0;padding:0;list-style-type:none;">
				<cfloop query="getAllElems">
					<cfquery name="getAllElemsByResolution" datasource="#application.dsn#">
					SELECT	*
					FROM	magazininhaltselemente_#url.device#
					WHERE	magazinInhaltsElementID = #id#
					</cfquery>
					<li style="border-bottom:1px solid silver;padding:0.2em;padding-left:0.2em;position:relative;" id="#id#">
						<div id="visi-#id#" class="<cfif isVisible EQ 1>layerOn<cfelse>layerOff</cfif>" style="width:10px;float:left;color:<cfif isVisible EQ 1>green<cfelse>red</cfif>;font-size:1.2em;"><strong>&bull;</strong></div>
						<div id="elem-#id#" class="layer"><cfif elemName NEQ "">#elemName#<cfelse>[No Layer-Label]</cfif></div>
						<div style="position:absolute;top:0;right:0;width:20px;cursor:pointer;" onclick="delElem(#currentrow#,#id#);void(0);">
							x
						</div>
						<div style="position:absolute;top:0;right:20px;width:20px;cursor:pointer;" id="layerEdit-#id#" class="layerEdit" rel="#id#-<cfif getAllElemsByResolution.recordcount NEQ 0>#getAllElemsByResolution.id#<cfelse>0</cfif>">
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
						<div style="clear:both;"></div>
					</li>
				</cfloop>
			</ul>
		</div>
	</div>
</cfoutput>
<div style="float:left;background:transparent url('/admin/img/<cfoutput>#bgimage#</cfoutput>') left top no-repeat;<cfoutput>width:#canvasWidthX#px;height:#canvasHeightX#px;</cfoutput>">
	<div style="padding:<cfoutput>#padding#</cfoutput>;" id="canvas-wrapper">
		<div id="canvas" class="<cfoutput>#url.device# #url.orientation#</cfoutput>" style="margin-right:20px;float:left;margin-top:0em;width:<cfoutput>#canvasWidth#</cfoutput>px;height:<cfoutput>#canvasHeight#</cfoutput>px;border:1px solid black;background-color:white;position:relative;<cfif evaluate("editMagazinePage.bgimage_" & url.device & "_" & url.orientation) NEQ "">background-image:url('/<cfoutput>#session.serverpath#</cfoutput>/upload/img/<cfoutput>#evaluate("editMagazinePage.bgimage_" & url.device & "_" & url.orientation)#</cfoutput>');</cfif><cfif editMagazinePage.bgcolor NEQ "">background-color:<cfoutput>###editMagazinePage.bgcolor#</cfoutput></cfif>"><!--- background-size:<cfoutput>#canvasWidth#px #canvasHeight#px</cfoutput>; --->
			
			<cfif getAllElems.recordcount GT 0>
				<cfoutput query="getAllElems">
					<cfquery name="getAllElemsByResolution" datasource="#application.dsn#">
					SELECT	*
					FROM	magazininhaltselemente_#url.device#
					WHERE	magazinInhaltsElementID = #id#
					</cfquery>
					<div id="layoutElem-#currentrow#" class="layoutElem" rel="#id#-<cfif getAllElemsByResolution.recordcount NEQ 0>#getAllElemsByResolution.id#<cfelse>0</cfif>" style="<cfif isVisible EQ 0>display:none;</cfif>overflow:hidden;cursor:crosshair;opacity:#opacity#;background-color:###bgcolor#;position:absolute;top:#getAllElemsByResolution.posx#px;left:#getAllElemsByResolution.posy#px;width:#getAllElemsByResolution.width#px;height:#getAllElemsByResolution.height#px;z-index:#zIndex#;"><div class="elemContent" style="cursor:pointer;">
						<cfif image NEQ "">
							<img src="/mirza-in-progress/upload/img/#image#" alt="" style="max-width:100%;" />
						<cfelse>
							#content#
						</cfif>
					</div>
					<!--- <a href="javascript:void(0);" style="display:block;position:absolute;top:5px;right:25px;" onclick="bringToFront(#currentrow#,#id#,<cfif getAllElemsByResolution.id NEQ "">#getAllElemsByResolution.id#<cfelse>0</cfif>);void(0);">[z]</a>
					<a href="javascript:void(0);" style="display:block;position:absolute;top:5px;right:5px;" onclick="delElem(#currentrow#,#id#);void(0);">[x]</a> ---></div>
				</cfoutput>
				<script>
				$(document).ready(function(){
					$('.layoutElem').draggable({
						containment: "#canvas", 
						//grid: [ 10,10 ],
						scroll: false,
						drag: 	function(event,ui){
									xTop = parseInt(ui.position.top);
									xLeft = parseInt(ui.position.left);
									$('#x').val(xLeft);
									$('#y').val(xTop);
								},
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
					$("#layers ul").not('div').sortable({
						//start: function(e){e.preventDefault()},
						helper: fixHelper,
						update: function(){
							//alert('sorted')
							sorted = $(this).sortable( "toArray");
							recalcZindexesOnCanvas(sorted,<cfoutput>#url.editMagazinPage#,'#url.orientation#','#url.device#</cfoutput>');
						}
					});
					$('.layoutElem').resizable({
						 containment: "#canvas",
						 //grid: 10,
						 resize: function(event,ui){
									xWidth = parseInt(ui.size.width);
									xHeight = parseInt(ui.size.height);
									$('#w').val(xWidth);
									$('#h').val(xHeight);
								},
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
					$('.layerEdit').click(function(){//.layoutElem,
						_this = $(this);
						hiliteLayerElem('elem-'+_this.attr('id').split('-')[1])
						 $.fancybox({
							'autoDimensions': true,
							'centerOnScroll': true,
							'type':'ajax',
							'href':'/admin/inc/ajax_magazinForm.cfm?device='+$('#canvas').attr('class').split(' ')[0]+'&id='+_this.attr('rel').split('-')[0]+'&divid='+_this.attr('id')+'&orientation='+$('#canvas').attr('class').split(' ')[1]+'&reselemid='+_this.attr('rel').split('-')[1]
						});
					});
					
					$('.layoutElem').click(function(){//.layoutElem,
						_this = $(this);
						thisID = _this.attr('rel').split('-')[0];
						thisCR = _this.attr('id').split('-')[1];
						
						$('#x').val(parseInt($('#layoutElem-'+thisCR).css('left')));
						$('#y').val(parseInt($('#layoutElem-'+thisCR).css('top')));
						$('#w').val(parseInt($('#layoutElem-'+thisCR).css('width')));
						$('#h').val(parseInt($('#layoutElem-'+thisCR).css('height')));
						$('#z').val(parseInt($('#layoutElem-'+thisCR).css('zIndex')));
						$('.layer').each(function(){	
							if($(this).attr('id').split('-')[1]==thisID){	
								//hideLabelForm();	
								hiliteLayerElem('elem-'+thisID)
								//$('#elem-'+$(this).attr('id').split('-')[1]).parent().css('outline','2px solid red');
							}
							else{
								hideLabelForm();	
								$('#elem-'+$(this).attr('id').split('-')[1]).parent().css('outline','none');
							}
						});	
					});
					
					$('.layer').mouseover(function(){
						_this = $(this);
						thisID = _this.attr('id').split('-')[1];
						$('.layoutElem').each(function(){	
							if($(this).attr('rel').split('-')[0]==thisID){	
								$('#layoutElem-'+$(this).attr('id').split('-')[1]).css({'outline':'2px solid silver',cursor:'pointer'});
							}
							else{
								$('#layoutElem-'+$(this).attr('id').split('-')[1]).css({'outline':'',cursor:'default'});
							}
						});	
					});	
					
					$('.layer').click(function(){
						hiliteLayerElem($(this).attr('id'));
					});
					
					$('.layer').mouseout(function(){
						$('.layoutElem').css('outline','');
					});	
					
					$('.layoutElem').mouseout(function(){
						$('.layoutElem').css('outline','');
					});	
					
					
					
					$('.layoutElem').mouseover(function(){
						_this = $(this);
						thisID = _this.attr('rel').split('-')[0];
						$('.layer').css('outline','')
						$('.layer').each(function(){	
							if($(this).attr('id').split('-')[1]==thisID){	
								//$('#elem-'+$(this).attr('id').split('-')[1]).css('outline','2px solid grey');
							}
							
						});	
					});	
				});
				
				function showLabelForm(divID){	
					wert = $('#'+divID).html();
					$('.layer').html($('input','.layer').val());
					if($('#'+divID).html().indexOf('input')==-1){
						$('#'+divID).html('<input type="text" name="" id="input-'+divID+'" value="'+wert+'" style="width:115px;" /><input type="submit" name="" value="&gt;" style="width:20px;" />');
						$('#input-'+divID).next().click(function(){
							
							$.post('/admin/inc/ajax_updateLayers.cfm',{
								pageID:	<cfoutput>#url.editMagazinPage#</cfoutput>,
								elemID: divID.split('-')[1],
								orientation: <cfoutput>'#url.orientation#'</cfoutput>,
								device: <cfoutput>'#url.device#'</cfoutput>,
								label: $('#input-'+divID).val()
							},function(data){
								$('#'+divID).html($('#input-'+divID).val());
								$('#'+divID).click(function(){
									hiliteLayerElem($(this).attr('id'));
								});	
							});
						});
					}
					else if($('#'+divID).html().indexOf('input')>-1){
						$('#'+divID).focus	
			
					}
				}
				
				function hideLabelForm(){
					$('input[type=text]','#layers').each(function(){
						//$(this).parent().parent().unbind('click')
						wert = $(this).val();
						
						$(this).parent().html(wert);	
						$(this).parent().parent().click(function(){
							hiliteLayerElem($(this).attr('id'));
							
						});
					});	
				}
				
				function hiliteLayerElem(layerDivID){
					id = layerDivID.split('-')[1]
					idx = $('.layoutElem[rel*='+id+'-]').attr('id').split('-')[1]
					hideLabelForm(layerDivID);	
					$('.layerOff,.layerOn').unbind('click')
					if($('#'+layerDivID).parent().attr('style').indexOf('red')>-1){
						$('#'+layerDivID).parent().unbind('click')
						showLabelForm(layerDivID);
					}
					else{
						$('.layer').parent().css('outline','')
						$('#'+layerDivID).parent().css('outline','2px solid red')	
						$('#x').val(parseInt($('#layoutElem-'+idx).css('left')));
						$('#y').val(parseInt($('#layoutElem-'+idx).css('top')));
						$('#w').val(parseInt($('#layoutElem-'+idx).css('width')));
						$('#h').val(parseInt($('#layoutElem-'+idx).css('height')));
						$('#z').val(parseInt($('#layoutElem-'+idx).css('zIndex')));
						$('#set').click(function(){
							$('#layoutElem-'+idx).css({
								left:$('#x').val()+'px',
								top:$('#y').val()+'px',
								width:$('#w').val()+'px',
								height:$('#h').val()+'px',
								zIndex:$('#z').val()
							});
							$.post('/admin/inc/ajax_updateMagazinElement.cfm',{
								id: 	id,
								posX: 	$('#y').val(),
								posY: 	$('#x').val(),
								width: $('#w').val(),
								height: $('#h').val(),
								pageID:	<cfoutput>#url.editMagazinPage#</cfoutput>,
								orientation:  <cfoutput>'#url.orientation#'</cfoutput>,
								device:  <cfoutput>'#url.device#'</cfoutput>,
								resElemID: $('#layoutElem-'+idx).attr('rel').split('-')[1]
							});	
						});
						$('#visi-'+layerDivID.split('-')[1]).click(function(){
							if($(this).hasClass('layerOn')){
								visi = 0;
								$(this).attr('class','layerOff')
								$(this).css('color','red')
								$('#layoutElem-'+idx).css('display','none');
							}
							else{
								visi = 1;
								$(this).attr('class','layerOn')
								$(this).css('color','green')
								$('#layoutElem-'+idx).css('display','block');
							}
							$.post('/admin/inc/ajax_updateLayers.cfm',{
								pageID:	<cfoutput>#url.editMagazinPage#</cfoutput>,
								elemID: id,
								orientation: <cfoutput>'#url.orientation#'</cfoutput>,
								device: <cfoutput>'#url.device#'</cfoutput>,
								visible: visi
							});
						});
					}
					
				}
				
				function recalcZindexesOnCanvas(sortList,pageID,orientation,device){
					// update db			
					$.post('/admin/inc/ajax_updateLayers.cfm',{
						pageID:	pageID,
						orientation: orientation,
						device: device,
						sortList: sortList.toString() 
					},function(data){
						// redraw canvas / zIndexes		
						cnt = (sortList.length*10)+10;
						for(i=0;i<sortList.length;i++){
							idc = $('.layoutElem[rel*='+sortList[i]+'-]').attr('id').split('-')[1]
							$('#layoutElem-'+idc).css('z-index',cnt-10);
							cnt = cnt - 10;	
						}
					});
				}
				
				function createGrid(size) {
					$('.grid').remove();
					var ratioW = Math.floor($('#canvas').width()/size),
						ratioH = Math.floor($('#canvas').height()/size);
					
					var parent = $('<div />', {
						class: 'grid', 
						width: ratioW  * size, 
						height: ratioH  * size
					}).addClass('grid').appendTo('#canvas');
				
					for (var i = 0; i < ratioH; i++) {
						for(var p = 0; p < ratioW; p++){
							$('<div />', {
								width: size - 1, 
								height: size - 1
							}).appendTo(parent);
						}
					}
				}
				
				
				</script>
			</cfif> 
		</div>
	</div>
</div>
<div style="clear:both;"></div>
</div>
	</div>