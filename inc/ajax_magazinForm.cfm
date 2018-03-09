<cfprocessingdirective pageencoding="utf-8" />

<cfquery name="get" datasource="#application.dsn#">
SELECT * FROM magazininhaltselemente
WHERE id = #url.id#
</cfquery>

<cfquery name="getAllLayers" datasource="#application.dsn#">
SELECT * FROM magazininhaltselemente
WHERE magazinPageID = #get.magazinPageID# AND orientation = <cfif url.orientation EQ "portrait">1<cfelse>0</cfif>
</cfquery>

<cfquery name="getPage" datasource="#application.dsn#">
SELECT * FROM magazinseiten
WHERE id = #get.magazinPageID#
</cfquery>

<cfquery name="getChapter" datasource="#application.dsn#">
SELECT * FROM magazinkapitel
WHERE id = #getPage.parent#
</cfquery>

<cfquery name="getAllChapters" datasource="#application.dsn#">
SELECT 	S.* 
FROM 	magazinkapitel K LEFT JOIN
		magazinseiten S ON S.parent = K.id
WHERE 	K.magazinAusgabeID = #getChapter.magazinAusgabeID#
GROUP	BY K.id
ORDER	BY K.reihenfolge,S.reihenfolge
</cfquery>


<script>
	$('#action').change(function(){
		$('#action-toggle').hide()
		$('#action-flip').hide()
		$('#action-jump').hide()
		$('#action-lightbox').hide()
		$('#action-show').hide()
		$('#action-hide').hide()
		type = $('#action option:selected').val();
		
		if(type!=''){
			$('#action-'+type).show()
		}
	});
</script>

