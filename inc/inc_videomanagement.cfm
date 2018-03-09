<cfprocessingdirective pageencoding="utf-8" />

<!--- video prozessierungs cfc. irgendwo im netz gefunden und in meinem publishr getestet (flv leider nur) --->
<cffunction name="processStream" access="public" output="false" returntype="boolean" hint="Returns true if stream was successfully processed">
	<cfargument name="in" type="any" required="true" hint="java.io.InputStream object">
	<cfargument name="logPath" type="string" required="false" default="" hint="Full path to LogFile">
	<cfset var out = "">
	<cfset var writer = "">
	<cfset var reader = "">
	<cfset var buffered = "">
	<cfset var line = "">
	<cfset var sendToFile = false>
	<cfset var errorFound = false>
	
	<cfscript>
		if ( len(trim(arguments.logPath)) ) {
			out = createObject("java", "java.io.FileOutputStream").init(arguments.logPath);
			writer = createObject("java", "java.io.PrintWriter").init(out);
			sendToFile = true;
		}

		reader = createObject("java", "java.io.InputStreamReader").init(arguments.in);
		buffered = createObject("java", "java.io.BufferedReader").init(reader);
		line = buffered.readLine();
		while ( IsDefined("line") ) {
			if (sendToFile) {
				writer.println(line);
			}
			line = buffered.readLine();
		}    
		   if (sendToFile) {
		   errorFound = writer.checkError();
		   writer.flush();
		   writer.close();
		}
	</cfscript>
	<cfreturn (NOT errorFound)>
</cffunction>


<style type="text/css">
##activ{
	color:##3F3;
	}

##inactiv{
	color:##0F9;
	}

table tr:nth-child(2n){
	background:##949494;
	}
	
	
table tr:nth-child(2n+1){
	background:##B2B2B2;
	}

##addUser{
	background-color:##E5E5E5;
	letter-spacing:2px;
	list-style-type:none;
	}
	
##addUser:hover{
	-webkit-transition:all ease-in  300ms;
	-moz-transition:all ease-in  300ms;
	background-color:##FEFEFE;
	}	
</style> 

<!--- -------------- form prozessors ------------------ --->


<!--- alle Videos auslesen datasource application --->
<cfquery name="getVideo" datasource="#application.dsn#">
SELECT	*
FROM	videos
WHERE	mandant = #session.mandant#
</cfquery>


<!--- Video löschen --->
<!--- id des zu löschenden videoss auslesen und auf isNumeric prüfen und muss gt 0 sein. --->
<cfif isdefined("url.delvideo") AND isNumeric(url.delvideo) AND url.delvideo GT 0>
	<cfquery name="delvideo" datasource="#application.dsn#">
	DELETE
	FROM	videos
	WHERE	id = #url.delvideo#
	</cfquery>
	<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- Video hinzufügen --->
