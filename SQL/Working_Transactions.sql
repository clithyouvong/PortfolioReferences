/*
  This code is a working file used for everyday references.
  
  This code demonstrates how to create Transactions inside SQL and output an error that would be useful for developers.
  
  The following code demonstrates SQL interpretations used in SQL Azure 2016.
  
  This is not a copy of any current implementation of any company.
*/
Set XACT_ABORT ON;

Begin Transaction;
BEGIN TRY  
    
    /* Do Work */

    Commit Transaction; 
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
      Rollback Transaction;
			Throw 51000, @SaveChangesWarning, 1; 
    End 
                                      
    Return;
END CATCH
