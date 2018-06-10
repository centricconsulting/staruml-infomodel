# staruml-infomodel
StarUML Extension. Generates a Centric Information Model XML and HTML file from a StarUML project (mdj) file. Validated for StarUML version 2.1.1.  Java source project is http://github.com/jkanel/staruml-infomodel-java.

## Extension Use
1. From within StarUML, select the menu ```File >> Export >> Centric Information Library...```
2. Enter a target filename.
3. The extension will automatically generate the following:
    1. Xml file having the same name as the specified file, but with an ```.xml``` file type.
    2. Target file transformed from the Xml using a file called transform.xslt, located in the StarUML extension folder.
4. The Xml file may be used as a data source for Xslt transformations, document merge, etc.

**NOTE: Compatible with Java Runtime Environment 1.6.0.45 (Oracle 6u45).**

## Extension Installation Options
### #1 - StarUML Extension Manager
1. Install Java 1.6 or higher. http://www.oracle.com/technetwork/java/javase/downloads/index.html
2. Windows Users:
    * Ensure that the System Environment variable, ```JAVA_HOME```, is set to the Java installation root folder.
    * Ensure that the System Environment variable, ```Path```, includes the ```%JAVA_HOME%\bin```.  This will allow the java.exe to run from any path.
3. Open the StarUML application.
4. Select the menu ```Tools >> Extension Manager...```
5. Click the ```Install From Url...``` button.
6. In the ```Install Extension``` field, enter ```http://github.com/jkanel/staruml-infomodel/archive/master.zip``` and click the ```Install``` button.
7. The extension will automatically install.

### #2 - Manual Windows Installation
1. Install Java 1.6 or higher. http://www.oracle.com/technetwork/java/javase/downloads/index.html
2. Windows Users:
    * Ensure that the System Environment variable, ```JAVA_HOME```, is set to the Java installation root folder.
    * Ensure that the System Environment variable, ```Path```, includes the ```%JAVA_HOME%\bin```.  This will allow the java.exe to run from any path.
3. Open Windows Explorer and navigate to ```C:\Users\{user}\AppData\Roaming\StarUML\extensions\user``` where ```{user}``` is your windows login user name.
4. Download the file http://github.com/jkanel/staruml-infomodel/archive/master.zip to your local drive.
5. Open the zip archive and extract the ```staruml-infomodel-master``` folder to the ```\extensions\user``` folder (see #1, above).
6. The extension is now installed.

## Customization
The following methods of customization are supported.

**NOTE**: All customizations should be made in the StarUML Extensions folder.  On Windows machines, this folder is located here:
     ```"C:\Users\{user}\AppData\Roaming\StarUML\extensions\user\com.centric.infomodel"```
The placeholder {user} should be replaced with your Windows account name.

1. **Xslt File**. You can alter the Xslt file ```transform.xslt``` located located in the StarUML Extensions folder.  This file controls the generation of Html based on Xml derived from the StarUML project.