<cfif isdefined("url.action") AND url.action EQ "submittedNewVideo" AND isdefined("form.titel")>
		<cfset actionSuceeded = true />
		
		<!--- video upload --->
		<!--- wenn ein video ausgewählt wurde --->
		<cfif form.video NEQ "">
			<!--- video auf den server in relativpfad-folder uploaden --->
			<cffile action="upload" filefield="video" destination="#expandpath('/' & session.serverpath & '/upload/videos')#" nameconflict="makeunique">
			
			
			<cfset inputFilePath = expandpath('/' & session.serverpath & '/upload/videos/') & cffile.serverfile>
			<cfset ouputFilePath = expandpath('/' & session.serverpath & '/upload/videos/') & "converted_" & cffile.serverfile>
			<cfexecute 	name="c:\windows\system32\cmd.exe" 
						arguments="/c #expandPath('/admin/inc/ffmpeg/FFmpeg-svn-21231/ffmpeg.exe')# -i #inputFilePath# -g 300 -y -s 460x405 -f mp4 -ar 44100 #ouputFilePath#" 
						timeout="1200" variable="executeLog"></cfexecute>
			
			<cfdump var="#executeLog#">
	
			
			
			<!--- <cfset fsVideoFile = expandpath('/' & session.serverpath & '/upload/videos') & cffile.serverfile>
			<cfset width = 640>
			<cfset height = 360>
			<cfset duration = 0>
			
			<cfexecute
			   name = "inc\ffmpeg\FFmpeg-svn-21231/ffprobe.exe"
			   arguments="#fsVideoFile# -v quiet -print_format json -show_format -show_streams"
			   timeout="60"
			   variable="jsonInfo"
			   errorVariable="errorOut" />
			
				<cfif IsJSON (jsonInfo)>
				   <cfset videoInfo = DeserializeJSON (jsonInfo)>
				   <cfdump var="#videoInfo#">
				</cfif> --->
			
			<cfabort>	
			
			<!--- dieser code ist eher alt und wird hier wiederverwendet und angepasst an aktuelle bedürfnisse: mp4,webm und ogv (+flv fallback) --->
			<cfif 	cffile.serverfileext EQ "qt" OR
					cffile.serverfileext EQ "avi" OR
					cffile.serverfileext EQ "wmv" OR
					cffile.serverfileext EQ "mpg" OR
					cffile.serverfileext EQ "ogv" OR
					cffile.serverfileext EQ "mp4">
		
			<cfset ffmpegPath = expandPath('/admin/inc/ffmpeg/FFmpeg-svn-21231/ffmpeg.exe')>
			<cfset ffmpegOggPath = expandPath('/admin/inc/ffmpeg/ffmpeg2theora029.exe')>
			<cfset resultLog = expandPath('/admin/inc/ffmpeg/FFmpeg-svn-21231/testOuput_result.log')>
			<cfset errorLog = expandPath('/admin/inc/ffmpeg/FFmpeg-svn-21231/testOuput_error.log')>
			<cfset inputFilePath = expandpath('/' & session.serverpath & '/upload/videos/') & cffile.serverfile>
			<cfset ouputFilePath = expandpath('/' & session.serverpath & '/upload/videos/') & "converted_" & cffile.serverfile>
			<cfset ouputFileName = expandpath('/' & session.serverpath & '/upload/videos/') & 'thumb_' & cffile.serverfilename & ".jpg">
			<cfset results = structNew()>
			
			
			
			<!--- read video-infos for conversion and resizing --->
			<cfscript>
				runtime = createObject("java", "java.lang.Runtime").getRuntime();
				comma = '#ffmpegPath# -i "#inputFilePath#"'; 
				process = runtime.exec(#comma#);
				results.errorLogSuccess = processStream(process.getErrorStream(), errorLog);
				results.resultLogSuccess = processStream(process.getInputStream(), resultLog);
				results.exitCode = process.waitFor();
			</cfscript>
			
			
			<cftry>	
				<!--- process conversion and resizing --->
				<cfscript>
					try {
						//runtime = createObject("java", "java.lang.Runtime").getRuntime();
						//command = '#ffmpegPath# -i "#inputFilePath#" -g 300 -y -s 460x405 -f flv -ar 44100 "#ouputFilePath#"'; 
						command = '#ffmpegPath# -i "#inputFilePath#" -vcodec libx264 -vpre libx264-ipod640 -b 250k -bt 50k -acodec libfaac -ab 56k -ac 2 -s 640x360 "#ouputFilePath#" -movflags +faststart';
						//command = 'qt-faststart #ouputFilePath# #ouputFilePath#';
						process = runtime.exec(#command#);
						results.errorLogSuccess = processStream(process.getErrorStream(), errorLog);
						results.resultLogSuccess = processStream(process.getInputStream(), resultLog);
						results.exitCode = process.waitFor();
						//make thumbnail from video
						/*command2 = '#ffmpegPath# -itsoffset -4  -i "#inputFilePath#" -vcodec mjpeg -vframes 1 -an -f rawvideo -s 135x101 "#ouputFileName#.jpg"';
						process = runtime.exec(#command2#);
						results.errorLogSuccess = processStream(process.getErrorStream(), errorLog);
						results.resultLogSuccess = processStream(process.getInputStream(), resultLog);
						results.exitCode = process.waitFor();
						// make ogv video
						command3 = '#ffmpegOggPath# -o "#ouputFilePath#" "#inputFilePath#"';
						process = runtime.exec(#command3#);
						results.errorLogSuccess = processStream(process.getErrorStream(), errorLog);
						results.resultLogSuccess = processStream(process.getInputStream(), resultLog);*/
					}
					catch(exception e) {
						results.status = e;    
					}
				</cfscript>
				<!--- exception --->
				<cfcatch type="any">
					<!--- write error-log --->
					<cffile action="write" file="#expandpath('/admin/videoCOnversionError.txt')#" nameconflict="overwrite" output="#toString(cfcatch)#">
				</cfcatch>
			</cftry>
		
			<cfabort>
			
			</cfif>
			
			
		<cfelse>
			<cfset servervideoname = "">
		</cfif>
		
		<cfquery name="insertVideo" datasource="#application.dsn#">
		INSERT	
		INTO	videos (
				titel,
				beschreibung,
				videoPathMP4,
				videoPathOGV,
				videoPathWEBM,
				videoPathFLV,
				optionFullscreen, 
				optionPlayer,
				optionDownload,
				optionAutoPlay,
				posterImage,
				contentid,
				isActive,
				creator,
				createDate,
				mandant 
				)
		VALUES(
				'',
				'',
				'',
				'',
				'',
				'',
				1, 
				1,
				1,
				1,
				'',
				0,
				1,
				0,
				'',
				#session.mandant#
		)
		</cfquery>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
</cfif>

<!--- Video updaten --->
<cfif isdefined("url.action") AND url.action EQ "submittededitedVideo" AND isdefined("form.titel")>

		<cfset actionSuceeded = true />
		
		<!--- video upload --->
		<!--- wenn ein video ausgewählt wurde --->
		<cfif form.video NEQ "">
			<!--- video auf den server in relativpfad-folder uploaden --->
			<cffile action="upload" filefield="video" destination="#expandpath('/' & session.serverpath & '/upload/videos')#" nameconflict="makeunique">
			
			
			
			
			
			
			
		<cfelseif isdefined("delvideo")>
			<cfset servervideoname = "">
		<cfelse>
			<cfset servervideoname = form.origvideo>
		</cfif>
		
		<cfquery name="updatevideos" datasource="#application.dsn#">
		UPDATE	videos
		SET		titel = '',
				beschreibung = '',
				videoPathMP4 = '',
				videoPathOGV = '',
				videoPathWEBM = '',
				videoPathFLV = '',
				optionFullscreen = 1, 
				optionPlayer = 1,
				optionDownload = 1,
				optionAutoPlay = 1,
				posterImage = '',
				contentid = 0,
				isActive = 1,
				creator = 0,
				createDate = '',
				mandant = #session.mandant#
		WHERE	id = #form.videoid#
		</cfquery>
		<cflocation url="#cgi.SCRIPT_NAME#" addtoken="no">
	
</cfif>

<!--- zu bearbeitenden videos aus db lesen (aufgrund seiner übermittelten ID) --->
<cfif isdefined("url.editVideos") AND isNumeric(url.editVideos) AND url.editVideos GT 0>
	<cfquery name="editVideo" datasource="#application.dsn#">
	SELECT	*
	FROM	videos
	WHERE	id = #url.editVideos#
	</cfquery>
</cfif>

<!--- -------------- ENDE form prozessors ------------------ --->

<!--- liste mit allen Users darstellen --->

<h2>Video Management</h2>

<h4>Jede Seite kann verschiedene Elemente aufweisen (rechts oder unten)</h4>

<table width="100%">
<tr>
	<td><strong>Titel</strong></td>
	<td><strong>Status</strong></td>
	<td><strong>Video löschen ?</strong></td>
	<td><strong>Video bearbeiten ?</strong></td>
</tr>
<cfoutput query="getVideo">
<tr>
	<td>#titel#</td>
	<td>
	<!--- wenn db-variable isactive=1 then schreibe aktiv sonst inaktiv & colorcode dementsprechend --->
		<cfif isactive EQ 1>
		<div id="activ">	aktiv</div>
		<cfelse>
		<div id="inactiv">	inaktiv </div>
		</cfif>
	</td>
<!---	.videosdel  / .videosedit sind funktionen mit der jeweiligen videosID die als url. parameter mitgegeben werden--->
	<td>
		<a href="#cgi.SCRIPT_NAME#?delvideo=#id#" onclick="return confirm('Sind Sie sicher?');">
			löschen
		</a>
	</td>
	<td>
		<a href="#cgi.SCRIPT_NAME#?editvideo=#id#">
			bearbeiten
		</a>
	</td>
</tr>
</cfoutput>
</table>
<br/>

<!--- dies erscheint nur wenn videos element erfassen gewählt wurde --->

<cfoutput>
<cfif (isdefined("url.action") AND url.action EQ "addVideo") OR (isdefined("actionSuceeded") AND actionSuceeded EQ false)>
	<cfif isdefined("actionSuceeded") AND actionSuceeded EQ false>
	ES IST EIN FEHLER AUFGERTEREN
	</cfif>
<!--- 	BEI JEDEM Binary fileupload muss im Formular multipart/form-data als enctype mitgegeben werden.  --->
	<form action="#cgi.SCRIPT_NAME#?action=submittedNewVideo" method="post" enctype="multipart/form-data">
	<table>
	<tr>
		<td>Status</td>
		<td>
			<input type="radio" name="active" value="1" checked="checked"> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0"> inaktiv
		</td>
	</tr>
	<tr>
		<td>Video Titel</td>
	<!---	wen der user schon erfasst ist und form.vorname schon definiert ist -> prepopulate form.vorname --->
		<td><input type="text" name="titel" <cfif isdefined("form.titel")>value="#form.titel#"</cfif>></td>
	</tr>
	<tr>
		<td>Text</td>
		<!---wenn schon ein text exisiter dann prepopulate diesen hier sonst leeres eingabefeld  --->
		<td><textarea name="text" id="text" cols="1" rows="1" style="width:100%;height:120px;"><cfif isdefined("form.fliesstext")>#fliesstext#</cfif></textarea></td>
	</tr>
	<tr>
		<td>Video</td>
		<td>
			<input type="file" name="video">
		</td>
	</tr>
	<tr>
		<td>Link (inkl- http://)</td>
		<td>
			<input type="text" name="hreflink" value="<cfif isdefined("form.hreflink")>#hreflink#</cfif>">
		</td>
	</tr>
	<tr>
		<td>Link-Label</td>
		<td>
			<input type="text" name="linklabel" value="<cfif isdefined("form.hreflabel")>#hreflabel#</cfif>">
		</td>
	</tr>
	<tr>
		<td></td>

		<td>
		
		<input type="submit" value="Video erfassen"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';"></td>
	</tr>
	</table>
	</form>
	
<cfelseif NOT isdefined("url.editvideo")>
	<a href="#cgi.SCRIPT_NAME#?action=addVideo" id="addVideo" > + neues Video erfassen</a>
</cfif>
</cfoutput>




<!--- dies erscheint nur wenn videos bearbeiten gewählt wurde und userID grösser 0  --->
<cfif isdefined("url.editvideo") AND isNumeric(url.editvideo) AND url.editvideo GT 0>
<cfoutput query="editVideo">
	<h3>Video #titel# bearbeiten</h3>
	<form action="#cgi.SCRIPT_NAME#?action=submittededitedVideo" method="post" enctype="multipart/form-data">
	<table>
	<tr>
		<td>Status</td>
		<td>
			<input type="radio" name="active" value="1" <cfif isactive EQ 1>checked="checked"</cfif>> aktiv  &nbsp; &nbsp;
			<input type="radio" name="active" value="0" <cfif isactive EQ 0>checked="checked"</cfif>> inaktiv
		</td>
	</tr>
	<tr>
		<td>Video Titel</td>
	<!---	wen der user schon erfasst ist und form.vorname schon definiert ist -> prepopulate form.vorname --->
		<td><input type="text" name="titel" value="#titel#"></td>
	</tr>
	<tr>
		<td>Text</td>
		<!---wenn schon ein text exisiter dann prepopulate diesen hier sonst leeres eingabefeld  --->
		<td><textarea name="text"  class="ckeditor" id="text" cols="1" rows="1" style="width:100%;height:100px;">#fliesstext#</textarea></td>
	</tr>
	<tr>
		<td>Video</td>
		<td>
			<cfif image NEQ "">
			Momentanes Video auf dem Server: <a href="/#session.serverpath#/upload/videos/#image#" target="_blank">#image#</a><br/>
			<input type="checkbox" name="delvideo" value="#image#" /> Video löschen<br/>
			</cfif>
			<input type="file" name="video">
			<input type="hidden" name="origvideo" value="#image#" />
		</td>
	</tr>
	<tr>
		<td>Link (inkl- http://)</td>
		<td>
			<input type="text" name="hreflink" value="#href#">
		</td>
	</tr>
	<tr>
		<td>Link-Label</td>
		<td>
			<input type="text" name="linklabel" value="#hreflabel#">
		</td>
	</tr>
	<tr>
		<td></td>
		<td>
			<!--- hidden id der videos mitgeben für das WHERE statement im SQL EDITvideos  --->
			<input type="hidden" name="videoid" value="#id#" />
			<input type="submit" value="Video ändern"> <input type="button" value="abbrechen" onclick="location.href='#cgi.SCRIPT_NAME#';">
		</td>
	</tr>
	</table>
	</form>
</cfoutput>
</cfif>