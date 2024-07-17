Class util.Tasks.ImportFileIRIS Extends %SYS.Task.Definition
{

Parameter TaskName = "ImportFileIRIS";

Method OnTask() As %Status
{
    Set ftpSession = ##Class(%Net.FtpSession).%New()
    set sc = ..SessionFtp(.ftpSession)
    If 'sc {
        Do ftpSession.Logout()
        Quit sc
    }
    Set ftpPath = "/IMPORTEXPORT/SRVBIToMag/"_##Class(%Function).HostName()_"/"
    If 'ftpSession.SetDirectory(ftpPath) {
        Do ftpSession.MakeDirectory(ftpPath)
    }

    do ..RecuperationDesFichiers(ftpSession, ftpPath)
  
    Do ftpSession.Logout()
    Return sc
}

Method RecuperationDesFichiers(ftpSession As %Net.FtpSession, ftpPath As %String)
{
    Set sc = ftpSession.SetDirectory(ftpPath)
    Set sc = ftpSession.NameList("",.fileArray)

    Set key = ""
    For {
        Set nameFile = fileArray.GetNext(.key)
        Quit:(key="")
     
        Set filestream=##class(%Stream.FileBinary).%New()

        Set sc = ftpSession.Binary()
        Set sc = ftpSession.Retrieve(nameFile,filestream) 

        Do $SYSTEM.OBJ.LoadStream(filestream,"ck")

        Set sc = ftpSession.Delete(nameFile)
        //TODO: Prevoir 
    }
}

Method SessionFtp(ByRef ftpSession As %Net.FtpSession) As %Status
{
    Set ftpSession = ##class(%Net.FtpSession).%New() 
    Set ftpServer = "10.10.1.200"
    Set ftpPort = 21 
    Set ftpUsername  = "anonymous"
    Set ftpPassword = "flemelle@mondialtissus.com"
    Set sc = ftpSession.Connect(ftpServer, ftpUsername,ftpPassword, ftpPort)
    
    Return sc
}

}
