# staruml-infomodel
StarUML Extension. Generates a Centric Information Model XML and HTML file from a StarUML project (mdj) file. Validated for StarUML version 2.1.1.  Java source project is http://github.com/jkanel/star-infomodel-java.

## Extension Use
1. From within StarUML, select the menu File >> Export >> Information Model Html...
2. Enter a target Html filename.  It is recommended that target folder be dedicated for this purpose.
3. The extension will automatically generate the following:
    1. Target Html file.
    2. Xml file having the same name as the Html file.
    3. Resources folder containing CSS, java script and graphics files.
    4. Diagrams folder containing SVG diagrams from your StarUML project.
4. Open the Html file in any browser.
5. The Xml file may be used as a data source for MS Word or other document merge technologies.

## Installation Options
### #1 - StarUML Extension Manager
1. Open the StarUML application.
2. Select the menu Tools >> Extension Manager...
3. Click the "Install From Url" button.
4. In the "Install Extension" field, enter "http://github.com/jkanel/staruml-infomodel/archive/master.zip" and click the "Install" button.
5. The extension will automatically install.

### #2 - Manual Windows Installation
1. Open Windows Explorer and navigate to "C:\Users\\{user}\AppData\Roaming\StarUML\extensions\user" where {user} is your windows login user name.
2. Download the file http://github.com/jkanel/staruml-infomodel/archive/master.zip to your local drive.
3. Open the zip archive and extract the "staruml-infomodel-master" folder to the "user" folder (see #1, above).
4. The extension is now installed.

## Customization
The following methods of customization are supported.

1. **Xslt File**. You can alter the Xslt file located in your extensions folder "C:\Users\\{user}\AppData\Roaming\StarUML\extensions\user\star-infomodel" to produce new Html transformations.
2. **Resource Folder Contents**.  The "resoures" folder and its contents are copied in their entirety to the target Html folder.  These may be referenced by Xslt and the subsequent Html file. The "resources" folder is located in the extension folder.
