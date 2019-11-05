BEGIN TRY  
    Begin Transaction SaveChanges;
    
    /* Do Work */

    Commit Transaction SaveChanges; 
END TRY  
BEGIN CATCH  
    Declare @SaveChangesWarning nvarchar(max) = 
    (
      SELECT  'Error has occurred during this transaction. Please contact Support at support@domain.com or by phone at (800) 000 - 0000. Error: ' +  
              'ERROR_NUMBER:' + convert(nvarchar, ERROR_NUMBER()) + '; ' +   
              'ERROR_SEVERITY:' + convert(nvarchar, ERROR_SEVERITY()) + '; '  + 
              'ERROR_STATE:' + convert(nvarchar, ERROR_STATE()) + '; ' +  
              'ERROR_PROCEDURE:' + convert(nvarchar, ERROR_PROCEDURE()) + '; ' + 
              'ERROR_LINE:' + convert(nvarchar, ERROR_LINE()) + '; ' +   
              'ERROR_MESSAGE:' + convert(nvarchar, ERROR_MESSAGE())  
    );
            
    /* Process work */

    IF ( @@TRANCOUNT > 0 )
    Begin
      Rollback Transaction SaveChanges;
    End 

    RAISERROR (@SaveChangesWarning , 16, 1);                                                              

    Return;
END CATCH
