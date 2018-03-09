<cfprocessingdirective pageencoding="utf-8">
<script>
function submitContactForm(){
	contact = '#kontaktformular';
	// append hidden captcha / human detection into DOM
	$hiddenInput = $('<input/>',{type:'hidden',id:'hiddenCheckbox',name:'iAmNotAbot',value:'itSeemsIamAhuman'});
	$hiddenInput.prependTo('.captcha',contact);
	//disable send-button to prevent multiple clicks
	$('#send').attr('disabled', 'disabled');
	$('#send').addClass('disabled');
	// from send
	$('#kontaktformular').fadeOut(1000,function(){
		<!--- 1. CHECK HERE path is correct --->
		$.post('/photography/inc/sendContact.cfm?formSubmited=true', $('#kontaktformular').serialize(),function(data){
			$('#kontaktformular').before('<span id="thx">'+data+'</span>');
			if(data.indexOf('Danke')>-1){
				$('#kontaktformular').remove();
			}
			else{
					$('#kontaktformular').fadeIn();
			}
			
			//setTimeout(function() {$('#thx').fadeOut().remove()}, 2000);
		});
	});	
}
</script>
<div>
	<cfoutput>		
		<!--- 	<img src="/#session.serverpath#/img/HTML_Styling.png" alt="hi" id="formimg" /> --->
			
	</cfoutput>
	<cfoutput>
	<div class="webform">
	<h2>Get Contact</h2>
	<form action="javascript:submitContactForm();void(0);" method="post" enctype="multipart/form-data" class="forms columnar" id="kontaktformular" >
		<fieldset>
		<ul> 
			<li>
				 <label for="contactname" class="bold">Name</label>
   				 <input type="text" size="30" name="contactname" placeholder="Ihr Name" required class="seven input-gray" id="contactname" title="Name" />
    			<div class="descr"></div>
			</li>
			<li>
				 <label for="contactmail" class="bold">Email</label>
   				 <input type="email" size="30" name="contactmail" required class="seven input-gray"  placeholder="Ihre E-Mail Adresse" id="contactmail" title="E-Mail" />
			</li>
			<li>
              <section><label class="bold" for="contactmessage">Message</label></section>
              <textarea class="width-50" style="height: 100px;" id="contactmessage" name="contactmessage" placeholder="Text"></textarea>
            </li>
			<li>
				<fieldset class="captcha" style="background:none;border:0;padding:0;margin:0;font-size:0;line-height:0;"> </fieldset>
			</li>
			<li style="float:right;">
				<input type="hidden" id="iAmNotAbot" name="iAmNotAbot" value="notSureYet">
			</li>
			 <li class="push">
			 	<div class="response"></div>
                <input type="submit" class="btn" id="submit-btn" name="Kontaktsenden" value="Kontakt mit **MANDANT**" />
				<!--- Hiddenfilds zum contact-/ reciever adressen übergeben --->
				<input type="hidden" name="contactReciever" value="#contactReciever#">
				<input type="hidden" name="contactsender" value="#contactsender#">
				<input type="hidden" name="contactSubject" value="#contactSubject#">
				<input type="hidden" name="agb" value="1">
            </li>
		</ul>	
		</fieldset>
	 </form>
	</div>
		<!--- CHECK AND REMOVE this after success   --->
		<br />
		<br />
		<br />
		<div class="content">
			<h2>
			contactreciever is: #CONTACTRECIEVER# <br />	
			contactsender is: #contactsender# <br />
			contactSubject is: #contactSubject#<br />
			</h2>
			
		</div>
	
	</cfoutput>
	
</div>