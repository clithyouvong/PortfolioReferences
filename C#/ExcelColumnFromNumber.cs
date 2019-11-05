  
/*
  The following is to be used for reference only. 
  
  The following implementation is not used in any implemenation for any company. 
  
  The following is written in C# 
  
  The following returns a string representing an Excel Column
*/

    /// <summary>
    /// 1 -> A<br/>
    /// 2 -> B<br/>
    /// 3 -> C<br/>
    /// ...
    /// </summary>
    /// <param name="column"></param>
    /// <returns></returns>
    public static string ExcelColumnFromNumber(int column)
    {
        string columnString = "";
        decimal columnNumber = column;
        while (columnNumber > 0)
        {
            decimal currentLetterNumber = (columnNumber - 1) % 26;
            char currentLetter = (char)(currentLetterNumber + 65);
            columnString = currentLetter + columnString;
            columnNumber = (columnNumber - (currentLetterNumber + 1)) / 26;
        }
        return columnString;
    }
