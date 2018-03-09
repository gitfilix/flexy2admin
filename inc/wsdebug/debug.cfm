
<html ><head>
    <title>CF WebSocket Debugger</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8">

    <link rel="stylesheet" type="text/css" href="css/debugger.css">
       	<script>
       		// Defining global var here
       		var info = new Array();
       		var error = new Array();
       		var incoming = new Array();
       		var outgoing = new Array();
       		var allmsg = new Array();



			function showop(arg)
			{
				txt=document.getElementById('console');
				txt.innerHTML="";
				for (var i=arg.length-1; i >=0; --i) {
					txt.innerHTML+="&nbsp;&nbsp;"+arg[i] ;
				};
			}
			function toggleCells(cellid){
				t=document.getElementById('all');
				t.className="normal";
				t=document.getElementById('err');
				t.className="normal";
				t=document.getElementById('inf');
				t.className="normal";
				t=document.getElementById('in');
				t.className="normal";
				t=document.getElementById('out');
				t.className="normal";
				rCells=document.getElementById(cellid);
				rCells.className="normalclick";

			}

			function toggleCellsforMouseover(cellid){

				rCells=document.getElementById('all');
				if(rCells.className!="normalclick")
					rCells.className="normal";

				rCells=document.getElementById('err');
				if(rCells.className!="normalclick")
					rCells.className="normal";

				rCells=document.getElementById('inf');
				if(rCells.className!="normalclick")
					rCells.className="normal";

				rCells=document.getElementById('in');
				if(rCells.className!="normalclick")
					rCells.className="normal";

				rCells=document.getElementById('out');
				if(rCells.className!="normalclick")
					rCells.className="normal";
			}

       	</script>
       </head>
</head>

	<!---<form action="index.cfm?d=debug.durl">--->
	<table width="100%" height="90%">
		<tr>
			<td>
				<div id="toolbar" style="height:50px;border:10px;float:top;background-color:#E0E0E0 ;">

					<table width="100%">
						<tr height="10">
						</tr>
						<tr>
							<td width="15">
							</td>
							<td width="55">
								WebSocket
							</td>
							<td>
								Debugger
							</td>
							<td >
								<!---<input typr="text" name="durl" id="durl" value="">--->
								<a href="index.cfm?d=durl.value" >Debug Url</a>
								<!---<input type="submit" id="wsdebug" value="Debug Url" >--->
							</td>
						</tr>
					</table>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				<div id="page" style="height:400px;background-color:white;overflow:auto;">
						<br>
						<cfset loadPage()>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				<div id="drawer" style="height:47px;border:1px;float:top;background-color:#E0E0E0 ">
					
				<table width="100%" border="0" ><hr>
					
					<tr height="10">
						<td width="15">
						</td>
						<td id="all" class="normalclick" width="35" align="center" onmouseover="this.className='normalon'"
						     onmouseout="toggleCellsforMouseover('all');" onclick="showop(allmsg);toggleCells('all');">
							All
						</td>
						<td id="err" class="normal" width="55" align="center" onmouseover="this.className='normalon'"
						     onmouseout="toggleCellsforMouseover('err');" onclick="showop(error);toggleCells('err');">
							Errors
						</td>
						<td id="inf" class="normal" width="35" align="center" onmouseover="this.className='normalon'"
						    onmouseout="toggleCellsforMouseover('inf');" onclick="showop(info);toggleCells('inf');">
							Info
						</td>
						<td id="in" class="normal" width="65" align="center" onmouseover="this.className='normalon'"
						    onmouseout="toggleCellsforMouseover('in');" onclick="showop(incoming);toggleCells('in');">
							Incoming
						</td>
						<td id="out" class="normal" width="35" align="center" onmouseover="this.className='normalon'"
						    onmouseout="toggleCellsforMouseover('out');" onclick="showop(outgoing);toggleCells('out');">
							Outgoing
						</td>
						<!---<td id="out" width="35" align="center" onmouseover="this.className='normalon'"
						    onmouseout="this.className='normal'" onclick="showop(outgoing);">
							Outgoing
						</td> --->
						<td class="normal" width="165" align="center">
						</td>
						<td id="ws" class="normal" width="25" align="center"></td>
						<td id="auth" class="normal" width="25" align="center"></td>
						<td class="normal" width="25" align="center"></td>
						<td></td>
					</tr>
				</table><hr>
				
				</form>
		</td></tr>
		<tr><td>
	</div>
        <div id="console" style="height:280px;overflow:auto;font-family:Lucida Grande, sans-serif;font-size:12px">

    </div>
</td></tr>
</table>

</html>


<cffunction name="loadPage">
	<cfset durl = #Application.url#>
	<cfset repJs = #GetDirectoryFromPath(CGI.SCRIPT_NAME)# & "cfwebsocketCore.js">
	
	<cfif isDefined("durl") && (len(durl) gt 10)>
		<cfhttp url="#durl#" method="GET"  throwonerror="Yes"/>
		<cfset res = #replace(CFHTTP.filecontent, "/CFIDE/scripts/ajax/package/cfwebsocketCore.js",
		                      repJs)#>

		<cfoutput>#res#</cfoutput>
	<cfelse>
		<cfoutput>Please provide a URL!!!</cfoutput>
	</cfif>

</cffunction>