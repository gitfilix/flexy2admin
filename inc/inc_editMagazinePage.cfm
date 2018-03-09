<cfprocessingdirective pageencoding="utf-8" />

<cfhtmlhead text='
	<script src="/admin/js/raphael.js" type="text/javascript"></script>
	<script src="/admin/js/colorwheel.js" type="text/javascript"></script>
	<script src="/admin/js/ajaxForm.js" type="text/javascript"></script>
	<!--- <link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:400,900,700,600,200,300|Muli:400,300|Gentium+Basic:400,700|Cabin:400,500,600,700|Julius+Sans+One|Open+Sans:400,300,600,700,800|Raleway:400,200,300,500,700,800,900|Dosis:400,300,600,700,500|Fjalla+One|Arvo:400,700|Josefin+Slab:400,300,600,700|Lato:400,300,700,900|PT+Sans:400,700&subset=latin,latin-ext" rel="stylesheet" type="text/css" /> --->
	<link href="http://fonts.googleapis.com/css?family=Aclonica" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Allan" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Allerta" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Allerta+Stencil" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Amaranth" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Angkor" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Annie+Use Your Telescope" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Anonymous+Pro" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Anton" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Architects+Daughter" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Arimo" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Artifika" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Arvo" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Astloch" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Bangers" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Battambang" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Bayon" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Bentham" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Bevan" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Bigshot+One" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Bokor" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Brawler" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Cabin" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Cabin+Sketch" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Calligraffitti" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Candal" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Cantarell" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Cardo" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Carter+One" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Caudex" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Chenla" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Cherry+Cream Soda" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Chewy" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Coda" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Coming+Soon" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Content" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Copse" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Corben" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Cousine" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Covered+By Your Grace" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Crafty+Girls" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Crimson+Text" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Crushed" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Cuprum" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Damion" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Dancing+Script" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Dangrek" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Dawning+of a New Day" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Didact+Gothic" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Droid+Sans" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Droid+Sans Mono" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Droid+Serif" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=EB+Garamond" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Expletus+Sans" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Fontdiner+Swanky" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Francois+One" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Freehand" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=GFS+Didot" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=GFS+Neohellenic" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Geo" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Goudy+Bookletter 1911" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Gruppo" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Hanuman" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Holtwood+One SC" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Homemade+Apple" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=IM+Fell DW Pica" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=IM+Fell DW Pica SC" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=IM+Fell Double Pica" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=IM+Fell Double Pica SC" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=IM+Fell English" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=IM+Fell English SC" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=IM+Fell French Canon" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=IM+Fell French Canon SC" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=IM+Fell Great Primer" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=IM+Fell Great Primer SC" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Inconsolata" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Indie+Flower" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Irish+Grover" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Josefin+Sans" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Josefin+Slab" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Judson" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Jura" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Just+Another Hand" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Just+Me Again Down Here" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Kenia" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Khmer" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Koulen" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Kranky" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Kreon" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Kristi" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Lato" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=League+Script" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Lekton" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Limelight" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Lobster" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Lora" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Luckiest+Guy" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Maiden+Orange" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Mako" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Maven+Pro" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Meddon" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=MedievalSharp" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Megrim" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Merriweather" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Metal" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Metrophobic" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Michroma" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Miltonian" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Miltonian+Tattoo" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Molengo" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Monofett" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Moul" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Moulpali" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Mountains+of Christmas" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Muli" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Neucha" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Neuton" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=News+Cycle" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Nobile" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Nova+Cut" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Nova+Flat" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Nova+Mono" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Nova+Oval" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Nova+Round" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Nova+Script" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Nova+Slim" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Nova+Square" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Nunito" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=OFL+Sorts Mill Goudy TT" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Odor+Mean Chey" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Old+Standard TT" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Open+Sans" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Orbitron" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Oswald" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Over+the Rainbow" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=PT+Sans" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=PT+Sans Caption" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=PT+Sans Narrow" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=PT+Serif" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=PT+Serif Caption" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Pacifico" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Paytone+One" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Permanent+Marker" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Philosopher" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Play" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Playfair+Display" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Podkova" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Preahvihear" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Puritan" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Quattrocento" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Quattrocento+Sans" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Radley" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Raleway" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Reenie+Beanie" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Rock+Salt" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Rokkitt" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Ruslan+Display" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Schoolbell" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Shanti" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Siemreap" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Sigmar+One" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Six+Caps" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Slackey" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Smythe" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Special+Elite" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Sue+Ellen Francisco" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Sunshiney" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Suwannaphum" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Swanky+and Moo Moo" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Syncopate" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Tangerine" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Taprom" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Tenor+Sans" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Terminal+Dosis Light" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=The+Girl Next Door" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Tinos" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Ubuntu" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Ultra" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=UnifrakturMaguntia" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Unkempt" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=VT323" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Vibur" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Vollkorn" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Waiting+for the Sunrise" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Wallpoet" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Walter+Turncoat" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Wire+One" rel="stylesheet" type="text/css">
<link href="http://fonts.googleapis.com/css?family=Yanone+Kaffeesatz" rel="stylesheet" type="text/css">
<style type="text/css">
.grid {
    border: 1px solid ##ccc;
    border-width: 1px 0 0 1px;
}

.grid div {
    border: 1px solid ##ccc;
    border-width: 0 1px 1px 0;
    float: left;
}
</style>
' />

