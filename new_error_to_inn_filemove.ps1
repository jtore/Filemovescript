﻿# Made by Joakim Torsvik
#Check if error folder is empty before proceeding
        WriteLog -Logstring "[ERROR] : Error-folder is empty. Script will be terminated."
        Write-Host "[INFO] : Error-folder is empty. Script will be terminated."
# 20.09 Rewrote this function for a more complex folder-structure at HTU

        CheckFolderIsEmpty
 
        $ErrorFiles = Get-ChildItem -Path $Source -File

        $DestinationMappings = @{
            'xxx' = 'xxx_\w+'
            'xxx1' = 'xxx1_\w+'
            'xxx2' = 'xxx2_\w+'
            'xxx3' = 'xxx3_\w+'
        }


        foreach($File in $ErrorFiles) {

            $FileName = $File.BaseName
  
            foreach($Mapping in $DestinationMappings.GetEnumerator()){
                
                $DestinationPath = Join-Path -Path $Destination -ChildPath $Mapping.Key
            
                if($FileName -match $Mapping.Value){

                    try{
                        $File | Move-Item -Destination "$DestinationPath" -ErrorAction Stop
                        Write-Host "[INFO] : {$File} MOVED TO {$DestinationPath}"
                        WriteLog -LogString "[INFO] : {$File} MOVED TO {$DestinationPath}"
            
                    }
                    # If the file we are trying to move aleady exists in the destination, we catch the error here and log it.
                    catch{

                        $ErrorMessage = "[ERROR]: $_"
                        WriteLog -LogString $ErrorMessage
                        Write-Host $ErrorMessage
                
                        #Terminate script
                        Exit
                    }
                }
            }
   
        }

       MoveFiles
       
}

Function Main {

$Source=".\Error"
$Destination=".\xxx"
$LogFile = ".\file_move_log.txt"
#Check if source and destination folders exist before starting
if ((Test-Path -Path $Source -PathType Container) -And (Test-Path -Path $Destination -PathType Container)){
    WriteLog -LogString "[INFO] : Starting script: Moving files from error-folder..."
    WriteLog -LogString "[INFO] : Source folder {$Source} and Destination folder {$Destination} found. Proceeding..."      
    }

else{
    WriteLog -LogString "[INFO] : Folder {$Source} or {$Destination} does not exist. Script will be terminated"
    #Terminate script
    Exit
    }
}

Main