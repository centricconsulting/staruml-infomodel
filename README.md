# staruml-infomodel
StarUML Extension. Generates a Centric Information Model XML and HTML file from a StarUML project (mdj) file. Validated for StarUML version 2.1.1.  Java source project is http://github.com/jkanel/staruml-infomodel-java.

## Extension Use
1. From within StarUML, select the menu ```File >> Export >> Information Model Html...```
2. Enter a target Html filename.  It is recommended that target folder be dedicated for this purpose.
3. The extension will automatically generate the following:
    1. Target Html file.
    2. Xml file having the same name as the Html file.
    3. Resources folder containing CSS, java script and graphics files.
    4. Diagrams folder containing SVG diagrams from your StarUML project.
4. Open the Html file in any browser.
5. The Xml file may be used as a data source for MS Word or other document merge technologies.

**NOTE: Compatible with Java Runtime Environment 1.6.0.45 (Oracle 6u45).**

## Extension Installation Options
### #1 - StarUML Extension Manager
1. Open the StarUML application.
2. Select the menu ```Tools >> Extension Manager...```
3. Click the ```Install From Url``` button.
4. In the ```Install Extension``` field, enter ```http://github.com/jkanel/staruml-infomodel/archive/master.zip``` and click the ```Install``` button.
5. The extension will automatically install.

### #2 - Manual Windows Installation
1. Open Windows Explorer and navigate to ```C:\Users\{user}\AppData\Roaming\StarUML\extensions\user``` where ```{user}``` is your windows login user name.
2. Download the file http://github.com/jkanel/staruml-infomodel/archive/master.zip to your local drive.
3. Open the zip archive and extract the ```staruml-infomodel-master``` folder to the ```\extensions\user``` folder (see #1, above).
4. The extension is now installed.

## Customization
The following methods of customization are supported.

**NOTE**: All customizations should be made in the StarUML Extensions folder.  On Windows machines, this folder is located here:
     ```"C:\Users\\{user}\AppData\Roaming\StarUML\extensions\user\com.centric.infomodel.html"```
The placeholder {user} should be replaced with your Windows account name.

1. **Xslt File**. You can alter the Xslt file ```centric.infomodel.xslt``` located located in the StarUML Extensions folder.  This file controls the generation of Html based on Xml derived from the StarUML project.
2. **CSS Style Sheet**. You can alter the CSS style sheet file ```centric.infomodel.css``` located in the StarUML Extensions resources subfolder.  This controls the colors, layout and rendering of the Html page.
3. **Company Logo**. The company logo appearing in the top-left corner of the Html page can be altered by replacing the ```logo.png``` file located in the StarUML Extensions resources subfolder. 
4. **StarUML Menu Behavior**.  The StarUML menu behavior can be altered in the ```main.js``` file located in the StarUML Extensions folder.  For each extension, the respective "main.js" file is loaded into StarUML memory on startup.

