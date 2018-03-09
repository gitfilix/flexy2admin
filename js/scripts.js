function showFormOptions(id,state){
	if(state==0){
		$('#'+id).css('display','none')	
	}
	else{
		$('#'+id).css('display','block')		
	}
	
}

function loadMask(type){
	if(type=='dok'){
		//get nr. of already added doks to set correct incrementing ID
		cnt = $('.dokelem').length+1;
		newcnt = cnt + 1;
		if(newcnt <= 5){
			$.get('/admin/inc/ajax_dokmask.cfm',{count:newcnt},function(returnData){
				$('#sortDocs>tbody>tr:last').after(returnData);
			});	
		}
		else{
			alert('Sie können nicht mehr als 5 Dokumente pro Inhalt einfügen');	
		}
	}
	else if (type=='link'){
		//get nr. of already added doks to set correct incrementing ID
		cnt = $('.linkelem').length+1;
		newcnt = cnt + 1;
		if(newcnt <= 5){
			$.get('/admin/inc/ajax_linkmask.cfm',{count:newcnt},function(returnData){
				$('#sortLinks>tbody>tr:last').after(returnData);
			});		
		}
		else{
			alert('Sie können nicht mehr als 5 Links pro Inhalt einfügen. Ansonsten versuchen Sie es mittels dem Rich-Text-Editor');	
		}
	}
	else if (type=='lang'){
		//get nr. of already added doks to set correct incrementing ID
		cnt = $('.langelem').length+1;
		newcnt = cnt ;
		$.get('/admin/inc/ajax_langmask.cfm',{count:newcnt},function(returnData){
			$('#sortLangs>tbody>tr:last').after(returnData);
		});		
	}
}

function recountAddedMasks(type){
	if(type=='dok'){
		cnt = 2;
		$('.dokelem').each(function(){
			_this = $(this);
			$('input',this).each(function(){
				act = $(this).attr('title');
				newName = act + cnt ;
				$(this).attr('name',newName);
			});
			cnt = cnt + 1;		
		});
	}
	else if (type=='link'){
		cnt = 2;
		$('.linkelem').each(function(){
			_this = $(this);
			$('input',this).each(function(){
				act = $(this).attr('title');
				newName = act + cnt ;
				$(this).attr('name',newName);
			});
			cnt = cnt + 1;		
		});
	}
	else if (type=='lang'){
		cnt = 1;
		$('.langelem').each(function(){
			_this = $(this);
			$('input[type=text]',this).each(function(){
				act = $(this).attr('title');
				newName = act + cnt ;
				$(this).attr('name',newName);
			});
			cnt = cnt + 1;		
		});
	}
}

function delMask(type,id){
	if(type=='dok'){
		$('.'+id).remove();
		recountAddedMasks(type);					
	}
	else if (type=='link'){
		$('.'+id).remove();
		recountAddedMasks(type);
	}
	else if (type=='lang'){
		$('.'+id).remove();
		recountAddedMasks(type);
	}
}

// Return a helper with preserved width of cells
var fixHelper = function(e, ui) {
	ui.children().each(function() {
		$(this).width($(this).width());
	});
	return ui;
};


// -----------------------------------------------------------------------------------------------------


$(document).ready(function(e) {
	$("#sortDocs tbody").sortable({
		helper: fixHelper,
		update: function(){
			recountAddedMasks('dok');
		}
	});//.disableSelection(); resulted in FF focus-bug
	
	$("#sortLinks tbody").sortable({
		helper: fixHelper,
		update: function(){
			recountAddedMasks('dok');
		}
	});//.disableSelection(); resulted in FF focus-bug
	

	$('.toolTipWrapper')
		.mouseover(function(e){
			$(this).find('div').toggle();
			})
		.mouseout(function(){
			$(this).find('div').toggle();
			});
		
	$('.fancyboxToolTip').fancybox({	
		'hideOnContentClick': true,
		'type': 'inline',
		'centerOnScroll': true
	});

});



