# CoFight-19 Server

Ok, so you have downloaded [CoFight-19 Android Client](https://github.com/CoFight-19/cofight-android "CoFight-19 Android Client") and [CoFight-19 iOS Client](https://github.com/CoFight-19/cofight-ios "CoFight-19 iOS Client"), now what?

When a user downloads and installs one of the aforementioned clients they will be asked to enter their mobile number. Server will accept this mobile number, store it on an SQL Database, generate a unique identifier and return it at the client. Communication between clients is achieved only by exchanging these unique identifiers, never telephone numbers. Only the server owner will be able to access the mapping between a unique user identifier and a telephone number. Typically, this is to be used by the local authorities to help tracing all recent contacts of a SARS-CoV-2 infected citizen.

In a nutshell, when a citizen is tested positive for Covid-19 authorities need to track recent contact the patient made to warn or quarantine those citizens. CoFight-19 is a volunteering effort to create a complete (basic) stack for setting up a system for tracing contacts.


## Application Server

This code requires a CFML engine. It has been successfully tested on [Adobe ColdFusion 2018](https://www.adobe.com/products/coldfusion-family.html "Adobe ColdFusion 2018")  but it is guaranteed that it will work on the Open Source [Lucee Server](https://lucee.org/ "Lucee Server") as well. As the code is straight forward to read, it can be easily translated to other technologies too.

* Open Source [Lucee Server](https://lucee.org/ "Lucee Server")
* Commercially available [Adobe ColdFusion 2018](https://www.adobe.com/products/coldfusion-family.html "Adobe ColdFusion 2018")

###Application Installation###
Create a new project under your CFML engine. Place the two files _controller.cfc_ and _model.cfc_ under your new web application root. The project is engineered on an MVC model, however since this is a simple API there is no any _View_ at the moment. Follow the Database Server installation instructions to set-up a new database and create a new datasource to point there.

* _controller.cfc_

You don't really need to modify anything at the controller. In case you need to extend this application, it is recommended to always register all your new methods in there, of course. All available methods are self-explained either by naming convention or by the provided _hint_ arguments that CFML supports.

* model.cfc

Model contains a lot of inline useful comments. Typically, you will need to enter your project's new datasource at the constructor method, by replacing the existing _\_DATASOURCE\__ with your own one.

Next, is to go through the comments and change the Telephone Number validation in a few locations that are clearly marked. You should change this either by setting your own regular expression or by using your own custom validation so that the telephone numbers of your own country are correctly validated and allowed. Finally, you will need to write your own SMS Gateway integration code at the _send\_sms\_code()_ method.

## Database Server

The project has been designed and developed on Microsoft SQL Server but we cannot see any reason why this should not work on Oracle, MySQL or any other SQL server. Notice that in order to be able to handle massive data we have applied a spooling approach. All data are uploaded, stored in a spool table and then, a stored procedure will handle them in batches. We have stressed-tested this project for millions of records with no problems at all. Batch-processing allows no table locks, no uncommitted transactions, no waits or deadlocks. 

###Database Installation###
You will need to create a new database on Microsoft SQL and then execute all .sql scripts which are provided within this repository. 

#####Tables#####

* tbl_user.sql
* tbl\_user\_log.sql
* tbl\_user\_log\_spool.sql

#####Stored Procedures#####

* sp\_cofight\_process\_spool.sql
* sp\_cofight\_clear\_history.sql

#####Scheduled Jobs#####
You should create two different scheduled jobs, to execute on a timely manner both _sp\_cofight\_process\_spool_ and _sp\_cofight\_clear\_history_ . Frequency depends on your resource availability.  


## Security Concerns

* Access to the database should only be provided at the local authorities or authorized personnel. We don't keep information such as personal details, medical records or any geo-location related entries. We don't need that. We only need the telephone number of the user that is contributing to this joint-effort so that the authorities can call and warn him/her about a recent contact with an infected citizen.
* Data is only kept on the client-side, unless of course the end-users decide to contribute.
* Server code handles well-known attacks such as SQL-injections, however it is strongly recommended to add the application behind a secured environment. In addition to that, since the entire system will be working native, it is recommended to block access of non-local IPs at the server.