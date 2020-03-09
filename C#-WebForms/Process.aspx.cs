using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using OfficeOpenXml;
using OfficeOpenXml.Style;

public partial class Process : Page
{
    private SqlConnection _cn = new SqlConnection(ConfigurationManager.AppSettings["SqlCon"]);
    private SqlConnection _cn2 = new SqlConnection(ConfigurationManager.ConnectionStrings["AzureSqlDB"].ConnectionString);
    private DataSet _ds;
    private I _I;

    //An absolute list of alphabetic characters
    //  - used to enumerate over a collection and assign values within excel
    //  - also used to find a next/previous child in the list
    private static List<char> _alphabetList = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".ToCharArray().ToList(); 

    //An absolute list of months
    //  - used to display out a particular month
    //      based on SP structure of 1 - 12
    private string[] _months = {
        "January","February","March","April","May",
        "June","July","August","September","October",
        "November","December"
    };

    //Reference Collection
    //  - designed for AJAX JSON support
    //  - For Class use (DUMP Excel)
    private int _year, _month;


    protected void Page_Load(object sender, EventArgs e)
    {
        // AJAX Redirect
        //      Values here are required in order to perform updates / inserts into the DB
        if (Request.QueryString["g"] != null)
        {
            Guid gTemp;
            if (!Guid.TryParse(Request.QueryString["g"], out gTemp))
                return;

            if (!Int32.TryParse(Request.QueryString["y"], out _year))
                return;

            if (!Int32.TryParse(Request.QueryString["m"], out _month))
                return;

            
            try
            {   
                _I = I.GetI(gTemp);
                _ds = new DataSet();

                _cn2.Open();
                using (SqlCommand cm = new SqlCommand("DumpData", _cn2))
                {
                    cm.CommandType = CommandType.StoredProcedure;
                    cm.Parameters.AddWithValue("@DUMPDATA_YEAR", _year);
                    cm.Parameters.AddWithValue("@DUMPDATA_MONTH", _month);
                    cm.Parameters.AddWithValue("@IGuid", gTemp);
                    using (SqlDataAdapter da = new SqlDataAdapter(cm))
                    {
                        da.Fill(_ds);
                    }
                }
                _cn2.Close();

                DumpExcel(_ds.Tables[0]);
            }
            catch (Exception exception)
            {
                Response.Write(exception.Message + " " + exception.StackTrace);
            }
            
            if (_cn2.State == ConnectionState.Open) _cn2.Close();
        }
    }


    /// <summary>
    ///     attempts to take the datatable and export it to a freestanding-dynamically generated Excel spreadsheet
    /// </summary>
    /// <param name="tbl">Datatable</param>
    private void DumpExcel(DataTable tbl)
    {
        try
        {
            using (ExcelPackage pck = new ExcelPackage())
            {
                //  Multiple months selected, Year Selected
                //  If the user selects a year i.e. 2015
                //      We will perform a linq query to find all entries enumerating over that month and will bring back that information
                //      Then create a Worksheet for each of those months and add it to the workbook collection
                if (_month == 0)
                {
                    var linq = _ds.Tables[0].AsEnumerable().Select(x => x.Field<int>("Month")).Distinct();

                    foreach (int i in linq)
                    {
                        var linqDt = _ds.Tables[0].AsEnumerable()
                            .Where(x => x.Field<int>("Month") == i)
                            .CopyToDataTable();

                        var linqBf = _ds.Tables[1].AsEnumerable()
                            .Where(x => x.Field<int>("Month") == i)
                            .CopyToDataTable();

                        DumpExcelSheet(pck.Workbook.Worksheets.Add(_months[i - 1]), linqDt, linqBf, i);
                    }
                }
                //  One Month selected, Month Selected
                //  If the user selects a specific month i.e. January of 2015
                //      We will then perform a standard dump excel where all information is returned. 
                else
                {
                    DumpExcelSheet(pck.Workbook.Worksheets.Add(_months[_month - 1]), tbl, _ds.Tables[1], _month);
                }

                //EVERYTHING BELOW IS STANDARD EXCEL EPPLUS CODE//
                // ONLY CHANGE THE PROPERTIES AND THE FILENAME

                pck.Workbook.Properties.Title = "Excel Export";
                pck.Workbook.Properties.Author = "Demo";
                pck.Workbook.Properties.Comments = "Report";
                pck.Workbook.Properties.Company = "Demo";

                byte[] fileBytes = pck.GetAsByteArray();

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

                //-------------------
                // FILENAME
                //-------------------
                //Default Download Filename
                string IName = _I.FullName.ToLower();
                IName = IName.Replace(" ", string.Empty);
                IName = IName.Replace(".", string.Empty);
                IName = IName.Replace(",", string.Empty);
                string fileName = "Data_" + IName + _I.IId + "_" + DateTime.Now.ToString("ddMMMyy_HHmmss") + ".xlsx";

                HttpContext.Current.Response.AppendHeader("Content-Disposition",
                 "attachment; " +
                 "filename=" + fileName + "; " +
                 "size=" + fileBytes.Length + "; " +
                 "creation-date=" + DateTime.Now.ToString("R").Replace(",", "") + "; " +
                 "modification-date=" + DateTime.Now.ToString("R").Replace(",", "") + "; " +
                 "read-date=" + DateTime.Now.ToString("R").Replace(",", ""));
                HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.sampleDemo.sheet";

                //Write it back to the client
                HttpContext.Current.Response.BinaryWrite(fileBytes);
                HttpContext.Current.Response.End();
            }
        }

        catch (Exception ex)
        {
            HttpContext.Current.Response.Write("<p>" + ex.Message + "</p>");
            HttpContext.Current.Response.Write(AppDomain.CurrentDomain.BaseDirectory);
        }
    }

