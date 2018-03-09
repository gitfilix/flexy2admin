<cfoutput>
<tr style="border-bottom:1px solid darkgrey;" class="langelem langelem#url.count#">
	<td>Sprache</td>
	<td>
		<input type="text" name="initSprache#url.count#" value="" title="initSprache" /><br/>
		Sprach-Parameter: <input type="text" name="initSpracheParam#url.count#" style="width:100px;" value="" title="initSpracheParam" /> (z.B: ch-de)<br/>
		Domain: <input type="text" name="domain#url.count#" value="" style="width:60%;" title="domain" /><br/>
		<input type="radio" name="status#url.count#" value="1" checked="checked" /> aktiv&nbsp;&nbsp;
		<input type="radio" name="status#url.count#" value="0" /> inaktiv&nbsp;&nbsp;<br/>
		<a href="javascript:void(0);" onclick="delMask('lang','langelem#url.count#')">entfernen</a>
	</td>
</tr>
</cfoutput>