<cfcomponent name="controller" output="Yes" hint="CoFight-19 Controller">

	<cffunction name="init" output="No" access="public" description="Constructor" returntype="controller" hint="CoFight-19 Constructor">
		<cfreturn this />
	</cffunction>

	<!--- Model --->
	<cffunction name="user_register" access="remote" returntype="string" returnformat="plain" output="No" hint="Required to register user at the remote database. Only mobile phone is needed.">
		<cfargument name="telephone" type="string" default="" hint="mobile number including country code and area code">
		<cfreturn createObject("component","cfc.model").init().user_register(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="user_activate" access="remote" returntype="string" returnformat="plain" output="No" hint="Verify & Activate a combination of telephone and temp authentication code which is sent via SMS at the telephone upon registration">
		<cfargument name="telephone" type="string" default="" hint="mobile number including country code and area code">
		<cfargument name="auth_code" type="string" default="" hint="random authentication code which is generated and sent via SMS at the telephone number upon successful registration">
		<cfreturn createObject("component","cfc.model").init().user_activate(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="user_upload_data" access="remote" returntype="string" returnformat="plain" output="No" hint="Uploads data at the remote server to be processed by the local authorities">
		<cfargument name="user_id" type="string" default="" hint="upon successful registration, server will generate a unique user_id which shall be used for the BLE communication between devices">
		<cfargument name="jdata" type="string" default="" hint="an array containing a JSON object of the form [{'user_id': 000000, 'ts':0000000000000},{'user_id': 000000, 'ts':0000000000000}] containing the contacts between the devices. user_id denotes the unique user identification code whereas ts stands for Time Stamp in Unix Format">
		<cfreturn createObject("component","cfc.model").init().user_upload_data(argumentCollection=arguments) />
	</cffunction>
	<!--- /Model --->


	<!--- View --->

	<!--- /View --->

</cfcomponent>