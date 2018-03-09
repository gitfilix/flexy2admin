<cfset device = "ipad">
<cfset orientation = "portrait">

<cfswitch expression="#device#">
	<cfcase value="ipad">
		<cfif orientation EQ "portrait">
			<cfset width = "997" /> 
			<cfset height = "1276" />
			<cfset bgimage = "bg_ipad_hoch.png">
			<cfset padding = "125px 115px 125px 115px" />
		<cfelse>
			<cfset width = "1276" />
			<cfset height = "997" />
			<cfset bgimage = "bg_ipad_quer.png">
			<cfset padding = "125px 115px 125px 115px" />
		</cfif>
	</cfcase>
	<cfcase value="galaxyTab">
		<cfif orientation EQ "portrait">
			<cfset width = "" />
			<cfset width = "" />
		<cfelse>
			<cfset width = "" />
			<cfset width = "" />
		</cfif>
	</cfcase>
	<cfcase value="surface">
		<cfif orientation EQ "portrait">
			<cfset width = "" />
			<cfset width = "" />
		<cfelse>
			<cfset width = "" />
			<cfset width = "" />
		</cfif>
	</cfcase>
</cfswitch>

<cfset toolbarWidth = 220 />
<cfset toolbarHeight = height-125 />
<cfset canvasWidth = width />
<cfset canvasHeight = height />
<cfset wrapper = canvasWidth + toolbarWidth + 20>

<cfoutput>
	<div id="wrapper" style="width:#wrapper#px;">
		<div id="outerCanvas" style="">
			<div id="toolset" style="float:left;padding-right:20px;width:#toolbarWidth#px;height:#toolbarHeight#px;overflow-y:auto;">
				<div id="cd" style="position:relative;height:105px;padding-left:1em;padding-top:20px;">
					<strong style="font-weight:bold;font-size:20px;">HTML5-FOLIO for tablets &copy;</strong><br/>by reziprok
					<a href="" style="display:block;position:absolute;top:60px;right:20px;width:36px;height:30px;">
						<img src="/admin/img/rotate.png">
					</a>
				</div>
				<div id="devices" style="padding:1em;border-bottom:1px solid silver;">
					<a href="" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">iPad</a>
					<a href="" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">GTab</a>
					<a href="" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">Surface</a>
					<a href="" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;">&nbsp;</a>
					<div style="clear:both;"></div>
				</div>
				<div id="globalSettings" style="padding:1em;border-bottom:1px solid silver;">
					<a href="" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">P</a>
					<a href="" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;line-height:30px;text-align:center">+</a>
					<a href="" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;">&nbsp;</a>
					<a href="" style="text-decoration:none;float:left;display:block;border-radius:5px;border:1px solid darkred;float:left;margin-right:0.5em;width:30px;height:30px;">&nbsp;</a>
					<div style="clear:both;"></div>
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
						<li style="border-bottom:1px solid silver;padding:0.2em;position:relative;">
							ein Layer
							<div style="position:absolute;top:0;right:0;width:20px;">
								x
							</div>
							<div style="position:absolute;top:0;right:20px;width:20px;">
								e
							</div>
						</li>
						<li style="border-bottom:1px solid silver;padding:0.2em;position:relative;">
							ein Layer
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
							<ul style="margin:0;padding:0;list-style-type:none;">
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
							</ul>
						</li>
						<li style="border-bottom:1px solid silver;padding:0.2em;position:relative;">
							ein layer
							<div style="position:absolute;top:0;right:0;width:20px;">
								x
							</div>
							<div style="position:absolute;top:0;right:20px;width:20px;">
								e
							</div>
						</li>
						<li style="border-bottom:1px solid silver;padding:0.2em;position:relative;">
							ein layer
							<div style="position:absolute;top:0;right:0;width:20px;">
								x
							</div>
							<div style="position:absolute;top:0;right:20px;width:20px;">
								e
							</div>
						</li>
					</ul>
				</div>
			</div>
			<div style="float:left;background:transparent url('/admin/img/#bgimage#') left top no-repeat;width:#canvasWidth#px;height:#canvasHeight#px;">
				<div style="padding:#padding#;" id="canvas">
					
				</div>
			</div>
		</div>
	</div>
</cfoutput>