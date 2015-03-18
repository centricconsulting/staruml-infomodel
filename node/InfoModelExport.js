/*
 * Copyright (c) 2012 Adobe Systems Incorporated. All rights reserved.
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

/*jslint vars: true, plusplus: true, devel: true, nomen: true, indent: 4,
maxerr: 50, node: true */
/*global */

(function () 
{
    "use strict";

    var exec = require("child_process").exec;
    var path = require("path");
    var fs = require("fs");
        
		function copyFileSync( sourceFilePath, targetFilePath )
		{
				
				var targetFilePathFinal = targetFilePath;
		
				//if target is a directory a new file with the same name will be created
				if ( fs.existsSync( targetFilePath ) ) {
						if ( fs.lstatSync( targetFilePath ).isDirectory() ) {
								targetFilePathFinal = path.join( targetFilePath, path.basename( sourceFilePath ) );
						}
				}
		
				fs.createReadStream( sourceFilePath ).pipe( fs.createWriteStream( targetFilePathFinal ) );
				
		}
		
		function copyFolderRecursiveSync( sourceFolderPath, targetFolderPath )
		{
			
			var files = [];
			
			console.log("copyFRS::sourceFolderPath = " + sourceFolderPath);
			console.log("copyFRS::targetFolderPath = " + targetFolderPath);
			
			//copy only if the source is a directory
			if ( fs.lstatSync( sourceFolderPath ).isDirectory() ) 
			{
			
				files = fs.readdirSync( sourceFolderPath );
				
				
				files.forEach( function ( file ) 
        {
				
					console.log("copyFRS::file = " + file);

					var currentSourceFilePath = path.join( sourceFolderPath, file );
					
					console.log("copyFRS::currentSourceFilePath = " + currentSourceFilePath);
					

					if ( fs.lstatSync( currentSourceFilePath ).isDirectory() )
					{
					// child directory processing
						
						//check if folder needs to be created or integrated
						var childTargetFolderPath = path.join( targetFolderPath, file );									
						
						console.log("copyFRS::childTargetFolderPath = " + childTargetFolderPath);
						
						if ( !fs.existsSync( childTargetFolderPath ) )
						{
								fs.mkdirSync( childTargetFolderPath );
						}
						
						copyFolderRecursiveSync( currentSourceFilePath, childTargetFolderPath );
					
					} else {
					// file processing
						console.log("copyFRS::prepare to copy");
						copyFileSync( currentSourceFilePath, targetFolderPath );	
						
					} // end if(child isDirectory)
					
				
				}); // end files.forEach
						
			} // end if(source isDirectory)
			
			
		} // end function
		
		/**
     * Executes a command on the child process.
     * @param {cmd} Command to be executed.
     */
    function executeCommand(cmd,wkdir) 
    {

			var normalizedPath = wkdir; //path.Win32.normalize(wkdir);
			console.log("Working Directory: " + normalizedPath);
    
    	var args = {
    		cwd: normalizedPath	
	    }
		  
	    var child = exec(cmd, args, function (error, stdout, stderr) 
	    {
	    	      
				if (error !== null) 
				{
					console.log('Command execute failed: ' + stderr);
					throw error;
					return stderr;		      
				}
				else
				{
					console.log('Successfully executed command.' + cmd);					
					return stdout;							
				}
		    
			}); // end exec   	        	    
		} // end function
    
		function init(InfoModelExportDomain)
		{
        
    	if (!InfoModelExportDomain.hasDomain("InfoModelExport")) 
    	{
    		InfoModelExportDomain.registerDomain("InfoModelExport", {major: 0, minor: 1});
      }
				
			InfoModelExportDomain.registerCommand(
				"InfoModelExport", // domain name
				"executeCommand",     // command name
				executeCommand,       // command handler function
				false,           // this command is synchronous in Node
				"Executes a command on the child process.",
				[
						{
								name: "cmd", // parameters
								type: "string",
								description: "Command to execute."
						},
						{
								name: "wkdir", // parameters
								type: "string",
								description: "Working directory"
						}
				],
				[
						{
								name: "result", // return values
								type: "Buffer",
								description: "Buffer (stdout, stderr) result from the executed command."
						}
				]
			);
			
			// copyFileSync(sourceFilePath, targetFilePath)
			InfoModelExportDomain.registerCommand(
				"InfoModelExport", // domain name
				"copyFileSync",     // command name
				copyFileSync,       // command handler function
				false,           // this command is synchronous in Node
				"Copies files on the file system.",
				[
						{
								name: "sourceFilePath", // parameters
								type: "string",
								description: "Source file path."
						},
						{
								name: "targetFilePath", // parameters
								type: "string",
								description: "Target file path."
						}
				],
				[
						{
								name: "result", // return values
								type: "string",
								description: "Returns 'Success' if the file was copied successfully."
						}
				]
			);    
			
			
			InfoModelExportDomain.registerCommand(
				"InfoModelExport", // domain name
				"copyFolderRecursiveSync",     // command name
				copyFolderRecursiveSync,       // command handler function
				false,           // this command is synchronous in Node
				"Normalizes a path for the operating system.",
				[
						{
								name: "sourceFolderPath", // parameters
								type: "string",
								description: "Source folder path."
						},
						{
								name: "targetFolderPath", // parameters
								type: "string",
								description: "Target folder path."
						}
				],
				[
						{
								name: "result", // return values
								type: "string",
								description: "Returns 'Success' if the file was copied successfully."
						}
				]
			);   
        
    } // end function    

    exports.init = init;

}());