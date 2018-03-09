<cfprocessingdirective pageencoding="utf-8" />

<!--- Build a query --->
 <cfset fields = queryNew("id, feld, module","cf_sql_integer, cf_sql_varchar, cf_sql_integer",
	[
	[ 1, "addPage_pageTitle", 1 ],
	[ 2, "addPage_URLShortcut", 1 ],
	[ 3, "addPage_navTitle", 1 ],
	[ 4, "addPage_metaTitle", 1 ],
	[ 5, "addPage_metaKeys", 1 ],
	[ 6, "addPage_metaDesc", 1 ],
	[ 7, "addPage_navOrder", 1 ],
	[ 8, "addPage_parentID", 1 ],
	[ 9, "addPage_headerBild", 1 ],
	[ 10, "addPage_template", 1 ],
	[ 11, "addPage_templatecolorschema", 1 ],
	[ 12, "editPage_pageTitle", 1 ],
	[ 13, "editPage_URLShortcut", 1 ],
	[ 14, "editPage_navTitle", 1 ],
	[ 15, "editPage_metaTitle", 1 ],
	[ 16, "editPage_metaKeys", 1 ],
	[ 17, "editPage_metaDesc", 1 ],
	[ 18, "editPage_navOrder", 1 ],
	[ 19, "editPage_parentID", 1 ],
	[ 20, "editPage_headerBild", 1 ],
	[ 21, "editPage_template", 1 ],
	[ 22, "editPage_templatecolorschema", 1 ],
	[ 23, "addContent_titel", 1 ],
	[ 24, "addContent_lead", 1 ],
	[ 25, "addContent_fliesstext", 1 ],
	[ 26, "addContent_bildname", 1 ],
	[ 27, "addContent_href", 1 ],
	[ 28, "addContent_hrefLabel", 1 ],
	[ 29, "addContent_doc", 1 ],
	[ 30, "addContent_docLabel", 1 ],
	[ 31, "addContent_hasContact", 1 ],
	[ 32, "addContent_contactType", 1 ],
	[ 33, "addContent_customInclude", 1 ],
	[ 34, "addContent_imagePos", 1 ],
	[ 35, "addContent_imageCaption", 1 ],
	[ 36, "addContent_fliessTextSpalten", 1 ],
	[ 37, "editContent_titel", 1 ],
	[ 38, "editContent_lead", 1 ],
	[ 39, "editContent_fliesstext", 1 ],
	[ 40, "editContent_bildname", 1 ],
	[ 41, "editContent_href", 1 ],
	[ 42, "editContent_hrefLabel", 1 ],
	[ 43, "editContent_doc", 1 ],
	[ 44, "editContent_docLabel", 1 ],
	[ 45, "editContent_hasContact", 1 ],
	[ 46, "editContent_contactType", 1 ],
	[ 47, "editContent_customInclude", 1 ],
	[ 48, "editContent_imagePos", 1 ],
	[ 49, "editContent_imageCaption", 1 ],
	[ 50, "editContent_fliessTextSpalten", 1 ],
	
	[ 71, "addSidebar_pos", 3 ],
	[ 72, "addSidebar_titel", 3 ],
	[ 73, "addSidebar_text", 3 ],
	[ 74, "addSidebar_bild", 3 ],
	[ 75, "addSidebar_link", 3 ],
	
	[ 81, "editSidebar_pos", 3 ],
	[ 82, "editSidebar_titel", 3 ],
	[ 83, "editSidebar_text", 3 ],
	[ 84, "editSidebar_bild", 3 ],
	[ 85, "editSidebar_link", 3 ],
	
	[ 91, "addHeaderpanel_titel", 4 ],
	[ 92, "addHeaderpanel_text", 4 ],
	[ 93, "addHeaderpanel_bild", 4 ],
	[ 94, "addHeaderpanel_link", 4 ],
		
	[ 101, "editHeaderpanel_titel", 4 ],
	[ 102, "editHeaderpanel_text", 4 ],
	[ 103, "editHeaderpanel_bild", 4 ],
	[ 104, "editHeaderpanel_link", 4 ],
	
	[ 91, "addNews_titel", 9 ],
	[ 92, "addNews_text", 9 ],
	[ 93, "addNews_bild", 9 ],
	[ 94, "addNews_link", 9 ],
		
	[ 101, "editNews_titel", 9 ],
	[ 102, "editNews_text", 9 ],
	[ 103, "editNews_bild", 9 ],
	[ 104, "editNews_link", 9 ]
	
	
	
	]) 
/> 

