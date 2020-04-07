<cfcomponent name="model" output="No" hint="CoFight-19 Model">

	<cffunction name="init" output="No" access="public" description="Constructor" hint="Constructor" returntype="model">
		<cfargument name="dsn" type="string" default="__DATASOURCE__">
		<cfset this.dsn = arguments.dsn>
		<cfreturn this />
	</cffunction>
	

	<cffunction name="user_register" access="public" returntype="string" returnformat="plain" output="no" hint="Will accept a valid telephone and return 1 if successful, 0 if failed. If telephone is already register it will refresh the auth code and will resend SMS to re-verify. This scenario is possible when user changes his/her mobile device or uninstalls/reinstalls the app.">
		<cfargument name="telephone" type="string" default="">
 	
		<!--- Initialization of parameters --->
		<cfset local.telephone = trim(replace(replace(arguments.telephone,' ','','ALL'),'-','','ALL'))>
		<cfset local.result    = 0>


		<!--- ----------------------------------------------------------- --->
		<!--- 				Hardcoded Apple Credentials 			  	  --->
		<!--- ----------------------------------------------------------- --->
		<!--- Nasty but required code.  	  							  --->
		<!--- Apple will ask a sample telephone number to use during the  --->
		<!--- review process. Feel free to modify the following telephone --->
		<!--- When entered by apple, execution will bypass all the SQL	  --->
		<!--- steps which will not be needed for the Apple review	  	  --->
		<!--- Better to get rid of it after Apple completes their review  --->
		<!--- ----------------------------------------------------------- --->

		<cfif local.telephone eq '99999999'>
			<cfreturn 1 />
		</cfif>


		<!--- ------------------------------------------------------------ --->
		<!--- 				Telephone Number Validation 				   --->
		<!--- ------------------------------------------------------------ --->
		<!--- Modify this statement to validate your country's local       --->
		<!--- mobile numbers. For example, in Cyprus, all mobile numbers   --->
		<!--- are prefixed by the digit 9 whereas the length of every      --->
		<!--- number is 8. Feel free to modify and validate through your   --->
		<!--- preferred Regular Expression 	   							   ---> 
		<!--- ------------------------------------------------------------ --->

		<cfif left(local.telephone,1) eq 9 AND len(local.telephone) eq 8>

			<cfquery name="qRegister" datasource="#this.dsn#">
				DECLARE @TELEPHONE INT 			  = <cfqueryparam value="#local.telephone#" cfsqltype="cf_sql_bigint">
				DECLARE @AUTH_CODE INT 			  = (CONVERT([int],rand()*((9999)-(1000))+(1000),(0)));
				DECLARE @ACCESS_TOKEN VARCHAR(50) = substring(lower(replace(newid(),'-','')),1,15);

				IF NOT EXISTS(SELECT user_id FROM tbl_user WHERE telephone = @TELEPHONE)
				BEGIN
					INSERT INTO
						tbl_user (telephone,auth_code,access_token)
					VALUES
						(@TELEPHONE,@AUTH_CODE,@ACCESS_TOKEN)
				END
				ELSE
				BEGIN
					UPDATE 
						tbl_user
					SET
						 auth_code = @AUTH_CODE
						,dt = getdate()
						,ts = datediff(second,'1970/01/01 00:00:00',getdate())
						,is_verified = 0
					WHERE
						telephone = @TELEPHONE
				END
				SELECT 
					 @AUTH_CODE as auth_code
			</cfquery>

			<cfset send_sms_code(telephone=local.telephone, auth_code=qRegister.auth_code)>

			<cfset local.result = 1>

		</cfif> 

		<cfreturn local.result />
	</cffunction>


	<cffunction name="user_activate" access="public" returntype="string" returnformat="plain" output="yes">
		<cfargument name="telephone" type="string" default="">
		<cfargument name="auth_code" type="string" default="">

		<cfset local.telephone 	  = trim(arguments.telephone)>
		<cfset local.telephone 	  = replace(replace(local.telephone,' ','','ALL'),'-','','ALL')>
		<cfset local.auth_code 	  = isValid("integer",arguments.auth_code) ? arguments.auth_code : 0>
		<cfset local.result    	  = '{"user_id": 0,"access_token": ""}'>

		<!--- ----------------------------------------------------------- --->
		<!--- 				Hardcoded Apple Credentials 			  	  --->
		<!--- ----------------------------------------------------------- --->
		<!--- Apple will ask a sample telephone number as well as an  	  --->
		<!--- to use during the review process. Feel free to modify  	  --->
		<!--- the following telephone. If entered through the app, the	  --->
		<!--- execution will skip all the SQL steps which will not be	  --->
		<!--- needed for the Apple review	 							  --->
		<!--- 															  --->
		<!--- ----------------------------------------------------------- --->

		<cfif local.telephone is '99999999' AND local.auth_code eq 1234>
			<cfreturn '{"user_id":1064220,"access_token": "qwertyuhgtfdesw"}' />
		</cfif>



		<!--- ------------------------------------------------------------ --->
		<!--- 				Telephone Number Validation 				   --->
		<!--- ------------------------------------------------------------ --->
		<!--- Modify this statement to validate your country's local       --->
		<!--- mobile numbers. For example, in Cyprus, all mobile numbers   --->
		<!--- are prefixed by the digit 9 whereas the length of every      --->
		<!--- number is 8    										   	   --->
		<!--- 															   --->
		<!--- ------------------------------------------------------------ --->

		<cfif left(local.telephone,1) eq 9 AND len(local.telephone) eq 8 AND local.auth_code is not ''>

			<cfquery name="qAuthorize" datasource="#this.dsn#">
				DECLARE @USER_ID INT   = 0;
				DECLARE @TELEPHONE INT = <cfqueryparam value="#local.telephone#" cfsqltype="cf_sql_bigint">
				DECLARE @AUTH_CODE INT = <cfqueryparam value="#local.auth_code#" cfsqltype="cf_sql_integer">

				SET @USER_ID = isNULL((SELECT TOP 1 user_id FROM tbl_user WHERE telephone = @TELEPHONE AND auth_code = @AUTH_CODE AND is_verified = 0),0);

				IF @USER_ID > 0
				BEGIN

					UPDATE 
						tbl_user
					SET
						is_verified = 1
					WHERE
						telephone = @TELEPHONE
					AND
						auth_code = @AUTH_CODE

					SELECT 
						 user_id
						,access_token
					FROM
						tbl_user
					WHERE
						user_id = @USER_ID

				END
				ELSE
				BEGIN
					SELECT 
						 0 as user_id
						,'' as access_token
				END
			</cfquery>

			<cfset local.result = '{"user_id": #qAuthorize.user_id#,"access_token": "#qAuthorize.access_token#"}'>

		</cfif>
 	
		<cfreturn local.result />
	</cffunction>

	<cffunction name="user_upload_data" access="public" returntype="string" returnformat="plain" output="yes">
		<cfargument name="user_id" type="string" default="">
		<cfargument name="access_token" type="string" default="">
		<cfargument name="jdata" type="string" default="">

		<cfset local.user_id 	  = isValid("integer",arguments.user_id) ? arguments.user_id : 0>
		<cfset local.access_token = trim(arguments.access_token)>
		<cfset local.jdata 	 	  = isJSON(arguments.jdata) ? deserializeJSON(arguments.jdata) : ArrayNew(1)>
		<cfset local.result  	  = false>

		<cfif ArrayLen(local.jdata) gt 0>
	
			<cfquery name="qSpool" datasource="#this.dsn#">
				IF EXISTS (SELECT user_id FROM tbl_user WHERE is_verified=1 AND user_id = <cfqueryparam value="#local.user_id#" cfsqltype="cf_sql_integer"> AND access_token = <cfqueryparam value="#local.access_token#" cfsqltype="cf_sql_varchar">)
				BEGIN

					<cfloop array="#local.jdata#" index="i">

						<cfif isValid("integer",i.ts) AND isValid("integer",i.user_id)>

							<cfsavecontent variable="local.cmd">
								IF NOT EXISTS (SELECT ulog_id FROM tbl_user_log WHERE user_id=#local.user_id# AND meet_ts=#i.ts# AND user_id2 = #i.user_id#) INSERT INTO tbl_user_log (user_id,meet_ts,user_id2) VALUES (#local.user_id#,#i.ts#,#i.user_id#);
							</cfsavecontent>

							INSERT INTO 
								tbl_user_log_spool (user_id,cmd) 
							VALUES 
								(#local.user_id#,'#trim(PreserveSingleQuotes(local.cmd))#');

							<cfset local.result  = true>

						<cfelse>

							PRINT NULL;

							<cfset local.result  = false>
							<cfbreak>
						</cfif>

					</cfloop>
	
				END
			</cfquery>

		</cfif>
 	
		<cfreturn local.result />
	</cffunction>



	<cffunction name="send_sms_code" access="public" returntype="void" output="no">
		<cfargument name="telephone" type="string" default="">
		<cfargument name="auth_code" type="string" default="">


		<!--- ------------------------------------------------------------ --->
		<!--- 				Telephone Number Validation 				   --->
		<!--- ------------------------------------------------------------ --->
		<!--- Modify this statement to validate your country's local       --->
		<!--- mobile numbers. For example, in Cyprus, all mobile numbers   --->
		<!--- are prefixed by the digit 9 whereas the length of every      --->
		<!--- number is 8.    										   	   --->
		<!--- 															   --->
		<!--- Authentication code also is validated for a 4-digit string   --->
		<!--- If you are planning to change auth code format, remember to  --->
		<!--- change the validation of the format here too.  			   --->
		<!--- ------------------------------------------------------------ --->

		<cfset local.telephone = trim(replace(replace(arguments.telephone,' ','','ALL'),'-','','ALL'))>
		<cfset local.auth_code = isValid("integer",arguments.auth_code) AND len(arguments.auth_code) eq 4 ? arguments.auth_code : ''>
		<cfset local.message   = "Your activation code is #local.auth_code#">

		<cfif left(local.telephone,1) eq 9 AND len(local.telephone) eq 8 AND local.auth_code is not ''>

			<!--- Your SMS Gateway Code should go here.  --->
			<!--- Typically, you will need to push the   --->
			<!--- variable #local.message# at the mobile --->
			<!--- number #local.telephone# 				 --->

		</cfif>
	</cffunction>


</cfcomponent>