<cfset url.type = get.contentType />



	<div id="tabs">
		<ul>
			<li><a href="#tabs-1">Inhalt</a></li>
			<li><a href="#tabs-2">Optionen</a></li>
			<li><a href="#tabs-3">Aktion</a></li>
		</ul>
	
		<form id="formular" enctype="multipart-form-data">
			<input type="hidden" name="id" value="<cfoutput>#url.id#</cfoutput>" />
			<input type="hidden" name="type" value="<cfoutput>#url.type#</cfoutput>" />
			<cfif url.type EQ 1>
				<cfquery name="getContent" datasource="#application.dsn#">
				SELECT * FROM magazininhaltselement_text
				WHERE inhaltsElementID = #url.id#
				</cfquery>
				<div style="width:750px;" id="tabs-1">
					<textarea name="inhalt" id="inhalt" class="ckeditor"><cfoutput>#get.content#</cfoutput></textarea>
					<cfoutput>
						<input type="hidden" name="divid" value="#url.divid#" />
						<input type="hidden" name="magazinPageID" value="1" />
						<input type="hidden" name="device" value="#url.device#" />
						<input type="hidden" name="orientation" value="<cfif url.orientation EQ "portrait">1<cfelse>0</cfif>" />
						<input type="hidden" name="resElemID" value="#url.resElemID#" />
					</cfoutput>
				</div>
				
				<div id="tabs-2" style="width:750px;">
					Opacity:<br/>
					<div id="slider" style="width:95%;"></div><br/><br/>
					<input type="hidden" name="opacity" id="opacity" value="<cfoutput>#get.opacity#</cfoutput>" />
					Hintergrundfarbe<br/>
					<input type="hidden" name="color" id="color" value="<cfoutput>#get.bgcolor#</cfoutput>"> 
					<div id="show_off"></div>
					 <div id="callback_example" class="example">
						<div>
						  <div style="float:left; width:100%; margin-bottom:20px">
							<div class="colorwheel" style="float:left; margin-right:20px; width:300px; text-align:left;"></div>
						  </div>
						</div>
					  </div>
					<br />
				</div>
			<cfelseif url.type EQ 2>
				
				<script src="/admin/js/jquery.multifile.js" type="text/javascript"></script>
				
				<cfquery name="getContent" datasource="#application.dsn#">
				SELECT * FROM magazininhaltselement_bild
				WHERE inhaltsElementID = #url.id#
				</cfquery>
				<div style="width:750px;" id="tabs-1">
					
					<cfdirectory action="list" directory="#expandPath('/' & session.serverpath & '/upload/img')#" name="dir">
					<div style="height:300px;overflow:scroll;">
						<cfoutput query="dir">
							<cfif type EQ "file">
								<!--- <img src="/#session.serverpath#/upload/img/#name#" height="20" /> --->#name#<br/>
							</cfif>
						</cfoutput> 
					</div>
				</div>
				<div style="width:750px;" id="tabs-2">
					Bild: <input type="file" id="fileselect" name="fileselect[]" multiple="multiple" /><br/>
					<input type="hidden" id="MAX_FILE_SIZE" name="MAX_FILE_SIZE" value="300000" />
					<div id="filedrag">or drop files here</div>
					<div id="progress"></div>
					<div id="messages"></div>
					<textarea name="legende" id="legende"><cfoutput>#getContent.legende#</cfoutput></textarea>
				</div>
			<cfelseif url.type EQ 3>
				<cfquery name="getContent" datasource="#application.dsn#">
				SELECT * FROM magazininhaltselement_galerie
				WHERE inhaltsElementID = #url.id#
				</cfquery>
				<div style="width:750px;" id="tabs-1">
				
				</div>
				<div style="width:750px;" id="tabs-2">
				
				</div>
			<cfelseif url.type EQ 4>
				<cfquery name="getContent" datasource="#application.dsn#">
				SELECT * FROM magazininhaltselement_video
				WHERE inhaltsElementID = #url.id#
				</cfquery>
				<div style="width:750px;" id="tabs-1">
				
				</div>
				<div style="width:750px;" id="tabs-2">
				
				</div>
			<cfelseif url.type EQ 5>
				<cfquery name="getContent" datasource="#application.dsn#">
				SELECT * FROM magazininhaltselement_youtube
				WHERE inhaltsElementID = #url.id#
				</cfquery>
				<div style="width:750px;" id="tabs-1">
				
				</div>
				<div style="width:750px;" id="tabs-2">
				
				</div>
			<cfelseif url.type EQ 6>
				<cfquery name="getContent" datasource="#application.dsn#">
				SELECT * FROM magazininhaltselement_html
				WHERE inhaltsElementID = #url.id#
				</cfquery>
				<div style="width:750px;" id="tabs-1">
				
				</div>
				<div style="width:750px;" id="tabs-2">
				
				</div>
			<cfelseif url.type EQ 7>
				<cfquery name="getContent" datasource="#application.dsn#">
				SELECT * FROM magazininhaltselement_iframe
				WHERE inhaltsElementID = #url.id#
				</cfquery>
				<div style="width:750px;" id="tabs-1">
				
				</div>
				<div style="width:750px;" id="tabs-2">
				
				</div>
			<cfelseif url.type EQ 8>
				<cfquery name="getContent" datasource="#application.dsn#">
				SELECT * FROM magazininhaltselement_pdf
				WHERE inhaltsElementID = #url.id#
				</cfquery>
				<div style="width:750px;" id="tabs-1">
					PDF: <input type="file" name="pdf" />
				</div>
				<div style="width:750px;" id="tabs-2">
				
				</div>
			</cfif>
						
			<div id="tabs-3" style="width:750px;">
				<select name="action" id="action">
					<option value="">
						-- bitte wählen ---
					</option>
					<option value="flip">
						Flip
					</option>
					<option value="toggle">
						Toggle
					</option>
					<option value="jump">
						JumpTo
					</option>
					<option value="lightbox">
						openLightbox
					</option>
					<option value="show">
						show Layer
					</option>
					<option value="hide">
						hide Layer
					</option>
				</select>
				
				<div id="action-flip" style="display:none;">
					<select name="flipLayer">
						<cfoutput query="getAllLayers">
							<option value="#id#">
								<cfif elemName NEQ "">#elemName#<cfelse>No Layer Label</cfif>
							</option>
						</cfoutput>
					</select>	
				</div>
				
				<div id="action-toggle" style="display:none;">
					<select name="toggleLayer">
						<cfoutput query="getAllLayers">
							<option value="#id#">
								<cfif elemName NEQ "">#elemName#<cfelse>No Layer Label</cfif>
							</option>
						</cfoutput>
					</select>	
				</div>
				
				<div id="action-jump" style="display:none;">
					<select name="jumpToPage">
						<cfoutput query="getAllChapters">
							<cfoutput>
								<option value="#id#">
									<cfif titel NEQ "">#titel#<cfelse>No Page Label</cfif>
								</option>
							</cfoutput>
						</cfoutput>
					</select>
				</div>
				
				<div id="action-lightbox" style="display:none;">
					<select name="lightboxLayer">
						<cfoutput query="getAllLayers">
							<option value="#id#">
								<cfif elemName NEQ "">#elemName#<cfelse>No Layer Label</cfif>
							</option>
						</cfoutput>
					</select>	
				</div>
				
				<div id="action-show" style="display:none;">
					<select name="showLayer">
						<cfoutput query="getAllLayers">
							<option value="#id#">
								<cfif elemName NEQ "">#elemName#<cfelse>No Layer Label</cfif>
							</option>
						</cfoutput>
					</select>
				</div>
				
				<div id="action-hide" style="display:none;">
					<select name="hideLayer">
						<cfoutput query="getAllLayers">
							<option value="#id#">
								<cfif elemName NEQ "">#elemName#<cfelse>No Layer Label</cfif>
							</option>
						</cfoutput>
					</select>
				</div>

			</div>
			<br/><br/>
			<input type="submit" value="speichern" id="send" />
		</form>
	</div>