<cfset ckToolbarItemList = "Source,Templates,Cut,Copy,Paste,PasteFromWord,Undo,Redo,Find,Replace,Bold,Italic,Underline,Strike,Subscript,Superscript,RemoveFormat,NumberedList,BulletedList,JustifyLeft,JustifyCenter,JustifyRight,JustifyBlock,Link,Unlink,Anchor,Image,Flash,Table,HorizontalRule,SpecialChar,Iframe,Styles,Format,Font,FontSize,TextColor,BGColor,Maximize,ShowBlocks" />
<cfset ckToolbarItemsDefault = "Source,Paste,PasteFromWord,Bold,Italic,Underline,Link,Unlink,Image,Table,HorizontalRule,Maximize" />



<!--- feldfreigaben--->
<cfquery name="getmandantenfeldfreigaben" datasource="#application.dsn#">
SELECT 	*
FROM	mandantenfeldfreigaben
WHERE	mandant = #url.editMandant#
</cfquery>


<!--- get DISTINCT Modules from above query --->
<cfquery name="getModules" dbtype="query">
SELECT 	DISTINCT [moduleID]
FROM	[getmandantenfeldfreigaben]
ORDER	BY [moduleID]
</cfquery>

<!--- <cfdump var="#getmandantenfeldfreigaben#"> --->

