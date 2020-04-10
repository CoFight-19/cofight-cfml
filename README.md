
# CoFight-19 Server
Ok, so you have downloaded [CoFight-19 Android Client](https://github.com/CoFight-19/cofight-android "CoFight-19 Android Client") and [CoFight-19 iOS Client](https://github.com/CoFight-19/cofight-ios "CoFight-19 iOS Client"), now what?

## Background
Once users download and install one of the aforementioned clients they will be asked to enter their mobile number. Client will post the mobile number to the server which will store it on an SQL Database, generate a unique identifier (_uid_) and return it to the client. Client stores _uid_ on it's file system and keeps it there for as long as the client is installed. Once a mobile device gets into the Bluetooth range of the other, both clients will exchange _uid_. Each client maintains a catalog, holding list of all devices intersected.

Timestamp  | Device 
---------- | ------------- 
1586547175 | 45980286 
1586547269 | 62749271 
1586547282 | 45980286 
1586548174 | 62749271 

This catalog holds intersections for 21 days although this is a setting that can be changed. Client will never post the catalog at the server side unless the user chooses to do so. Typically this will be ideal if the mobile owner is tested positive for Covid-19. By uploading his/her catalog he can contribute to stop the spread of the SARS-CoV-2 virus.

In a nutshell, this project is attempting to proactively form a network of intersections. When a citizen is tested positive for Covid-19, the goal is to _cut_ the branch of the infected node to stop spreading the virus.


## Application Server

This code requires a _CFML_ engine. It has been successfully tested on [Adobe ColdFusion 2018](https://www.adobe.com/products/coldfusion-family.html "Adobe ColdFusion 2018")  but it is guaranteed that it will work on the Open Source [Lucee Server](https://lucee.org/ "Lucee Server") as well. The code can be easily translated to other languages too.

* Open Source [Lucee Server](https://lucee.org/ "Lucee Server")
* Commercially available [Adobe ColdFusion 2018](https://www.adobe.com/products/coldfusion-family.html "Adobe ColdFusion 2018")

### Installation
Create a new project under your CFML server. Place the files _controller.cfc_ and _model.cfc_ under your new application web root. The project is engineered on an MVC model, however since this is a simple API there is no any _View_ at the moment. Follow the Database Server installation instructions to set-up a new database and create a new datasource.

* _controller.cfc_

You don't really need to modify anything at the controller. In case you need to extend this application, it is recommended to always register all your new methods in there, of course. All available methods are self-explained either by naming convention or by the provided _hint_ arguments that CFML supports.

* model.cfc

Model contains a lot of inline useful comments. Typically, you will need to enter your project's new datasource at the constructor method, by replacing the existing _\_DATASOURCE\__ with your own one.

Next, go through the comments and change the Telephone Number validation at the designated points. You should change this either by setting your own regular expression or by using your own custom validation so that the telephone numbers of your own country are correctly validated and allowed. Finally, you will need to write your own SMS Gateway integration code at the _send\_sms\_code()_ method.

##  Database Server

The project has been designed and developed on Microsoft SQL Server but we cannot see any reason why this should not work on Oracle, MySQL or any other SQL server. Notice that in order to be able to handle massive data we have applied a spooling approach. All data are uploaded, stored in a spool table and then, a stored procedure will handle them in batches. We have stressed-tested this project for millions of records with no problems. Batch-processing avoids table locks, uncommitted transactions, waits or deadlocks. 

### Database Installation
You will need to create a new database on Microsoft SQL and then execute all .sql scripts which are provided within this repository. 

##### Tables

* tbl_user.sql
* tbl\_user\_log.sql
* tbl\_user\_log\_spool.sql

##### Stored Procedures

* sp\_cofight\_process\_spool.sql
* sp\_cofight\_clear\_history.sql

##### Scheduled Jobs
You should create two different scheduled jobs, to execute on a timely manner both _sp\_cofight\_process\_spool_ and _sp\_cofight\_clear\_history_ . Frequency depends on your resource availability.  


## Security Notes

* Access to the database should only be provided at the local authorities or authorized personnel. Server side code does not keep information such as personal details, medical records or any geo-location related entries. Nobody needs that. We only need the telephone number of the user that is contributing so that the authorities can warn him/her about a recent intersection with an infected citizen.
* Data is only kept on the client-side, unless of course the end-users decides to contribute and upload his/her data. Data stored on the client-side is meaningless, as it only includes a date/time paired with unique identifier.
* Server code handles well-known attacks such as SQL-injections, however it is strongly recommended to add the application behind a secured environment. In addition to that, since the entire system will be working nationally and not internationally, it is recommended to block access of non-local IPs at the server.