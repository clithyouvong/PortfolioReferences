/*
  The following is to be used for reference only. 
  
  The following implementation is not used in any implemenation for any company. 
  
  The following is written in C# 
  
  The following returns an int representing an Excel Column
*/

    /// <summary>
    /// A -> 1<br/>
    /// B -> 2<br/>
    /// C -> 3<br/>
    /// ...
    /// </summary>
    /// <param name="column"></param>
    /// <returns></returns>
    public static int NumberFromExcelColumn(string column)
    {
        int retVal = 0;
        string col = column.ToUpper();
        for (int iChar = col.Length - 1; iChar >= 0; iChar--)
        {
            char colPiece = col[iChar];
            int colNum = colPiece - 64;
            retVal = retVal + colNum * (int)Math.Pow(26, col.Length - (iChar + 1));
        }
        return retVal;
    }