<table width="100%">
<tr>
	<td colspan="2">
		<table width="100%">
		<tbody>
		<cfloop query="getModules">
			
			<!--- first check if module is set for mandant --->
			<cfquery name="checkModules" datasource="#application.dsn#">
			SELECT	*
			FROM	mandantenmodules
			WHERE	moduleid = #moduleid# AND mandantenid = #url.editMandant#
			</cfquery>
			
			<cfif checkModules.recordcount NEQ 0>
				
				<!--- <cfquery name="getFields" dbtype="query">
				SELECT 	*
				FROM	[getModules]
				WHERE	[moduleid] = #moduleid#
				</cfquery> --->
				<!--- feldfreigaben pro modul: pagemanagement --->
				<cfquery name="getFields" dbtype="query">
				SELECT	*
				FROM	getmandantenfeldfreigaben
				WHERE 	moduleID = #moduleid#
				</cfquery>
				<cfquery name="getModuleName" datasource="#application.dsn#">
				SELECT 	module
				FROM	modules
				WHERE	id = #moduleid#
				</cfquery>
				<tr>
					<td>
						<cfoutput><strong>#getModuleName.module#</strong></cfoutput>
					</td>
				</tr>
				<tr>
					<td>
						
						<td valign="top">
							<cfoutput query="getFields" startrow="1" maxrows="#ceiling(getFields.recordcount/2)#">
								<input type="checkbox" name="#fieldName#" value="#fieldName#" <cfif getFields.fieldState EQ 1>checked</cfif>  /> #fieldName#<br/>
								<!---wenn WISIWIG Text, dann toolbar optionen einblenden --->
								<cfif fieldName EQ "addContent_fliesstext" OR fieldName EQ "editContent_fliesstext" OR fieldname EQ "editSidebar_text" OR fieldname EQ "addSidebar_text" OR fieldname EQ "addHeaderpanel_text" OR fieldname EQ "editHeaderpanel_text" OR fieldname EQ "addNews_text" OR fieldname EQ "editNews_text">
									
									<!--- toolbaritems checken--->
									<cfquery name="getmandantenfeldfreigabentoolbar" datasource="#application.dsn#">
									SELECT 	*
									FROM	feldtoolbaritems
									WHERE	mandant = #url.editMandant# AND feldname = '#fieldName#'
									</cfquery>
									<cfif getmandantenfeldfreigabentoolbar.recordcount EQ 0>
										<cfset f = ckToolbarItemsDefault />
									<cfelse>
										<cfset f = "" />
										<cfloop query="getmandantenfeldfreigabentoolbar">
											<cfset f = listAppend(f,toolbaritems) />
											
										</cfloop>
									</cfif>
								
									
									
									<a href="javascript:void(0);" onclick="$(this).next().toggle();">Toolbar customizen</a>
									<div style="display:none;background-color:##e5e5e5;">
										<cfloop list="#ckToolbarItemList#" index="i">
											<input type="checkbox" name="#fieldName#_toolbar" value="#i#" <cfif listFind(f,i)>checked="checked"</cfif> /> #i#<br/>
										</cfloop>
									</div>
									<br/>
								<!--- wenn Bild - dann bildresize optionen anbieten  --->
								<cfelseif fieldName EQ  "addPage_headerBild" OR fieldName EQ  "editPage_headerBild" OR fieldName EQ "addContent_bildname" OR fieldName EQ "editContent_bildname" OR fieldname EQ "editSidebar_bild" OR fieldname EQ "addSidebar_bild" OR fieldname EQ "editHeaderpanel_bild" OR fieldname EQ "addHeaderpanel_bild" OR fieldname EQ "addNews_bild" OR fieldname EQ "editNews_bild">
									<cfquery name="getmandantenfeldbildresize" datasource="#application.dsn#">
									SELECT 	*
									FROM	feldbildsize
									WHERE	mandant = #url.editMandant# AND fieldname = '#fieldName#'
									</cfquery>
									<a href="javascript:void(0);" onclick="$(this).next().toggle();">Resize customizen</a>
									<div style="display:none;background-color:##FFF;">
										
										#fieldName# Bildbreite: <input type="text" name="#fieldName#_resize" value="<cfif getmandantenfeldbildresize.recordcount NEQ 0>#getmandantenfeldbildresize.resizevalue_width#</cfif>" style="width:50px;" /> <br/>
										
									</div>
									<br/>
								
								</cfif>
								
							</cfoutput>
						</td>
						
						<td valign="top">
							<cfoutput query="getFields" startrow="#ceiling(getFields.recordcount/2+1)#" maxrows="#getFields.recordcount#">
								<input type="checkbox" name="#fieldName#" value="#fieldName#" <cfif getFields.fieldState EQ 1>checked</cfif>  /> #fieldName#<br/>
								<cfif fieldName EQ "addContent_fliesstext" OR fieldName EQ "editContent_fliesstext" OR fieldname EQ "editSidebar_text" OR fieldname EQ "addSidebar_text" OR fieldname EQ "addHeaderpanel_text" OR fieldname EQ "editHeaderpanel_text" OR fieldname EQ "addNews_text" OR fieldname EQ "editNews_text">
									<!--- toolbaritems checken--->
									<cfquery name="getmandantenfeldfreigabentoolbar" datasource="#application.dsn#">
									SELECT 	*
									FROM	feldtoolbaritems
									WHERE	mandant = #url.editMandant# AND feldname = '#fieldName#'
									</cfquery>
									<cfif getmandantenfeldfreigabentoolbar.recordcount EQ 0>
										<cfset f = ckToolbarItemsDefault />
									<cfelse>
										<cfset f = "" />
										<cfloop query="getmandantenfeldfreigabentoolbar">
											<cfset f = listAppend(f,toolbaritems) />
											
										</cfloop>
									</cfif>
									<a href="javascript:void(0);" onclick="$(this).next().toggle();">Toolbar customizen</a>
									<div style="display:none;background-color:##e5e5e5;">
										<cfloop list="#ckToolbarItemList#" index="i">
											<input type="checkbox" name="#fieldName#_toolbar" value="#i#" <cfif listFind(f,i)>checked="checked"</cfif> /> #i#<br/>
										</cfloop>
									</div>
									<br />
									<!--- wenn Bild - dann bildresize optionen anbieten  --->
								<cfelseif fieldName EQ  "addPage_headerBild" OR fieldName EQ  "editPage_headerBild" OR fieldName EQ "addContent_bildname" OR fieldName EQ "editContent_bildname" OR fieldname EQ "editSidebar_bild" OR fieldname EQ "addSidebar_bild" OR fieldname EQ "editHeaderpanel_bild" OR fieldname EQ "addHeaderpanel_bild" OR fieldname EQ "addNews_bild" OR fieldname EQ "editNews_bild">
									<cfquery name="getmandantenfeldbildresize" datasource="#application.dsn#">
									SELECT 	*
									FROM	feldbildsize
									WHERE	mandant = #url.editMandant# AND fieldname = '#fieldName#'
									</cfquery>
									
									<a href="javascript:void(0);" onclick="$(this).next().toggle();">Resize customizen</a>
									<div style="display:none;background-color:##FFF;">
										
										#fieldName# Bildbreite: <input type="text" name="#fieldName#_resize" value="<cfif getmandantenfeldbildresize.recordcount NEQ 0>#getmandantenfeldbildresize.resizevalue_width#</cfif>"  style="width:50px;" /> <br/>
										
									</div>
									<br/>
								</cfif>
							</cfoutput>
						</td> 
						
					</td>
				</tr>		
			</cfif>
		</cfloop>
		</tbody>
		</table>
	</td>
</tr>
</table>