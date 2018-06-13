/*
 * Copyright (c) 2018 Centric Consulting, LLC. All rights reserved.
 * Jeff Kanel
 */


/* ###############################################################################
######################   REFERENCES   ############################################
############################################################################### */

const exec = require("child_process").exec

/* ###############################################################################
######################   GLOBAL VALUES   #########################################
############################################################################### */

const xsltFileName = "transform.xslt"
const processExecutable = "java -jar com.centric.infomodel.jar";

/* ##############################################################################
######################   EXPORT CENTRIC LIBRARY   ################################
############################################################################### */

// file filters
const CENTRIC_LIBRARY_FILE_FILTERS = [
  {name: "Text Files", extensions: ["txt"]},
  {name: "All Files", extensions: ["*"]}
]

// command hook
function _handleExportCentricLibrary (defaultFilePath)
{

    // test that the file is ready for export
    var jsonFilePath = app.project.getFilename()
    if(jsonFilePath == null || app.repository.isModified())
    {
      var buttonId = app.dialogs.showInfoDialog("Please save the project before exporting.")
      return
    }

    // set the default file name
    var _fileName = null
    if(defaultFilePath != null)
    {
      _fileName = defaultFilePath
    } else 
    {
      _fileName = app.project.getProject().name + ".txt"
    }

    // get the file path
    var targetFilePath = app.dialogs.showSaveDialog("Export Centric Library Transform", _fileName, CENTRIC_LIBRARY_FILE_FILTERS)

    // execute the transformation
    if(targetFilePath)
    {
      var command = buildCentricLibraryCommand(targetFilePath, jsonFilePath, xsltFileName)
      executeCommand(command);
    }
}

// build command
function buildCentricLibraryCommand (targetFilePath, jsonFilePath, xsltFileName)
{
    var command = processExecutable + " "
    + "-p \"" + normalizePath(jsonFilePath) + "\" "
    + "-x \"" + buildFilePath(__dirname, xsltFileName) + "\" "
    + "-t \"" + normalizePath(targetFilePath) + "\""
        
    return command
}

/* ###############################################################################
######################   EXPORT CENTRIC XML   ####################################
############################################################################### */

// file filters
const CENTRIC_XML_FILE_FILTERS = [
  {name: "Xml Files", extensions: ["xml"]},
  {name: "All Files", extensions: ["*"]}
]

// command hook
function _handleExportCentricXml (defaultFilePath) 
{
    // test that the file is ready for export
    var jsonFilePath = app.project.getFilename()
    if(jsonFilePath == null || app.repository.isModified())
    {
      var buttonId = app.dialogs.showInfoDialog("Please save the project before exporting.")
      return
    }

    // set the default file name
    var _fileName = null
    if(defaultFilePath != null)
    {
      _fileName = defaultFilePath
    } else 
    {
      _fileName = app.project.getProject().name + ".xml"
    }

    // get the file path
    var targetFilePath = app.dialogs.showSaveDialog("Export Centric Library Xml", _fileName, CENTRIC_XML_FILE_FILTERS)

    // execute the transformation
    if(targetFilePath)
    {
      var command = buildCentricXmlCommand(targetFilePath, jsonFilePath, xsltFileName)
      executeCommand(command);
    }
}

// build command
function buildCentricXmlCommand (targetFilePath, jsonFilePath, xsltFileName)
{
  var command = processExecutable + " "
  + "-p \"" + normalizePath(jsonFilePath) + "\" "
  + "-x \"" + buildFilePath(__dirname, xsltFileName) + "\" "
  + "-m \"" + normalizePath(targetFilePath) + "\""
      
  return command
}

/* ###############################################################################
######################   SUPPORT FUNCTIONS   #####################################
############################################################################### */

function buildFilePath (directory, filename)
{
    return normalizePath(directory) + "/" + filename  
}

function normalizePath (path)
{
  // perform a global replace
  var newPath = path.replace(/\\/g,"/")
  
  if(newPath.endsWith("/"))
  {
    return newPath.substring(0,newPath.length()-2)
  }
  else
  {
    return newPath
  }
}

function executeCommand(command)
{

  var args = {cwd: __dirname}

  var child = exec(command,args,function (error, stdout, stderr)
  {
    if (error !== null)
    {
      console.log("Command execute failed: " + stderr)
      var buttonId = app.dialogs.showErrorDialog("Centric Library Export encountered an error:\r\n\r\n" + stderr)
      throw error
      return stderr
    }
    else
    {
      console.log("Successfully executed command:\r\n" + command)
      return stdout
    }
  })
}

/* ###############################################################################
######################   INITIALIZATION   ########################################
############################################################################### */

function init ()
{
    app.commands.register("centriclibrary:export", _handleExportCentricLibrary)
    app.commands.register("centricxml:export", _handleExportCentricXml)
}

exports.init = init