    private void DumpExcelSheet(ExcelWorksheet ws,DataTable dtTable, DataTable bfTable, int currentMonth)
    {
        //GLOBAL VALUES
        //  References to these values effect the entire placement structure of the report
        //  @see an already generated copy to understand the placement of these rows / columns
        int daysInMonth = DateTime.DaysInMonth(_year, currentMonth);
        int workprocesses = 14;
        int monthlyTotalRow = (daysInMonth + 4);
        int cumulativeTotalRow = (daysInMonth + 5);


        //Worksheet protection
        ws.Protection.IsProtected = true;
        ws.Protection.SetPassword(_I.IGuid.ToString());
        ws.Protection.AllowAutoFilter = false;
        ws.Protection.AllowDeleteColumns = false;
        ws.Protection.AllowDeleteRows = false;
        ws.Protection.AllowEditObject = false;
        ws.Protection.AllowEditScenarios = false;
        ws.Protection.AllowFormatCells = false;
        ws.Protection.AllowFormatColumns = false;
        ws.Protection.AllowFormatRows = false;
        ws.Protection.AllowInsertColumns = false;
        ws.Protection.AllowInsertHyperlinks = false;
        ws.Protection.AllowInsertRows = false;
        ws.Protection.AllowPivotTables = false;
        ws.Protection.AllowSelectLockedCells = false;
        ws.Protection.AllowSelectUnlockedCells = false;
        ws.Protection.AllowSort = false;

        //Worksheet Settings
        ws.PrinterSettings.Orientation = eOrientation.Landscape;
        ws.PrinterSettings.FitToPage = true;
        ws.PrinterSettings.BottomMargin = (decimal)0.25;
        ws.PrinterSettings.TopMargin = (decimal)0.25;
        ws.PrinterSettings.LeftMargin = (decimal)0.25;
        ws.PrinterSettings.RightMargin = (decimal)0.25;


        //Load the datatable into the sheet
        foreach (DataRow row in dtTable.Rows)
        {
            if (((decimal) row["WorkHour"]) != 0)
            {
                int indexOf = _alphabetList.IndexOf(Char.Parse(row["WorkProcess"].ToString()));
                ws.Cells[_alphabetList[indexOf + 1].ToString() + ((int)row["Day"] + 3)].LoadFromText(row["WorkHour"].ToString());
            }
            
        }


        //Load Structure into the sheet
        ws.Cells["A1"].LoadFromText(_I.FullName);
        ws.Cells["C1"].LoadFromText("Generated: " + DateTime.Now);
        ws.Cells["H1"].LoadFromText("Records");
        ws.Cells["N1"].LoadFromText(_months[currentMonth - 1] + "_" + _year);
        ws.Cells["A2"].LoadFromText("Process");
        ws.Cells["A3"].LoadFromText("BF");
        ws.Cells["A" + monthlyTotalRow].LoadFromText("Monthly Total");
        ws.Cells["A" + cumulativeTotalRow].LoadFromText("Cumulative Total");
        ws.Cells["P2"].LoadFromText("Total Hours to Date");


        //Merge commands
        ws.Cells["C1:G1"].Merge = true;
        ws.Cells["H1:M1"].Merge = true;
        ws.Cells["N1:P1"].Merge = true;


        //Formats for subheaders
        SetSubHeaderStyle(ws.Cells["A2:P3"]);
        SetSubHeaderStyle(ws.Cells["P4:P" + cumulativeTotalRow]);
        SetSubHeaderStyle(ws.Cells["A" + monthlyTotalRow + ":P" + cumulativeTotalRow]);


        //Format the header 
        using (ExcelRange rng = ws.Cells["A1:P1"])
        {
            rng.Style.Font.Bold = true;
            rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
            rng.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));  //Set color to dark blue
            rng.Style.Font.Color.SetColor(Color.White);
            rng.Style.Locked = true;
        }


        //Format Sheet Borders
        using (ExcelRange rng = ws.Cells["A2:P" + cumulativeTotalRow])
        {
            rng.Style.Border.Left.Style = ExcelBorderStyle.Thin;
            rng.Style.Border.Top.Style = ExcelBorderStyle.Thin;
            rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
            rng.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;

            rng.Style.Border.Left.Color.SetColor(Color.GhostWhite);
            rng.Style.Border.Top.Color.SetColor(Color.GhostWhite);
            rng.Style.Border.Right.Color.SetColor(Color.GhostWhite);
            rng.Style.Border.Bottom.Color.SetColor(Color.GhostWhite);
        }


        //Format the Work Process
        for (int i = 0; i < workprocesses; i++)
        {
            string process = _alphabetList[i + 1].ToString();

            ws.Cells[process + "2"].LoadFromText(_alphabetList[i].ToString());
            SetSubHeaderStyle(ws.Cells[process + "2"], ExcelHorizontalAlignment.Center);


            //Format Totals
            ws.Cells[process + monthlyTotalRow].Formula =
                "SUM(" + process + "4:" + process + (daysInMonth + 3) + ")";
            ws.Cells[_alphabetList[i + 1].ToString() + cumulativeTotalRow].Formula =
                "SUM(" + process + "3:" + process + (daysInMonth + 3) + ")";

        }

        //Brought Forward
        foreach (DataRow row in bfTable.Rows)
        {
            if (row["TotalHours"] != DBNull.Value)
            {
                int indexOf = _alphabetList.IndexOf(Char.Parse(row["WorkProcess"].ToString()));
                ws.Cells[_alphabetList[indexOf + 1] + "3"].LoadFromText(row["TotalHours"].ToString());
            }
        }

        //Format Forumla All
        ws.Cells["P" + monthlyTotalRow].Formula =
            "SUM(B" + monthlyTotalRow + ":" + _alphabetList[workprocesses] + monthlyTotalRow + ")";
        ws.Cells["P" + cumulativeTotalRow].Formula =
            "SUM(B" + cumulativeTotalRow + ":" + _alphabetList[workprocesses] + cumulativeTotalRow + ")";
        ws.Cells["P" + "3"].Formula =
            "SUM(B3:" + _alphabetList[workprocesses] + "3)"; 


        //Format the DaysInTheMonth
        for (int i = 0; i < daysInMonth; i++)
        {
            ws.Cells["A" + (i + 4)].LoadFromText((i + 1).ToString());
            SetSubHeaderStyle(ws.Cells["A" + (i + 4)], ExcelHorizontalAlignment.Right);

            //Format Totals
            ws.Cells["P" + (i + 4)].Formula =
                "SUM(B" + (i + 4) + ":" + _alphabetList[workprocesses] + (i + 4) + ")";
        }

        using (ExcelRange rng = ws.Cells["B3:P" + cumulativeTotalRow])
        {
            rng.Style.Numberformat.Format = "#,###,###,##0.00";
            rng.Style.Font.Size = 14;
        }

        
        ws.Cells.Style.Font.Size = 14;
        for (int i = 1; i <= cumulativeTotalRow; i++)
        {
            ws.Row(i).Height = 25;
        }

        //Column Styling
        ws.Cells["A1:P" + cumulativeTotalRow].AutoFitColumns();

        //Format the Work Process
        for (int i = 0; i < workprocesses; i++)
        {
            ws.Column(i + 1).Width = 15;
        }
    }

    private void SetSubHeaderStyle(
        ExcelRange range, 
        ExcelHorizontalAlignment horizontalAlignment = ExcelHorizontalAlignment.Left)
    {
        range.Style.Font.Bold = true;
        range.Style.HorizontalAlignment = horizontalAlignment;
        range.Style.Fill.PatternType = ExcelFillStyle.Solid;
        range.Style.Fill.BackgroundColor.SetColor(Color.Gainsboro);
    }
}