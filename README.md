## Prerequisites

This project is based on Apache Ant 1.7 and Apache Ivy 2.3.
The dependency to Apache Ivy is standalone meaning that Apache Ivy will be
automatically installed under `.ivy2` under your user home folder
(i.e. `~/.ivy2/` on *nix or `%USERPROFILE%\.ivy2\` on Windows).

### Maven dependencies

The Apache Ivy based dependencies are actually Apache Maven artifacts.

#### Not publicly available: (See the [Notes](#notes) section)

* [Force.com Migration Tool](http://www.salesforce.com/us/developer/docs/daas/Content/forcemigrationtool_install.htm)
  * **Coordinates:**
    - **Ant-Salesforce:** `com.salesforce:ant-salesforce:24.0.0`

  * **Note:** You just need to download the `ant-salesforce.jar`, rename and
    place it at the right location in the defined Maven repository.

* [Force.com Data Loader 29.0.0](http://wiki.developerforce.com/page/Data_Loader)
  * **Coordinates:**
    - **Dataloader:** `com.force:dataloader:29.0.0`

  * **Note:** That JAR needs to be compiled from the sources available on
    GitHub and despite it requires the below Eclipse artifacts, it is much 
    smaller than the downloadable "uber" version that includes unnecessary
    3rd-party dependencies.  
    Then deploy it to the defined Maven repository.

  * **Details:**
    - [Sources on GitHub](https://github.com/forcedotcom/dataloader)
    - [Download the "uber" version](https://na1.salesforce.com/dwnld/DataLoader/ApexDataLoader.exe)
    - [Using from CLI](http://wiki.apexdevnet.com/page/Using_Data_Loader_from_the_command_line)

* [Eclipse dependencies](https://github.com/forcedotcom/dataloader/tree/29.0.0/local-proj-repo/org/eclipse)
  * **Coordinates:**
    - **Core Commands:** `org.eclipse:core.commands:3.6.1.v20120521-2329`
    - **Equinox Common:** `org.eclipse:equinox.common:3.6.100.v20120522-1841`
    - **JFace:** `org.eclipse:jface:3.8.0.v20120521-2329`

  * **Note:** You just need to download those JARs and place them at the right
    location in the defined Maven repository.  
    You may also find them [here](https://swt-repo.googlecode.com/svn/repo/)
    but with different coordinates.

#### Publicly available:

* [Ant-Contrib 1.0b3](http://ant-contrib.sourceforge.net/)
  * **Coordinates:**
    - **Ant-Contrib:** `ant-contrib:ant-contrib:1.0b3`

* [Force.com Partner WSC](https://github.com/forcedotcom/wsc)
  * **Coordinates:**
    - **Partner API:** `com.force.api:force-partner-api:29.0.0`
    - **WSC:** `com.force.api:force-wsc:29.0.0`

### Optional

* [Force.com IDE](http://wiki.developerforce.com/page/Force.com_IDE_Installation)
* [Salesforce Data Loader CLI quickstart 2.3.0 beta](http://code.google.com/p/dataloadercliq/)

## Setting the project

In the base directory of the project, create your own **build.properties** as
follow:

```INI
# build.properties
#

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

> ### <a name="notes"/>Notes:
> You may need to either download or compile non publicly available JARs
> and place or deploy them to an accessible Maven repository at the right
> location based on their coordinates and that is referenced in your
> `~/.ivy2/ivysettings.xml` or `%USERPROFILE%\.ivy2\ivysettings.xml`.
> 
> #### Example of 'ivysettings.xml'
>
> ```XML
> <?xml version="1.0" encoding="UTF-8"?>
> <ivysettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
>              xsi:noNamespaceSchemaLocation="http://svn.apache.org/repos/asf/openmeetings/tags/2.1RC3> /ivysettings.xsd">
>   <settings defaultResolver="myResolver" />
>   <resolvers>
>     <chain name="myResolver">
>       <ibiblio name="sharedMavenRepo" 
>               m2compatible="true" 
>               root="http://host.domain.tld/shared-maven/repo" />
>       <url name="mavencentral">
>         <artifact pattern="http://repo1.maven.org/maven2/[organisation]/[artifact]-[revision].[ext]" />
>       </url>
>    </chain>
>  </resolvers>
> </ivysettings>
> ```