</div>
	



<script type="text/javascript">

<cfif url.type EQ 1>
	myFonts = ['Aclonica', 'Allan', 'Allerta', 'Allerta Stencil', 'Amaranth', 'Angkor', 'Annie Use Your Telescope', 'Anonymous Pro', 'Anton', 'Architects Daughter', 'Arimo', 'Artifika', 'Arvo', 'Astloch', 'Bangers', 'Battambang', 'Bayon', 'Bentham', 'Bevan', 'Bigshot One', 'Bokor', 'Brawler', 'Cabin', 'Cabin Sketch', 'Calligraffitti', 'Candal', 'Cantarell', 'Cardo', 'Carter One', 'Caudex', 'Chenla', 'Cherry Cream Soda', 'Chewy', 'Coda', 'Coming Soon', 'Content', 'Copse', 'Corben', 'Cousine', 'Covered By Your Grace', 'Crafty Girls', 'Crimson Text', 'Crushed', 'Cuprum', 'Damion', 'Dancing Script', 'Dangrek', 'Dawning of a New Day', 'Didact Gothic', 'Droid Sans', 'Droid Sans Mono', 'Droid Serif', 'EB Garamond', 'Expletus Sans', 'Fontdiner Swanky', 'Francois One', 'Freehand', 'GFS Didot', 'GFS Neohellenic', 'Geo', 'Goudy Bookletter 1911', 'Gruppo', 'Hanuman', 'Holtwood One SC', 'Homemade Apple', 'IM Fell DW Pica', 'IM Fell DW Pica SC', 'IM Fell Double Pica', 'IM Fell Double Pica SC', 'IM Fell English', 'IM Fell English SC', 'IM Fell French Canon', 'IM Fell French Canon SC', 'IM Fell Great Primer', 'IM Fell Great Primer SC', 'Inconsolata', 'Indie Flower', 'Irish Grover', 'Josefin Sans', 'Josefin Slab', 'Judson', 'Jura', 'Just Another Hand', 'Just Me Again Down Here', 'Kenia', 'Khmer', 'Koulen', 'Kranky', 'Kreon', 'Kristi', 'Lato', 'League Script', 'Lekton', 'Limelight', 'Lobster', 'Lora', 'Luckiest Guy', 'Maiden Orange', 'Mako', 'Maven Pro', 'Meddon', 'MedievalSharp', 'Megrim', 'Merriweather', 'Metal', 'Metrophobic', 'Michroma', 'Miltonian', 'Miltonian Tattoo', 'Molengo', 'Monofett', 'Moul', 'Moulpali', 'Mountains of Christmas', 'Muli', 'Neucha', 'Neuton', 'News Cycle', 'Nobile', 'Nova Cut', 'Nova Flat', 'Nova Mono', 'Nova Oval', 'Nova Round', 'Nova Script', 'Nova Slim', 'Nova Square', 'Nunito', 'OFL Sorts Mill Goudy TT', 'Odor Mean Chey', 'Old Standard TT', 'Open Sans', 'Orbitron', 'Oswald', 'Over the Rainbow', 'PT Sans', 'PT Sans Caption', 'PT Sans Narrow', 'PT Serif', 'PT Serif Caption', 'Pacifico', 'Paytone One', 'Permanent Marker', 'Philosopher', 'Play', 'Playfair Display', 'Podkova', 'Preahvihear', 'Puritan', 'Quattrocento', 'Quattrocento Sans', 'Radley', 'Raleway', 'Reenie Beanie', 'Rock Salt', 'Rokkitt', 'Ruslan Display', 'Schoolbell', 'Shanti', 'Siemreap', 'Sigmar One', 'Six Caps', 'Slackey', 'Smythe','Special Elite', 'Sue Ellen Francisco', 'Sunshiney', 'Suwannaphum', 'Swanky and Moo Moo', 'Syncopate', 'Tangerine', 'Taprom', 'Tenor Sans', 'Terminal Dosis Light', 'The Girl Next Door', 'Tinos', 'Ubuntu', 'Ultra', 'UnifrakturMaguntia', 'Unkempt', 'VT323', 'Vibur', 'Vollkorn', 'Waiting for the Sunrise', 'Wallpoet', 'Walter Turncoat', 'Wire One', 'Yanone Kaffeesatz'];
	
	font_names = 'serif;sans serif;monospace';
	
	for(var i = 0; i<myFonts.length; i++){
		  font_names = font_names+';'+myFonts[i];
		  myFonts[i] = 'http://fonts.googleapis.com/css?family='+myFonts[i].replace(' ','+');
	}
	
	var editor = CKEDITOR.instances['inhalt'];
	if (editor) { editor.destroy(true); }
	CKEDITOR.replace('inhalt',{
		//contentsCss : 'body{background-color:#<cfoutput>#get.bgcolor#</cfoutput>;}'
		toolbar: [['Source','Font','FontSize','TextColor','Paste', 'PasteFromWord', 'Bold', 'Italic', 'Underline', 'Link', 'Unlink', 'Image', 'Table', 'HorizontalRule', 'BGColor', 'CreateDiv', 'Maximize', 'ShowBlocks']],
		font_names: font_names,
		contentsCss: ['/admin/js/ckeditor/contents.css'].concat(myFonts)
	});
	
	function setColor(divID,color){
		if(color==''){
			$('#'+divID).css('background-color','transparent');
		}
		else{
			$('#'+divID).css('background-color','#'+color);	
		}
		
	}
	
	function callback_example(){
		var cw = Raphael.colorwheel($("#callback_example .colorwheel")[0],150),
		onchange_el = $("#color")
		cw.color("#F00");
		cw.onchange(function(color){
			var colors = [parseInt(color.r), parseInt(color.g), parseInt(color.b)]
			onchange_el.css("background", color.hex);
			$('#color').val(color.hex.replace('#',''));
			setColor('<cfoutput>#url.divid#</cfoutput>',color.hex);
			CKEDITOR.instances.inhalt.document.getBody().setStyle('background-color', color.hex);
		})
	
	}
</cfif>


$( "#slider" ).slider({
	min:0.1,
	max:1,
	step:0.1,
	value:<cfoutput>#get.opacity#</cfoutput>,
	slide: function(event,ui){
		$('#opacity').val(ui.value);	
		$('#<cfoutput>#url.divid#</cfoutput>').css('opacity',ui.value);
	}
});



$(document).ready(function(){
	$( "#tabs" ).tabs();
	<cfif url.type EQ 1>
	callback_example(); 
	</cfif>
	var options = { 
		beforeSubmit: function(arr, $form, options) {
						// validate form
						// disable button
						// show loading wheel
					},
		success:    function(responseText)  { 
						if(responseText==0){
							//alert('Das Bild war nicht gross genug! Die restlichen Angaben wurdengespeichert!');
							$.fancybox.close();
						}
						else{
							
							idx = $('.layoutElem[rel*='+<cfoutput>#url.id#</cfoutput>+'-]').attr('id').split('-')[1]
							$('.elemContent','#layoutElem-'+idx).html(responseText);
						
							$.fancybox.close();
						}
					},
		url:       '/admin/inc/ajax_updateMagazinElement.cfm', 
		type:      'post'
	}; 

	$('#formular').ajaxForm(options);
  })
</script>

