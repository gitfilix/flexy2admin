<cfhtmlhead text="
	<link rel='stylesheet' href='/admin/js/jquery.fancybox-1.3.4/fancybox/jquery.fancybox-1.3.4.css' type='text/css'>
	<link href='http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/themes/start/jquery-ui.css' type='text/css' rel='Stylesheet' />
">

<div id="loginpanel" style="background:white url('/admin/img/flexylogo.jpg') left top no-repeat;width:500px;height:200px;position:relative;display:none;border:10px solid black;z-index:99999">
	<form action="javascript:postLogin();" id="loginform" name="loginform">
		<div id="result" style="padding-top:50px;color:red;text-align:center;"></div>
		<table width="400" style="position:absolute;top:125px;left:50px;color:#000;font-size:11px;">
		<tr>
			<td style="padding:0;padding-bottom:5px;">Username&nbsp;&nbsp;&nbsp;</td>
			<td style="padding:0;padding-bottom:5px;">
				<input type="text" name="username" id="user" style="border:1px solid silver;padding:2px;width:100px;" />
			</td>
			<td style="padding:0;padding-bottom:10px;">Passwort&nbsp;&nbsp;&nbsp;</td>
			<td style="padding:0;padding-bottom:10px;">
				<input type="password" name="password" id="pass" style="border:1px solid silver;padding:2px;width:100px;" />
			</td>
		</tr>
		<tr>
			<td colspan="4" align="center">
				<input type="hidden" name="id" id="pageid" value="1" />
				<input type="submit" name="submit" id="submit" value="Login" style="border:1px solid silver;padding:2px;width:auto;" />&nbsp;
				<input type="button" name="abort" id="abort" value="Abbrechen" onclick="hideLogin();" style="border:1px solid silver;padding:2px;width:auto;" />
			</td>
		</tr>
		</table>
	</form>
</div>

<script src="/admin/js/hotKeys.js"></script>	
<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.1/jquery-ui.min.js"></script>
<script type="text/javascript" src="/admin/js/jquery.fancybox-1.3.4/fancybox/jquery.fancybox-1.3.4.js"></script>
<script src="/admin/js/fee.js"></script>	
<script>
var pdTopOrig = $('body').css('padding-top');
var mgTopOrig = $('body').css('margin-top');

jQuery.fn.center = function () {
	this.css("position","absolute");
	this.css("top", (($(window).height() - this.outerHeight()) / 2) + $(window).scrollTop() + "px");
	this.css("left", (($(window).width() - this.outerWidth()) / 2) + $(window).scrollLeft() + "px");
	return this;
};

function hideLogin(){
	
	$("#loginpanel").css({
		display: 'none'
	});
	$('.container').css('display','block');
}

function showLogin(){
	$('.container').css('display','none');
	$("#loginpanel").css({
		display: 'block'
	}).center();	
}

function showIframe(module){
	if($('#dropDownIframe').css('display')=='none'){
		$('body').css({paddingTop:0,marginTop:0});
		$('#panelCMSLink').html('CMS verbergen');
		$('html,body').css({height:'100%',overflow:'hidden'});
		$('#dropDownIframe').slideDown(function(){
			if($('#dropDownIframe iframe').attr('src')==''){
				$('#dropDownIframe iframe').attr('src','/admin/index.cfm?module='+module+'&lang=<cfoutput>#session.lang#</cfoutput>');			
			}
		});	
	}
	else{
		hideframe();	
	}
}

function hideframe(){
	$('#dropDownIframe').slideUp(function(){
		$('body').css('padding-top',pdTopOrig);
		$('body').css('margin-top',mgTopOrig);	
		$('html,body').css({height:'auto',overflow:'visible'});
		$('#panelCMSLink').html('CMS zeigen');
	});	
	
	//$('.container').css('display','block');
	//$('#dropDownIframe iframe').attr('src','');	
}

function showPanel(){
	if($('#dropPanel').css('display')=='none'){
		$('body').css({paddingTop:0,marginTop:0});
		$('#dropPanel').slideDown();
	}
	else{
		hidePanel();
	}
}

function hidePanel(){
	$('#dropPanel').slideUp(function(){
		$('body').css('padding-top',pdTopOrig);
		$('body').css('margin-top',mgTopOrig);	
		$('#dropPanel').css('display','none');
	});
}

