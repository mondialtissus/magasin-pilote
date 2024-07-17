Class util.Tasks.ExportMAGGUMVTByFTPToSrvbi Extends %SYS.Task.Definition
{

Parameter TaskName = "ExportMAGGUMVTByFTPToSrvbi";

Parameter LastDateDefaut = 20230101;

Parameter tmpPath = "c:\temp\";

/// Description
Method OnTask() As %Status
{
    Set sc = $$$OK
    Set sc = ..CreationGlobal()
    Set ftpSession = ##Class(%Net.FtpSession).%New()
    Set sc = ..SessionFtp(.ftpSession)
    If 'sc {
        Do ftpSession.Logout()
        Quit sc
    }
    Set ftpPath = "/OBJ/"_##Class(%Function).HostName()_"/"

    If 'ftpSession.SetDirectory(ftpPath) {
        Do ftpSession.MakeDirectory(ftpPath)
    } 

    Set file=$ZSEARCH("c:/temp/*.xml") 
    For {
        Set file=$ZSEARCH("")
        Quit:file=""
        Set filestream = ##class(%Stream.FileBinary).%New()
        Do filestream.LinkToFile(file)
        set tmpPath = ftpPath_$Extract(file,$Length("c:/temp/")+1,$Length(file))
        Set sc=ftpSession.Store(tmpPath,filestream)
        if sc {
            do ##Class(%File).Delete(file)
        }
        Do filestream.%Delete()
    }
    Do ftpSession.Logout()
    Return sc
}

Method CreationGlobal() As %Status
{
    Set sc = $$$OK

    Set DateDujour  = +$HOROLOG-1

    Set ^DateExportGUMVT  = $GET(^DateExportGUMVT, "")
    if ^DateExportGUMVT="" {
        Set ^DateExportGUMVT = $zdh(..#LastDateDefaut,8)
        Set ^DateExportGUMVT(^DateExportGUMVT )=1
    }


    For DateEnCour=^DateExportGUMVT:1:DateDujour {
        Set sc = ##class(map.MAGGUMVT).CreateSubGlobalByDate(DateEnCour)
        Set ^DateExportGUMVT($INCREMENT(^DateExportGUMVT))=sc
        Set ^DateExportGUMVT(^DateExportGUMVT,"GlobalExport")=""
    }
    Return sc
}

/// Connexion au serveur FTP
Method SessionFtp(ByRef ftpSession As %Net.FtpSession) As %Status
{
    Set ftpSession = ##class(%Net.FtpSession).%New() 
    Set ftpServer = "10.10.1.200"
    Set ftpPort = 21 
    Set ftpUsername  = "anonymous"
    Set ftpPassword = "flemelle@mondialtissus.com"
    Set ftpPath = "/OBJ/ALL/"
    Set sc = ftpSession.Connect(ftpServer, ftpUsername,ftpPassword, ftpPort)
    
    Return sc
}

}
