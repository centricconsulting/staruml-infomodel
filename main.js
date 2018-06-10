/*
 * Copyright (c) 2014 MKLab. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 */

/*jslint vars: true, plusplus: true, devel: true, nomen: true, indent: 4, maxerr: 50, browser: true */
/*global $, _, define, app, type, DOMParser */

define(function (require, exports, module) {

  "use strict";

  // #######################################################  
  // Specify Folders and Paths
  // #######################################################  
  
  var Commands = app.getModule("command/Commands"),
  	CommandManager = app.getModule("command/CommandManager"),
    ProjectManager = app.getModule("engine/ProjectManager"),
    MenuManager = app.getModule("menu/MenuManager"),
    Repository = app.getModule("core/Repository"),
    FileUtils = app.getModule("file/FileUtils"),
    FileSystem = app.getModule("filesystem/FileSystem"),
    Dialogs = app.getModule("dialogs/Dialogs"),
    ExtensionUtils = app.getModule("utils/ExtensionUtils"),
    NodeDomain = app.getModule("utils/NodeDomain"),
    Async = app.getModule("utils/Async");

	// create Node.js domain interface
	var InfoModelExportDomain = new NodeDomain("InfoModelExport", ExtensionUtils.getModulePath(module, "node/InfoModelExport"));
    
  // #######################################################  
  // Specify Folders and Paths
  // #######################################################
  
	// get module directory
	var ModuleDirectory = FileUtils.stripTrailingSlash(ExtensionUtils.getModulePath(module));
	
  // get xslt file
	var InfoModelXsltFilePath = ModuleDirectory + "/centric.infomodel.xslt";
  var InfoLibraryXsltFilePath = ModuleDirectory + "/transform.xslt";
	
	// get source resource directory
	var SourceResourcePath = ModuleDirectory + '/resources';
	
	// set target resource folder name
	var TargetResourceFolderName = 'resources';

	// set target resource folder name
	var TargetDiagramFolderName = 'diagrams';
	
	// diagram file prefix.  followed by diagram id
	var DiagramFilePrefix = 'diagram_';
	
	// specify process command  
	var ExecuteFolderName = "java";

	// specify process command  
	var XsltProcessExecutable = "java -jar com.centric.infomodel.jar";

  // #######################################################  
  // Export Logic
  // #######################################################
	
  function controlInfoModelExport(TargetFilePath) {

  	var result = new $.Deferred();
  	
  	// extract the TargetFolderPath from the file path
  	var TargetFolderPath = FileUtils.getDirectoryPath(TargetFilePath);
  	var TargetFileName = FileUtils.getBaseName(TargetFilePath);
  	
    // generate diagrams
    var TargetDiagramPath = TargetFolderPath + TargetDiagramFolderName;
    createFolder(TargetDiagramPath);
    generateDiagrams(TargetDiagramPath, DiagramFilePrefix);
    
  	// copy resources
    var TargetResourcePath = TargetFolderPath + TargetResourceFolderName;
    createFolder(TargetResourcePath);
    copyResources(SourceResourcePath, TargetResourcePath);
    
    // execute process
    var ProjectFilePath = ProjectManager.getFilename();
    var command = buildInfoModelCommand(ProjectFilePath, TargetFilePath, InfoModelXsltFilePath);
    
    // identify the target directory to execute the command
		var ExecuteDirectory = ModuleDirectory + "/" + ExecuteFolderName;
		executeProcess(command, ExecuteDirectory);
   
    return result.promise();
  }

  function controlInfoLibraryExport(TargetFilePath) {

    var result = new $.Deferred();
    
    // extract the TargetFolderPath from the file path
    var TargetFolderPath = FileUtils.getDirectoryPath(TargetFilePath);
    var TargetFileName = FileUtils.getBaseName(TargetFilePath);
    
    // execute process
    var ProjectFilePath = ProjectManager.getFilename();
    var command = buildInfoModelCommand(ProjectFilePath, TargetFilePath, InfoLibraryXsltFilePath);
    
    // identify the target directory to execute the command
    var ExecuteDirectory = ModuleDirectory + "/" + ExecuteFolderName;
    executeProcess(command, ExecuteDirectory);
   
    return result.promise();
  }

  
  // #######################################################  
  // Resource and Folder Management 
  // #######################################################
  
  /*
	* Creates a target folder to receive all resources including diagrams
	* @param {fullPath} Path of the current document, supplied by app.
  */
	function createFolder(path) {
    var result = new $.Deferred();
    console.log("createFolder::path = " + path);

		var directory = FileSystem.getDirectoryForPath(path);
	
		directory.create(function (err, stat)
		{	
			if (err && err !== "AlreadyExists") 
			{
				// error exists but the error is not "already exists"
				console.log("Directory could not be created: " + path);
				result.reject(err);
			}
			
		});

    return result.promise();
	}
	
	function copyResources(sourcePath, targetPath) {
		var result = new $.Deferred();
    console.log("copyResources::sourcePath = " + sourcePath);
    console.log("copyResources::targetPath = " + targetPath);
    
    var X = InfoModelExportDomain.exec("copyFolderRecursiveSync", sourcePath, targetPath);
    
    return result.promise();		
	}
	
// #######################################################  
  // Generate Diagrams
  // #######################################################
	
	function generateDiagrams(path, prefix) {
		var result = new $.Deferred();
    console.log("generateDiagrams::path = " + path);
    
		var diagrams = Repository.getInstancesOf("Diagram");
		
		if (diagrams && diagrams.length > 0) {
			
			// export diagrams to file path
			Async.doSequentially(				
				diagrams,
				function (diagram, idx) {
					
						var diagramFolderPath = path + "/" + FileUtils.convertToWindowsFilename(prefix + diagram._id + ".svg");
						console.log("generateDiagrams::diagramPath = " + diagramFolderPath);
						return CommandManager.execute("file.exportDiagramAs.svg", diagram, diagramFolderPath);
						
				}, false
				).then(result.resolve, result.reject); 			
			
			
		} else {
			result.reject("No diagram to export.");
		}    
    
    return result.promise();		
	}
	
  
  // #######################################################  
  // Execute External Process
  // #######################################################

  function buildInfoModelCommand(projectFilePath, targetFilePath, sourceXsltFilePath) {
    var command = XsltProcessExecutable + " "
  	+ "-p \"" + projectFilePath + "\" "
  	+ "-t \"" + targetFilePath + "\" "
  	+ "-x \"" + sourceXsltFilePath + "\" "
  	+ "-g";
  	
    console.log("buildInfoModelCommand::command = " + command);

  	return command;  	
  }
    

  function executeProcess(command, executeDirectory) {  	
		// execute
		console.log("executeProcess::command = " + command);
		console.log("executeProcess::executeDirectory = " + executeDirectory);
		
		var buffer = InfoModelExportDomain.exec("executeCommand", command, executeDirectory);  	  	
  }
	
  // #######################################################  
  // Menu Registration and Command
  // #######################################################
	
	/*
	* Handle to receive the menu command
	* @param {fullPath} Select target path and kick-off export.
	*/
  function _handleInfoModelExport(fullPath) {

    var result = new $.Deferred();

		if (Repository.isModified() || !ProjectManager.getFilename()) {
			// cancel operation if document not saved
			Dialogs.showInfoDialog("Save changes before exporting the Information Model HTML.").done(function () {
					result.reject(USER_CANCELED);
			});
			
    } else if (!fullPath) {    
        
    	// generate default target file name
			var DefaultTargetFilename = FileUtils.convertToWindowsFilename(ProjectManager.getProject().name + ".html");  	
			
      FileSystem.showSaveDialog("Export Information Model HTML", null, DefaultTargetFilename, function (err, selectedPath) {
      		
        if (!err) {
          controlInfoModelExport(selectedPath).then(result.resolve, result.reject);
        } else {
          result.reject(err);
        }
        
      });    	
    
    } else {    
      controlInfoModelExport(fullPath).then(result.resolve, result.reject);
    }

    return result.promise();
  }


  function _handleInfoLibraryExport(fullPath) {

    var result = new $.Deferred();

    if (Repository.isModified() || !ProjectManager.getFilename()) {
      // cancel operation if document not saved
      Dialogs.showInfoDialog("Save changes before exporting the Centric transform.").done(function () {
          result.reject(USER_CANCELED);
      });
      
    } else if (!fullPath) {    
        
      // generate default target file name
      var DefaultTargetFilename = FileUtils.convertToWindowsFilename(ProjectManager.getProject().name + ".txt");   
      
      FileSystem.showSaveDialog("Export Centric Transform...", null, DefaultTargetFilename, function (err, selectedPath) {
          
        if (!err) {
          controlInfoLibraryExport(selectedPath).then(result.resolve, result.reject);
        } else {
          result.reject(err);
        }
        
      });     
    
    } else {    
      controlInfoLibraryExport(fullPath).then(result.resolve, result.reject);
    }

    return result.promise();
  }

  
  var CMD_INFO_MODEL_EXPORT = 'com.centric.infomodel.html.export';
  var CMD_INFO_LIBRARY_EXPORT = 'com.centric.infolibrary.export'; 

  var USER_CANCELED = { userCanceled: true };
  
  // Register Commands
  //CommandManager.register("Information Model HTML...", CMD_INFO_MODEL_EXPORT, _handleInfoModelExport);
  CommandManager.register("Centric Transform...", CMD_INFO_LIBRARY_EXPORT, _handleInfoLibraryExport);

  // Setup Menus
  var menuItem = MenuManager.getMenuItem(Commands.FILE_EXPORT);
  menuItem.addMenuItem(CMD_INFO_MODEL_EXPORT);
  menuItem.addMenuItem(CMD_INFO_LIBRARY_EXPORT);

});
