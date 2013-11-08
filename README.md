## Prerequisites

* [Ant-Contrib 1.0b2](http://ant-contrib.sourceforge.net/)
  You can just place `ant-contrib.jar` under `%USERPROFILE%\.ant\lib\`.

* [Force.com Migration Tool](http://www.salesforce.com/us/developer/docs/daas/Content/forcemigrationtool_install.htm)
  You can just place `ant-salesforce.jar` under `%USERPROFILE%\.ant\lib\`.

* [Force.com Data Loader](http://wiki.developerforce.com/page/Data_Loader)
  * [Download](https://na1.salesforce.com/dwnld/DataLoader/ApexDataLoader.exe)
  * [Source](https://github.com/forcedotcom/dataloader)
  * [Using from CLI](http://wiki.apexdevnet.com/page/Using_Data_Loader_from_the_command_line)

#### Optional:

* [Force.com IDE](http://wiki.developerforce.com/page/Force.com_IDE_Installation)
* [Salesforce Data Loader CLI quickstart 2.3.0 beta](http://code.google.com/p/dataloadercliq/)

## Setting the project

In the base directory of the project, create your own **build.properties** as
follow:

```INI
# build.properties
#

# Specify your Force.com DataLoader installation path
#dl.path = C:/Program Files (x86)/salesforce.com/Data Loader/dataloader-29.0.0-uber.jar

# Specify the login credentials for the desired Salesforce organization

sf.username = <Insert your Salesforce username here>
sf.password = <Insert your Salesforce concatenated password and token here>

# Use 'https://login.salesforce.com' for production or developer edition (the default if not specified).
# Use 'https://test.salesforce.com for sandbox.
sf.serverurl = https://login.salesforce.com

sf.maxPoll = 20
sf.pollWaitMillis = 10000

# If your network requires an HTTP proxy, see http://ant.apache.org/manual/proxy.html
# for details and use the following properties for configuration:
#proxy.host =
#proxy.port = 80
#proxy.user =
#proxy.pass =
```

## Installing to your organization
Just run the command `ant deploy`.

## Removing from your organization
1. Run the command `ant undeploy`.
2. From Salesforce `Setup > Build > Create > Custom Labels`, delete the custom
label `EmailToCaseThreadIdFormat`.
