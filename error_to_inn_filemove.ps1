﻿# Made by Joakim Torsvik
#Check if error folder is empty
        WriteLog -Logstring "ERROR : Error-folder is empty. Script will be terminated."
        Write-Host "ERROR : Error-folder is empty. Script will be terminated."

        CheckFolderIsEmpty
 
        $ErrorFiles = Get-ChildItem -Path $Source -File

        foreach($File in $ErrorFiles) {

            #Grab the first part of the filname which corresponds to the folders we are moving the files  (e.g "11001_500" from the file "11001_500_TVUUASDASD.xml")
            $FolderName= [Regex]::Match($File.BaseName, '^\d+_\d+').ToString()

            $MoveDestination = "$Destination\$FolderName"
            
            try{
                #Moves the files
                $File | Move-Item -Destination "$MoveDestination" -ErrorAction Stop
                Write-Host "INFO : {$File} MOVED TO {$MoveDestination}"
                WriteLog -LogString "INFO : {$File} MOVED TO {$MoveDestination}"
            
            }
            # If the file we are trying to move aleady exists in the destination, we catch the error here and log it.
            catch{

                $ErrorMessage = "ERROR: $_"
                WriteLog -LogString $ErrorMessage
                Write-Host $ErrorMessage
                
                #Terminate script
                Exit
            }
   
        }

       MoveFiles
       
}

Function Main {

$Source=".\Error"
$Destination=".\Inn"
$LogFile = ".\file_move_log.txt"
#Check if source and destination folders exist before starting
if ((Test-Path -Path $Source -PathType Container) -And (Test-Path -Path $Destination -PathType Container)){
    WriteLog -LogString "INFO : Starting script: Moving files from error-folder to inn-folder..."
    WriteLog -LogString "INFO : Source folder {$Source} and Destination folder {$Destination} found. Proceeding..."      
    }

else{
    WriteLog -LogString "INFO : Folder {$Source} or {$Destination} does not exist. Script will be terminated"
    Exit
    }
}

Main