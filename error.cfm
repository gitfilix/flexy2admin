<!--- We are so sorry. Something went wrong. We are working on it now.

<cflog file="myapperrorlog" text="#error.message# - #error.diagnostics#">

<cfsavecontent variable="errortext">
<cfoutput>
An error occurred: http://#cgi.server_name##cgi.script_name#?#cgi.query_string#<br />
Time: #dateFormat(now(), "short")# #timeFormat(now(), "short")#<br />

<cfdump var="#error#" label="Error">
<cfdump var="#form#" label="Form">
<cfdump var="#url#" label="URL">

</cfoutput>
</cfsavecontent>


<cfmail to="bugs@myproject.com" from="root@myproject.com" subject="Error: #error.message#" type="html">
    #errortext#
</cfmail> --->