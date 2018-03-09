<cfprocessingdirective pageencoding="utf-8" />


<script>
function addElem(){
	//count existing elements
	anzahl = $('.layoutElem').length;
	newAnzahl = anzahl + 1;
	//if 0 elems
	if(anzahl == 0){
		posX = 10;
		p = posX;
		z = 10;
	}
	// if already existing elems
	else{
		g = $('#layoutElem-'+anzahl);
		posX = g.position();
		p = posX.left + 10;
		f = g.css('z-index');
		z = parseInt(f) + 1;
	}
	
	newDiv = $('<div id="layoutElem-'+newAnzahl+'" class="layoutElem" rel="" style="cursor:crosshair;opacity:0.6;padding:10px;background-color:#eee;position:absolute;top:'+p+'px;left:'+p+'px;width:200px;height:100px;z-index:'+z+';"><div class="elemContent" style="cursor:pointer;"></div></div>');
	
	z = $('#layoutElem-'+newAnzahl).css('z-index');
	$.post('/admin/inc/ajax_insertMagazinElement.cfm',{
		pageID:	2,
		width: 	200,
		height:	100,
		posX: 	p,
		posY: 	p,
		color: 'cccccc',
		zIndex:	z
	},function(data){
		$('#layoutElem-'+newAnzahl).attr('rel',data);
		$('#canvas').append(newDiv);
		bringToFront(newAnzahl,data);
		$('#layoutElem-'+newAnzahl).draggable({
			containment: "#canvas", 
			scroll: false,
			stop:	function(event,ui){
						xZindex = z;
						xTop = parseInt(ui.position.top);
						xLeft = parseInt(ui.position.left);
						//$('span',this).html('z-index:'+xZindex+'<br/>top:'+xTop+'<br/>left:'+xLeft);
						//post data into db and update record
						$.post('/admin/inc/ajax_updateMagazinElement.cfm',{
							id: 	$(this).attr('rel'),
							posX: 	xTop,
							posY: 	xLeft,
							pageID:	2
						});	
					}
		}); 
		$('#layoutElem-'+newAnzahl).resizable({
			 containment: "#canvas",
			 stop:	function(event,ui){
						xWidth = parseInt(ui.size.width);
						xHeight = parseInt(ui.size.height);
						//$('b',this).html('width:'+xWidth+'<br/>height:'+xHeight);
						//post data into db and update record
						$.post('/admin/inc/ajax_updateMagazinElement.cfm',{
							id: 	$(this).attr('rel'),
							width: 	xWidth,
							height:	xHeight,
							pageID:	2
						});					
					},
			 minWidth: $('div.elemContent','#layoutElem-'+newAnzahl).width(),
			 minHeight: $('div.elemContent','#layoutElem-'+newAnzahl).height()
		});
		//bring to front
		/*$('#layoutElem-'+newAnzahl).dblclick(function(e){
			e.preventDefault();
			zIndex = 0;
			$('.layoutElem').each(function(){
				if($(this).css('zIndex')>zIndex){
					zIndex = $(this).css('zIndex',zIndex);	
				}
			});
			//post data into db and update record
			$.post('/admin/inc/ajax_updateMagazinElement.cfm',{
				id: 	$(this).attr('rel'),
				zIndex:	zIndex,
				pageID:	2
			});
			$(this).css('zIndex',parseInt(zIndex)+1);
		});*/
		// get form
		$('#layoutElem-'+newAnzahl).click(function(){
			$.get('/admin/inc/ajax_magazinForm.cfm',{id:$(this).attr('rel'),divid:$(this).attr('id')},function(data){
				$('#targetForm').html(data);
			});
		});
	});	

}

function bringToFront(x,y){
	var zIndex = 0;
	$('.layoutElem').each(function(){
		if($(this).css('z-index')>parseInt(zIndex)){
			zIndex = $(this).css('z-index');	
		}
	});
	newZIndex = parseInt(zIndex)+1;
	//post data into db and update record
	$.post('/admin/inc/ajax_updateMagazinElement.cfm',{
		id: 	y,
		zIndex:	newZIndex,
		pageID:	2
	});
	$('#layoutElem-'+x).css('z-index',newZIndex);
}

function delElem(id,dbid){
	$('#layoutElem-'+id).remove();
	//post data into db and delete record
	$.post('/admin/inc/ajax_delMagazinElement.cfm',{
		id: dbid
	});	
}

function postForm(id,divID){
	$.post("/admin/inc/ajax_updateMagazinElement.cfm?elemID="+id, $("#formular").serialize(),function(data){
		$('.elemContent','#'+divID).html(data);	
	});	
}
</script>