function showBar(){
	pdtop = $('body').css('padding-top');
	$('body').css('padding-top',parseInt(pdtop+30));
	bar = $('<div style="position:fixed;top:0;left:0;background-color:grey;padding:3px;width:100%;color:white;z-index:999;"><div style="max-width:1100px;margin:0 auto;"><a href="javascript:void(0);" onclick="showPanel();">Flexy2.0</a> <a href="javascript:void(0);" onclick="showIframe(\'inc_pagemangement\');" id="panelCMSLink">CMS zeigen</a> | <a href="<cfoutput>#cgi.SCRIPT_NAME#</cfoutput>?adminSession=0">abmelden</a></div></div>');
	dropDownIframe = $('<div id="dropDownIframe" style="position:absolute;z-index:5;left:0;top:0;width:100%;display:none;height:100%;background-color:#fff;"><iframe src="/admin/index.cfm?module=inc_pagemangement&lang=<cfoutput>#session.lang#</cfoutput>" style="height:100%;width:100%;border:0;"></iframe></div>');
	dropPanel = $('<div id="dropPanel" style="max-width:1100px;display:none;height:200px;margin-right:auto;margin-left:auto;">&nbsp;</div></div>');
	$('html, body').css('height','100%');
	$('body').css('position','relative');
	$('body').prepend(bar);	
	$('body').prepend(dropDownIframe);
	$('div',bar).append(dropPanel);	
}

function postLogin(){
	//main Login to /admin
	$.post("/admin/frontEndLogin.cfm", $("#loginform").serialize(),function(data){
		if(data.indexOf('true')>-1){
			// next login to fee folder - means generate open session
			$.get('/admin/inc/frontendMasks/remoteLoginFEE.cfm',{
				login:1,
				mandant:'<cfoutput>#session.mandant#</cfoutput>',
				serverpath:'<cfoutput>#session.serverpath#</cfoutput>'
			},function(){
				//set loginState in frontend of mandant
				$.get('/<cfoutput>#session.serverpath#</cfoutput>',{
					adminSession:1
				});	
			});
			$('#result').fadeIn().html('Login erfolgreich. Sie sind jetzt angemeldet!').delay(1500).fadeOut('fast',function(){
				location.href='<cfoutput>#cgi.SCRIPT_NAME#</cfoutput>';
			});	
		}
		else{
			$('#user').val('');
			$('#pass').val('');
			$('#result').fadeIn().html('Login nicht erfolgreich. Veruschen Sie es nochmal').delay(2500).fadeOut('fast');	
		}
	});
	
};