<script>
function addElem(type){
	//count existing elements
	anzahl = $('.layoutElem').length;
	newAnzahl = anzahl + 10;
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
		pageID:	<cfoutput>#url.editMagazinPage#</cfoutput>,
		type: type,
		width: 	200,
		height:	100,
		posX: 	p,
		posY: 	p,
		color: '',
		zIndex:	z,
		orientation: $('#canvas').attr('class').split(' ')[1],
		device: $('#canvas').attr('class').split(' ')[0]
	},function(data){
		
		$('#canvas').append(newDiv);

		$('#layoutElem-'+newAnzahl).attr('rel',data);
		
		// add layer to layer-management
		newLayer = $('<li style="border-bottom:1px solid silver;padding:0.2em;padding-left:0.2em;position:relative;" id="'+data.split('-')[0]+'"><div id="visi-'+data.split('-')[0]+'" class="layerOn" style="width:10px;float:left;color:green;font-size:1.2em;"><strong>&bull;</strong></div><div id="elem-'+data.split('-')[0]+'" class="layer">[No Layer-Label]</div></li>');
		$('#layers>ul').prepend(newLayer)
		
		bringToFront(newAnzahl,data.split('-')[0],data.split('-')[1]);
		$('#layoutElem-'+newAnzahl).draggable({
			containment: "#canvas", 
			grid: [ 10,10 ],
			scroll: false,
			stop:	function(event,ui){
						xZindex = z;
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
		$('#layoutElem-'+newAnzahl).resizable({
			 containment: "#canvas",
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
					}/*,
			 minWidth: $('div.elemContent','#layoutElem-'+newAnzahl).width(),
			 minHeight: $('div.elemContent','#layoutElem-'+newAnzahl).height()*/
		});
		// get form
		$('#layoutElem-'+newAnzahl).click(function(){
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
		
		$('#layoutElem-'+newAnzahl).mouseover(function(){
			_this = $(this);
			thisID = _this.attr('rel').split('-')[0];
			$('.layer').css('outline','')
			$('.layer').each(function(){	
				if($(this).attr('id').split('-')[1]==thisID){	
					//$('#elem-'+$(this).attr('id').split('-')[1]).css('outline','2px solid grey');
				}
				
			});	
		});	
		
		$('#layoutElem-'+newAnzahl).mouseout(function(){
			$('#layoutElem-'+newAnzahl).css('outline','');
		});	
		
		$('#elem-'+data.split('-')[0]).mouseover(function(){
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
		
		$('#elem-'+data.split('-')[0]).click(function(){
			hiliteLayerElem($(this).attr('id'));
		});
		
		$('#elem-'+data.split('-')[0]).mouseout(function(){
			$('.layoutElem').css('outline','');
		});	
		
		
		 $.fancybox({
			'autoDimensions': true,
			'centerOnScroll': true,
			'type':'ajax',
			'href':'/admin/inc/ajax_magazinForm.cfm?type='+type+'&orientation='+$('#canvas').attr('class').split(' ')[1]+'&device='+$('#canvas').attr('class').split(' ')[0]+'&id='+$('#layoutElem-'+newAnzahl).attr('rel').split('-')[0]+'&reselemid='+$('#layoutElem-'+newAnzahl).attr('rel').split('-')[1]+'&divid='+$('#layoutElem-'+newAnzahl).attr('id')
		});
		
	});	
}

function bringToFront(x,y,z){
	var zIndex = 0;
	$('.layoutElem').each(function(){
		if($(this).css('z-index')>parseInt(zIndex)){
			zIndex = $(this).css('z-index');	
		}
	});
	newZIndex = parseInt(zIndex)+10;
	//post data into db and update record
	$.post('/admin/inc/ajax_updateMagazinElement.cfm',{
		id: 	y,
		zIndex:	newZIndex,
		pageID:	<cfoutput>#url.editMagazinPage#</cfoutput>,
		orientation: $('#canvas').attr('class').split(' ')[1],
		device: $('#canvas').attr('class').split(' ')[0],
		resElemID: z
	});
	$('#layoutElem-'+x).css('z-index',newZIndex);
}

function delElem(id,dbid){
	$('#layoutElem-'+id).remove();
	$('#elem-'+dbid).parent().remove();
	//post data into db and delete record
	$.post('/admin/inc/ajax_delMagazinElement.cfm',{
		id: dbid
	});	
}

function postForm(id,divID){
	$.post("/admin/inc/ajax_updateMagazinElement.cfm?elemID="+id, $("#formular").serialize(),function(data){
		$('.elemContent','#'+divID).html(data);	
		$.fancybox.close();
	});	
}

function pageProp(pageID){
	orientation = $('#canvas').attr('class').split(' ')[1],
	device = $('#canvas').attr('class').split(' ')[0],
	$.fancybox({
		'autoDimensions': true,
		'centerOnScroll': true,
		'type':'ajax',
		'href':'/admin/inc/ajax_magazinePageProperties.cfm?pageID='+pageID+'&orientation='+orientation+'&device='+device
	});
}

function loadDeviceSpecificCanvas(type,MagazinPageID,orientation){
	$.get('/admin/inc/ajax_magazineCanvas.cfm',
		{
		device: type,
		editMagazinPage: MagazinPageID,
		orientation: orientation
		},
		function(returnData){
			$('#d').html(returnData);
		}
	);
}

$(document).ready(function(){
	loadDeviceSpecificCanvas('ipad',<cfoutput>#url.editMagazinPage#</cfoutput>,'portrait');	
});
</script>

<cfoutput>
	
			
		<div id="d"></div>
</cfoutput>