<!--- get all elems from db --->
<cfquery name="getAllElems" datasource="#application.dsn#">
SELECT	*
FROM	magazininhaltselemente
WHERE	magazinPageID = 2
</cfquery>


<div id="canvas" style="margin-right:20px;float:left;margin-top:0em;width:800px;height:1170px;border:1px solid black;background-color:white;position:relative;background-image:url('/admin/img/timroth.jpg');background-size:800px 1280px;">
	&nbsp;
	<cfif getAllElems.recordcount GT 0>
		<cfoutput query="getAllElems">
			<div id="layoutElem-#currentrow#" class="layoutElem" rel="#id#" style="overflow:hidden;cursor:crosshair;opacity:#opacity#;padding:10px;background-color:###bgcolor#;position:absolute;top:#posx#px;left:#posy#px;width:#width#px;height:#height#px;z-index:#zIndex#;"><div class="elemContent" style="cursor:pointer;">#content#</div><a href="javascript:void(0);" style="display:block;position:absolute;top:5px;right:25px;" onclick="bringToFront(#currentrow#,#id#);void(0);">[z]</a><a href="javascript:void(0);" style="display:block;position:absolute;top:5px;right:5px;" onclick="delElem(#currentrow#,#id#);void(0);">[x]</a></div>
		</cfoutput>
		<script>
		$(document).ready(function(){
			$('.layoutElem').draggable({
				containment: "#canvas", 
				scroll: false,
				stop:	function(event,ui){
							xZindex = 1;
							xTop = parseInt(ui.position.top);
							xLeft = parseInt(ui.position.left);
							//$('span',this).html('z-index:'+xZindex+'<br/>top:'+xTop+'<br/>left:'+xLeft);
							//post data into db and update record
							$.post('/admin/inc/ajax_updateMagazinElement.cfm',{
								id: 	$(this).attr('rel'),
								posX: 	xTop,
								posY: 	xLeft,
								pageID:	2
							});	
						}
			}); 
			$('.layoutElem').resizable({
				 containment: "#canvas",
				 stop:	function(event,ui){
						xWidth = parseInt(ui.size.width);
						xHeight = parseInt(ui.size.height);
						//$('b',this).html('width:'+xWidth+'<br/>height:'+xHeight);
						//post data into db and update record
						$.post('/admin/inc/ajax_updateMagazinElement.cfm',{
							id: 	$(this).attr('rel'),
							width: 	xWidth,
							height:	xHeight,
							pageID:	2
						});					
				}/*,
				minWidth: $('div.elemContent',$(this)).width(),
				minHeight: $('div.elemContent',$(this)).height()*/
			});
			//bring to front
			/*$('.layoutElem').dblclick(function(e){
				e.preventDefault();
				zIndex = 0;
				$('.layoutElem').each(function(){
					if($(this).css('z-index')>zIndex){
						zIndex = $(this).css('z-index',zIndex);	
					}
				});
				
				//post data into db and update record
				$.post('/admin/inc/ajax_updateMagazinElement.cfm',{
					id: 	$(this).attr('rel'),
					zIndex:	zIndex+1,
					pageID:	2
				});
				$(this).css('z-Index',parseInt(zIndex)+1);
			});*/
			// get form
			$('.layoutElem').click(function(){
				$.get('/admin/inc/ajax_magazinForm.cfm',{id:$(this).attr('rel'),divid:$(this).attr('id')},function(data){
					$('#targetForm').html(data);
				});
			});
		});
		</script>
	</cfif>
</div>
<div style="float:left;">

		Hier kommt das Form für:<br/>
		<div id="targetForm"></div>
	
	<a href="javascript:void(0);" onclick="addElem();">add Element</a>
</div>
<div class="clear"></div>
<!--- <cfoutput>
<form action="#cgi.SCRIPT_NAME#?action=submittedNewMagazinSeite" method="post" enctype="multipart/form-data">
	<table width="100%">
	<tr>
		<td>
			Variable
		</td>
		<td>
			<input type="text" name="variable">
		</td>
	</tr>
	<tr>
		<td>
			Hilfe-Text
		</td>
		<td>
			<textarea name="helpText"  class="ckeditor" id="helpText" cols="1" rows="1" style="width:100%;height:500px;"></textarea>
		</td>
	</tr>
	<tr>
		<td colspan="6">
			<input type="submit" value="speichern" />  <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';">
			<input type="hidden" name="moduleid" value="#url.moduleid#" />
		</td>
	</tr>
	</table>
</form>
</cfoutput> --->