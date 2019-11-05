/*
  The following is to be used for reference only. 
  
  The following implementation is not used in any implemenation for any company. 
  
  The following is written in C# and requires the EPPLUS library here: 
  https://www.nuget.org/packages/EPPlus/ 
  
  The following shows how to interpret a DBContext and transform it into an Excel Spreadsheet using HTTPContext.
*/


//-----------------------------------------------
// SECTION: EXCEL FUNCTIONS
//-----------------------------------------------
/// <summary>
///     attempts to take the datatable and export it to a freestanding-dynamically generated Excel spreadsheet
/// </summary>
/// <param name="tbl">Datatable</param>
/// <param name="packageWorkbookComments">The package's comments for Excel Internal</param>
/// <param name="filenameStarting">The pre-text for the filename being outputed</param>
public static void DumpExcel(DataTable tbl, string packageWorkbookComments, string filenameStarting)
{
    try
    {
        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("Export");
            pck.Workbook.Properties.Title = "Excel Export";
            pck.Workbook.Properties.Author = "someauthor";
            pck.Workbook.Properties.Comments = packageWorkbookComments;
            pck.Workbook.Properties.Company = "somecompany";

            //Load the datatable into the sheet, starting from cell A1. Print the column names on row 1
            ws.Cells["A1"].LoadFromDataTable(tbl, true);


            //Format the header 
            string sheetRange = Utils.ExcelColumnFromNumber(tbl.Columns.Count);
            using (ExcelRange rng = ws.Cells[String.Format("A1:{0}1", sheetRange)])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }

            //Format the specific collumns
            ws.Cells[String.Format("A1:{0}100", sheetRange)].AutoFitColumns();

            //Prep data for Header Export
            byte[] fileBytes = pck.GetAsByteArray();

            //Filename
            string fileName = filenameStarting + DateTime.Now.ToString("ddMMMyy_HHmmss") + ".xlsx";

            //Content Disposition
            string headervalue =
                String.Format(
                    "attachment; filename={0}; size={1}; creation-date={2}; modification-date={2}; read-date={2}",
                    fileName,
                    fileBytes.Length,
                    DateTime.Now.ToString("R").Replace(",", ""));


            //Clear Response
            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.ClearContent();
            HttpContext.Current.Response.ClearHeaders();
            HttpContext.Current.Response.Cookies.Clear();

            //Add the header & other information
            HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.Private);
            HttpContext.Current.Response.CacheControl = "private";
            HttpContext.Current.Response.Charset = UTF8Encoding.UTF8.WebName;
            HttpContext.Current.Response.ContentEncoding = UTF8Encoding.UTF8;
            HttpContext.Current.Response.AppendHeader("Content-Length", fileBytes.Length.ToString());
            HttpContext.Current.Response.AppendHeader("Pragma", "cache");
            HttpContext.Current.Response.AppendHeader("Expires", "60");
            HttpContext.Current.Response.AppendHeader("Content-Disposition", headervalue);
            HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.sampleDemo.sheet";

            //Write it back to the client
            HttpContext.Current.Response.BinaryWrite(fileBytes);
            HttpContext.Current.Response.End();
        }
    }

    catch (Exception ex)
    {
        // ReSharper disable once ReturnValueOfPureMethodIsNotUsed
        ex.ToString();
    }
  }