$(document).ready(function(e){
	
<cfif session.adminSession EQ 1>	
	
	$(document).bind("contextmenu",function(e){
		  return false;
	}); 
	
	fncUID = 1;
	
	$('.fnc').each(function(){
		_this = $(this);
		if($(this).attr('class').indexOf('fncEdit-')>-1){	
			// first put Add-Link below
			e = $('<div style="padding:1em 0 1em 0;cursor:pointer;width:50px;float:left;"><span>Edit</span></div>');
			$('span',e).attr('id','c'+fncUID);
			$(this).append(e);
			$('span#c'+fncUID).click(function(){		
				valueArrayY = $(this).parent().parent().attr('class').split(" "); 
				for(var i=0; i<valueArrayY.length; i++){	
					if(valueArrayY[i].indexOf('fncEdit-')>-1){
						tmp = valueArrayY[i].split("-");
						functionx = tmp[1]
						parentid = tmp[2];
						actId = tmp[3];
						mandant = tmp[4];
						// build link
						linkurl = '/admin/inc/frontendMasks/'+functionx+'.cfm?parentId='+parentid+'&actId='+actId+'&mandant='+mandant;

						if(functionx=='editContent'){
							hgt = 600;	
						}
						else{
							hgt = 300;		
						}
						
						$.fancybox({	
							width			: 800,
							height			: hgt,
							autoScale    	: false,
							transitionIn	: 'none',
							transitionOut	: 'none',
							type			: 'iframe',
							href			: linkurl
						});
						
						break;
					}
				}
			});
		}
		fncUID = parseInt(fncUID+1);
	});
	
	$('.fnc').each(function(){
		_this = $(this);
		var xid = $(this).attr('id');
		if($(this).attr('class').indexOf('fncDel-')>-1){	
			// first put Add-Link below
			e = $('<div style="padding:1em 0 1em 0;cursor:pointer;width:50px;float:left;"><span>Del</span></div>');
			$('span',e).attr('id','a'+fncUID);
			$(this).append(e);
			$('span#a'+fncUID).click(function(){	
				valueArrayY = $(this).parent().parent().attr('class').split(" "); 
				for(var i=0; i<valueArrayY.length; i++){	
					if(valueArrayY[i].indexOf('fncDel-')>-1){
						tmp = valueArrayY[i].split("-");
						functionx = tmp[1];
						actId = tmp[2];
						mandant = tmp[3];
						// build link
						linkurl = '/admin/inc/frontendMasks/'+functionx+'.cfm?actId='+actId+'&mandant='+mandant;		
						x = confirm('Sind Sie sicher?');
						if(x){
							$('#'+xid).remove();
							$.get(linkurl,function(){
								//location.reload(); 
								
							});	
						}
						break;
					}
				}
			});
		}
		fncUID = parseInt(fncUID+1);
	});
	
	$('.fnc').each(function(){
		_this = $(this);
		if($(this).attr('class').indexOf('fncAdd-')>-1){	
			// first put Add-Link below
			e = $('<div style="padding:1em 0 1em 0;cursor:pointer;width:50px;float:left;"><span>Add</span></div>');
			$('span',e).attr('id','b'+fncUID);
			$(this).append(e);
			$('span#b'+fncUID).click(function(){		
				valueArrayY = $(this).parent().parent().attr('class').split(" "); 
				for(var i=0; i<valueArrayY.length; i++){	
					if(valueArrayY[i].indexOf('fncAdd-')>-1){
						tmp = valueArrayY[i].split("-");
						functionx = tmp[1];
						parentid = tmp[2];
						actId = tmp[3];
						mandant = tmp[4];
						// build link
						linkurl = '/admin/inc/frontendMasks/'+functionx+'.cfm?parentId='+parentid+'&actId='+actId+'&mandant='+mandant;

						if(functionx=='addContent'){
							hgt = 600;	
						}
						else{
							hgt = 300;		
						}
						
						$.fancybox({	
							width			: 800,
							height			: hgt,
							autoScale    	: false,
							transitionIn	: 'none',
							transitionOut	: 'none',
							type			: 'iframe',
							href			: linkurl
						});
						
						break;
					}
				}
			});
		}
		fncUID = parseInt(fncUID+1);
	});
		
	$('.fnc').each(function(){
		classList = '';
		_this = $(this);
		classList = _this.attr('class');	

		if(_this.attr('class').indexOf('fnc-')>-1){	
			// Disable context menu on an element
			
			_this.rightClick(function(){
				valueArrayX = $(this).attr('class').split(" "); 
				
				for(var i=0; i<valueArrayX.length; i++){	
					if(valueArrayX[i].indexOf('fnc-')>-1){
						
					
						tmp = valueArrayX[i].split("-");
						dbTable = tmp[1];
						dbField = tmp[2];
						mandant = tmp[3];
						type = tmp[4];
						fieldId = tmp[5];
						
						// build link
						linkurl = '/admin/inc/frontendMasks/'+type+'.cfm?table='+dbTable+'&field='+dbField+'&mandant='+mandant+'&id='+fieldId;
						
						
						
						if(type=='inputtext'){
							hgt = 100;	
						}
						else if (type=='textarea' || type=='wysiwyg'){
							hgt = 365;	
						}
						else if (type=='image' || type=='document'){
							hgt = 180;		
						}
						
						$.fancybox({	
							width			: 500,
							height			: hgt,
							autoScale    	: false,
							transitionIn	: 'none',
							transitionOut	: 'none',
							type			: 'iframe',
							href			: linkurl
						});
					}
				}
			});
		}
	});
	
	$('.fnc').each(function(){
		if($(this).attr('class').indexOf('fncAdd-')>-1 || $(this).attr('class').indexOf('fncEdit-')>-1 || $(this).attr('class').indexOf('fncDel-')>-1){
			e = $('<div style="clear:both;"></div>');
			$(this).append(e);
		}
	});
	
	$( ".contentSortable" ).sortable({
		items: "article:not(.disabled),> li:not(.disabled),> div:not(.disabled)",
		stop: function( event, ui ) {
			
			// fncSort-sidebar2pages-parentID-actId
			var sorted = $(this).sortable('serialize',{key:'sort'});
			
			$.get('/admin/inc/frontendMasks/changePosition.cfm',{
				type: 'sidebar',
				parentId: 0,
				id: 0
			},function(){
				//alert('Erfolgreich umsortiert!');
			});
		}	
	});
	showBar();
<cfelse>

	$(document).bind('keyup', 'shift+l', function() {
		if($("#loginpanel").css('display')=='none'){
			showLogin();
			
			$('#user').focus(); 
			$('#user').val(''); 
			$('#pass').val(''); 
		}
		else
			hideLogin();
	});
</cfif>

});
</script>