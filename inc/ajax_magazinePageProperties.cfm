<cfprocessingdirective pageencoding="utf-8" />
<script>
	function autolaunchOption(nr){
		if(nr>0){
			$('#launchOptions').css('display','block');
			$('#autoLaunch-'+nr).css('display','block');
		}
	}
	
	function callback_example(){
		var cw = Raphael.colorwheel($("#callback_example .colorwheel")[0],150),
		onchange_el = $("#color")
		cw.color("#F00");
		cw.onchange(function(color){
			var colors = [parseInt(color.r), parseInt(color.g), parseInt(color.b)]
			if(!$('#nogbcolor').attr('checked')){
				onchange_el.css("background", color.hex);
				$('#color').val(color.hex.replace('#',''));
				$('#canvas').css('background-color',color.hex);
			}
			else{
				$('#color').val('');
				$('#canvas').css('background-color','');
			}
		})
	
	}
	
	function showRequest(formData, jqForm, options) { 
		// formData is an array; here we use $.param to convert it to a string to display it 
		// but the form plugin does this for you automatically when it submits the data 
		var queryString = $.param(formData); 
	 
		// jqForm is a jQuery object encapsulating the form element.  To access the 
		// DOM element for the form do this: 
		// var formElement = jqForm[0]; 
	 
		//alert('About to submit: \n\n' + queryString); 
	 
		// here we could return false to prevent the form from being submitted; 
		// returning anything other than false will allow the form submit to continue 
		return true; 
	} 
	
	$(document).ready(function(){
		var options = { 
			//target:        '#canavs',
			success:       function(responseText)  { 
								if(responseText==0){
									alert('Das Bild war nicht gross genug! Die restlichen Anhaben wurdengespeichert!');
									$.fancybox.close();
								}
								else{
									$('#canvas').css('background','transparent url("/<cfoutput>#session.serverpath#</cfoutput>/upload/img/'+responseText+'") left top no-repeat');
									$.fancybox.close();
								}
							},
			url:       '/admin/inc/ajax_upload.cfm', 
			type:      'post'

		}; 
		
		// bind form using 'ajaxForm' 
		$('#pagePropsForm').ajaxForm(options);
		callback_example(); 
		
		
		$('#nogbcolor').bind('change',function(){
			if($('#nogbcolor').attr('checked')){
				$('#color').val('');
				$('#canvas').css('background-color','');
			}
		});
		
		
	});	
</script>

<cfquery name="editMagazinePage" datasource="#application.dsn#">
SELECT	*
FROM	magazinseiten
WHERE	id = #url.pageID#
</cfquery>
<cfoutput>
<div style="width:600px;">
	<form id="pagePropsForm">
		<table width="100%">
		<tr>
			<td>
				Titel:
			</td>
			<td>
				<input type="text" name="titel" id="titel" value="#editMagazinePage.titel#" />
			</td>
		</tr>
		<tr>
			<td valign="top">
				Hintergrundfarbe
			</td>
			<td style="position:relative;">
				<input type="hidden" name="color" id="color" value="#editMagazinePage.bgcolor#"> 
				<div id="show_off"></div>
				 <div id="callback_example" class="example">
					<div>
					  <div style="width:100%; margin-bottom:20px">
						<div class="colorwheel"></div>
					  </div>
					</div>
				  </div>
				  
				  <div style="position:absolute;top:40px;right:0;width:220px;">
				  	<input type="checkbox" name="nobgcolor" value="1" id="nogbcolor" /> keine Hintergrundfarbe
				  </div>
			</td>
		</tr>
		<tr>
			<td>
				Auto-Launch:
			</td>
			<td>
				<select name="autolaunch" id="autolaunch" onchange="autolaunchOption($(this).val());">
					<option value="0">----</option>
					<option value="1">Lightbox-Infobox</option>
					<option value="2">Werbung</option>
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<div id="launchOptions" style="display:none;">
					<div id="autoLaunch-1" style="display:none;">
						<textarea rows="0" cols="0" style="width:100%;height:60px;" name="" id=""></textarea>
					</div>
					<div id="autoLaunch-2" style="display:none;">
						<select name="ad" id="ad">
							<option value="1">Werbung 1</option>
							<option value="2">Werbung 2</option>
						</select><br/>
						<select name="adTime">
							<option value="1">1 Sek</option>
							<option value="2">2 Sek</option>
							<option value="3">3 Sek</option>
							<option value="4">4 Sek</option>
							<option value="5">5 Sek</option>
							<option value="6">6 Sek</option>
							<option value="7">7 Sek</option>
							<option value="8">8 Sek</option>
							<option value="9">9 Sek</option>
							<option value="10">10 Sek</option>
						</select>
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				Hintergrundbild:
			</td>
			<td>
				<!--- <cfif evaluate("editMagazinePage.bgimage_" & url.device & "_" & url.orientation) NEQ "">
					<a href="/#session.serverpath#/upload/img/#evaluate("editMagazinePage.bgimage_" & url.device & "_" & url.orientation)#" target="_blank">#evaluate("editMagazinePage.bgimage_" & url.device & "_" & url.orientation)#</a>
				</cfif> --->
				<input type="file" name="hg" id="hg" />
				<cfif evaluate("editMagazinePage.bgimage_" & url.device & "_" & url.orientation) NEQ "">
			
					<input type="checkbox" name="delhg" value='#evaluate("editMagazinePage.bgimage_" & url.device & "_" & url.orientation)#' /> löschen
				</cfif>
			</td>
		</tr>
		<tr>
			<td>
				Swipe-Richtungen
			</td>
			<td>
				<input type="checkbox" name="sdtop" value="1" /> oben
				<input type="checkbox" name="sdright" value="1" /> rechts
				<input type="checkbox" name="sdbottom" value="1" /> unten
				<input type="checkbox" name="sdleft" value="1" /> links
				
			</td>
		</tr>
		<tr>
			<td>
				Auto-SlideIn
			</td>
			<td>
				<input type="radio" name="asnone" value="0" /> ---
				<input type="radio" name="astop" value="1" /> oben
				<input type="radio" name="asright" value="1" /> rechts
				<input type="radio" name="asbottom" value="1" /> unten
				<input type="radio" name="asleft" value="1" /> links
				
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<input type="submit" value="Speichern" />
				<input type="hidden" name="pageID" value="#url.pageid#" />
				<input type="hidden" name="orientation" value="#url.orientation#" />
				<input type="hidden" name="device" value="#url.device#" />
			</td>
		</tr>
		</table>
	</form>
</div></cfoutput>