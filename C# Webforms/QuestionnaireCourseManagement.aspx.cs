/*
  This is the Questionnaire System used to edit Questionnaire Course or Project level groupping.
  
  The following code demonstrates a typical implementation of the back-end code done in C# ASP.NET 4.5 Webforms
  
  This is not a copy of any current implementation of any company but rather a demonstration of how things 
  were initially scaffolded during the design phrase.

  
  Order of Implementation:
    - Imports
    - Global Variables
    - OnInit() // Equivalent to ConfigureServices
    - OnPageLoad() // Equivalent to Startup
    - ConnectToSql() // Main DBContext Section
    - BindControls() // Main Controller Section
    - Any Main Content Processing Section 
    - Any Handlers Content Processing Section
    - Any Javascript or Return Content Processing Section
    
  Dependencies:
    - Company Specific User Controls
*/

using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NEIEP;
using NEIEP.ClassLibrary.Security;

// ReSharper disable once InconsistentNaming
public partial class ServicesQECourse : Page
{
    private SqlConnection _cn = new SqlConnection(ConfigurationManager.AppSettings["something"]);
    private SqlConnection _cn2 = new SqlConnection(ConfigurationManager.ConnectionStrings["something"].ConnectionString);
    private DataSet _ds = new DataSet();
    private DataSet _dsOninit = new DataSet();
    private DataSet _dsModal = new DataSet();
    private Passport _pass;

    private bool _isAuthorized;
    private int _courseId;

    //-----------------------------------------------
    // OnInit(EventArgs) void
    //-----------------------------------------------
    protected override void OnInit(EventArgs e)
    {
        base.OnInit(e);

        try
        {

            if (Session["Passport"] == null)
            {
                Response.RedirectPermanent("~/bst-Default.aspx");
                return;
            }

            //---------------------------------------------------
            _pass = (Passport)Session["Passport"];
            _isAuthorized = _pass.IsAuthorized("something");

            if (!_isAuthorized)
            {
                Response.RedirectPermanent("~/bst-restricted.aspx");
                return;
            }

            if (Request.QueryString["c"] != null)
            {
                if (Request.QueryString["c"].All(Char.IsNumber))
                {
                    _courseId = Int32.Parse(Request.QueryString["c"]);
                }
            }

            //---------------------------------------------------
            ConnectToSql(0, "Oninit");
            BindControls("Oninit");
        }
        catch (Exception exception)
        {
            MessageBox1.Add(exception.Message, MessageStatus.Error);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ConnectToSql(0, "Form");
            BindControls("Form");

            if (_courseId > 0)
            {
                gvCourses_OnRowCommand_LoadCourse(_courseId);
            }
        }
    }

    
    //-----------------------------------------------
    // ConnectToSql(int) void
    //-----------------------------------------------
    private bool ConnectToSql(int call, string mode)
    {
        bool isValid = true;
        SqlTransaction transaction = null;


        string ip4 = "";
        foreach (IPAddress ip in Dns.GetHostEntry(Environment.MachineName).AddressList)
        {
            if (ip.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork)
            {
                if (ip4.Equals(""))
                    ip4 = ip.ToString();
            }
        }

        try
        {
            _cn.Open();
            _cn2.Open();
            switch (mode)
            {
                case "Oninit":
                    _dsOninit = new DataSet();
                    using (SqlCommand cm = new SqlCommand("[Questionnaire].[EditorCourse_OnInit]", _cn2))
                    {
                        cm.CommandType = CommandType.StoredProcedure;
                        using (SqlDataAdapter da = new SqlDataAdapter(cm))
                        {
                            da.Fill(_dsOninit);
                        }
                    }
                    break;
                case "Form":
                    if (call == 0)
                    {
                        _ds = new DataSet();
                        using (SqlCommand cm = new SqlCommand("[Questionnaire].[EditorCourse_Select]", _cn2))
                        {
                            cm.CommandType = CommandType.StoredProcedure;
                            cm.Parameters.AddWithValue("@Course", SearchCourse.Text.Trim());
                            cm.Parameters.AddWithValue("@CourseTypeId", Int32.Parse(SearchCourseType.SelectedValue));
                            cm.Parameters.AddWithValue("@Status", Int32.Parse(SearchStatus.SelectedValue));
                            using (SqlDataAdapter da = new SqlDataAdapter(cm))
                            {
                                da.Fill(_ds);
                            }
                        }

                        ViewState["DS"] = _ds;
                    }
                    else
                    {
                        _ds = (DataSet) ViewState["DS"];
                    }
                    break;
                case "Modal":
                    _dsModal = new DataSet();
                    using (SqlCommand cm = new SqlCommand("[Questionnaire].[EditorCourse_Modal]", _cn2))
                    {
                        cm.CommandType = CommandType.StoredProcedure;
                        cm.Parameters.AddWithValue("@CourseId", Int32.Parse(ModalCourseCourseId.Value));
                        using (SqlDataAdapter da = new SqlDataAdapter(cm))
                        {
                            da.Fill(_dsModal);
                        }
                    }
                    break;
                case "Insert":
                    transaction = _cn2.BeginTransaction();
                    using (SqlCommand cm = new SqlCommand("[Questionnaire].[EditorCourse_Modify]", _cn2, transaction))
                    {
                        cm.CommandType = CommandType.StoredProcedure;
                        cm.Parameters.AddWithValue("@Mode", "Insert");
                        cm.Parameters.AddWithValue("@Course", ModalCourseCourse.Text.Trim());
                        cm.Parameters.AddWithValue("@CourseTypeId", Int32.Parse(ModalCourseCourseType.SelectedValue));
                        cm.Parameters.AddWithValue("@Status", ModalCourseStatus.Checked);
                        cm.Parameters.AddWithValue("@PassportIndividualId", _pass.IndividualId);
                        cm.Parameters.AddWithValue("@DateModified", DateTimeOffset.Now);
                        cm.Parameters.AddWithValue("@BrowserIPv4", ip4);
                        cm.Parameters.AddWithValue("@BrowserIPv6", HttpContext.Current.Request.UserHostAddress);
                        cm.Parameters.AddWithValue("@BrowserType", HttpContext.Current.Request.Browser.Type);
                        cm.Parameters.AddWithValue("@BrowserName", HttpContext.Current.Request.Browser.Browser);
                        cm.Parameters.AddWithValue("@BrowserVersion", HttpContext.Current.Request.Browser.Version);
                        cm.Parameters.AddWithValue("@BrowserMajorVersion", HttpContext.Current.Request.Browser.MajorVersion);
                        cm.Parameters.AddWithValue("@BrowserMinorVersion", HttpContext.Current.Request.Browser.MinorVersion);
                        cm.Parameters.AddWithValue("@BrowserPlatform", HttpContext.Current.Request.Browser.Platform);
                        cm.ExecuteNonQuery();
                        transaction.Commit();
                    }
                    break;
                case "Update":
                    transaction = _cn2.BeginTransaction();
                    using (SqlCommand cm = new SqlCommand("[Questionnaire].[EditorCourse_Modify]", _cn2, transaction))
                    {
                        cm.CommandType = CommandType.StoredProcedure;
                        cm.Parameters.AddWithValue("@Mode", "Update");
                        cm.Parameters.AddWithValue("@CourseId", Int32.Parse(ModalCourseCourseId.Value));
                        cm.Parameters.AddWithValue("@Course", ModalCourseCourse.Text.Trim());
                        cm.Parameters.AddWithValue("@CourseTypeId", Int32.Parse(ModalCourseCourseType.SelectedValue));
                        cm.Parameters.AddWithValue("@Status", ModalCourseStatus.Checked);
                        cm.Parameters.AddWithValue("@PassportIndividualId", _pass.IndividualId);
                        cm.Parameters.AddWithValue("@DateModified", DateTimeOffset.Now);
                        cm.Parameters.AddWithValue("@BrowserIPv4", ip4);
                        cm.Parameters.AddWithValue("@BrowserIPv6", HttpContext.Current.Request.UserHostAddress);
                        cm.Parameters.AddWithValue("@BrowserType", HttpContext.Current.Request.Browser.Type);
                        cm.Parameters.AddWithValue("@BrowserName", HttpContext.Current.Request.Browser.Browser);
                        cm.Parameters.AddWithValue("@BrowserVersion", HttpContext.Current.Request.Browser.Version);
                        cm.Parameters.AddWithValue("@BrowserMajorVersion", HttpContext.Current.Request.Browser.MajorVersion);
                        cm.Parameters.AddWithValue("@BrowserMinorVersion", HttpContext.Current.Request.Browser.MinorVersion);
                        cm.Parameters.AddWithValue("@BrowserPlatform", HttpContext.Current.Request.Browser.Platform);
                        cm.ExecuteNonQuery();
                        transaction.Commit();
                    }
                    break;
                case "Delete":
                    transaction = _cn2.BeginTransaction();
                    using (SqlCommand cm = new SqlCommand("[Questionnaire].[EditorCourse_Modify]", _cn2, transaction))
                    {
                        cm.CommandType = CommandType.StoredProcedure;
                        cm.Parameters.AddWithValue("@Mode", "Delete");
                        cm.Parameters.AddWithValue("@CourseId", Int32.Parse(ModalCourseCourseId.Value));
                        cm.Parameters.AddWithValue("@PassportIndividualId", _pass.IndividualId);
                        cm.Parameters.AddWithValue("@DateModified", DateTimeOffset.Now);
                        cm.Parameters.AddWithValue("@BrowserIPv4", ip4);
                        cm.Parameters.AddWithValue("@BrowserIPv6", HttpContext.Current.Request.UserHostAddress);
                        cm.Parameters.AddWithValue("@BrowserType", HttpContext.Current.Request.Browser.Type);
                        cm.Parameters.AddWithValue("@BrowserName", HttpContext.Current.Request.Browser.Browser);
                        cm.Parameters.AddWithValue("@BrowserVersion", HttpContext.Current.Request.Browser.Version);
                        cm.Parameters.AddWithValue("@BrowserMajorVersion", HttpContext.Current.Request.Browser.MajorVersion);
                        cm.Parameters.AddWithValue("@BrowserMinorVersion", HttpContext.Current.Request.Browser.MinorVersion);
                        cm.Parameters.AddWithValue("@BrowserPlatform", HttpContext.Current.Request.Browser.Platform);
                        cm.ExecuteNonQuery();
                        transaction.Commit();
                    }
                    break;
            }
            _cn2.Close();
            _cn.Close();
        }
        catch (Exception exception)
        {
            isValid = false;
            MessageBox1.Add(exception.Message, MessageStatus.Error);
            if (transaction != null) transaction.Rollback();
        }

        if (_cn.State == ConnectionState.Open) _cn.Close();
        if (_cn2.State == ConnectionState.Open) _cn2.Close();

        return isValid;
    }


    //-----------------------------------------------
    // BindControls() void
    //-----------------------------------------------
    private void BindControls(string mode)
    {
        switch (mode)
        {
            case "Oninit":
                ModalCourseCourseType.Items.Clear();
                SearchCourseType.Items.Clear();
                SearchCourseType.Items.Add(new ListItem("All Course Types", "-1"));
                foreach (DataRow row in _dsOninit.Tables[0].Rows)
                {
                    ModalCourseCourseType.Items.Add(new ListItem(row["CourseType"].ToString(), row["CourseTypeId"].ToString()));
                    SearchCourseType.Items.Add(new ListItem(row["CourseType"].ToString(), row["CourseTypeId"].ToString()));
                }
                break;
            case "Form":
                ControlsStats.Text = String.Format("Total Records: {0}<br/>", _ds.Tables[0].Rows.Count);

                ControlsStats.Visible = true;
                ControlsExport.Visible = true;

                gvCourses.DataSource = _ds.Tables[0];
                gvCourses.DataBind();
                break;
        }
    }

    //----------------------------------------------------
    // SEARCH ALGORITHMS
    //----------------------------------------------------
    protected void SearchSearch_OnClick(object sender, EventArgs e)
    {
        ConnectToSql(0, "Form");
        BindControls("Form");
    }

    protected void SearchReset_OnClick(object sender, EventArgs e)
    {
        Response.Redirect(Request.RawUrl);
    }

    //----------------------------------------------------
    // CONTROLS
    //----------------------------------------------------
    protected void ControlsExport_OnClick(object sender, EventArgs e)
    {
        _ds = (DataSet) ViewState["DS"];

        Utils.DumpExcel(_ds.Tables[1], "Export Questionnaire Editor Course Report", "ExportQuestionnaireEditorCourseReport_");
    }

    protected void ControlsCreate_OnClick(object sender, EventArgs e)
    {
        ModalCourseCourse.Text = "";
        ModalCourseCourseId.Value = "";
        ModalCourseCourseType.SelectedIndex = 0;

        ModalCourseStatus.Checked = true;

        ModalCourseHistoryWrapper.Visible = false;
        ModalCourseDialog.Attributes["style"] = "max-width: 600px;width: 100%;";

        ModalCourseInsert.Visible = true;
        ModalCourseInsertAndAddSection.Visible = true;
        ModalCourseDelete.Visible = false;
        ModalCourseUpdate.Visible = false;
        
        ScriptManager.RegisterStartupScript(this, GetType(), "onrowcommandscript1", @"
            var obj = document.getElementById('" + ModalCourseCourse.ClientID + "'); " + "taCount(obj,'ModalCourseCourseCounter', 500);", true);
        ScriptManager.RegisterStartupScript(this, GetType(), "onrowcommandscript2", "$('#ModalCourse').modal({backdrop: 'static', keyboard: false}).modal('show');", true);
    }

    //----------------------------------------------------
    // GRIDVIEWS
    //----------------------------------------------------
    protected void gvCourses_OnRowDataBound(object sender, GridViewRowEventArgs e)
    {
        foreach (TableCell cell in e.Row.Cells)
        {
            cell.Style["padding"] = "3px";
            cell.Style["font-size"] = "12px";
        }

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            //db reference
            int courseId = (int) DataBinder.Eval(e.Row.DataItem, "CourseId");
            string backgroundColor = DataBinder.Eval(e.Row.DataItem, "BackgroundColor").ToString();

            HiddenField gcCourseId = (HiddenField)e.Row.FindControl("gcCourseId");
            Literal gcSections = (Literal)e.Row.FindControl("gcSections");
            Literal gcBackgroundColor = (Literal)e.Row.FindControl("gcBackgroundColor");

            e.Row.Cells[0].Attributes["style"] = "background-color: " + backgroundColor;
            gcCourseId.Value = courseId.ToString();

            if (_ds.Tables[2].Rows.Count > 0)
            {
                var linq = _ds.Tables[2].AsEnumerable()
                    .Where(x => x.Field<int>("CourseId") == courseId);

                if (linq.Any())
                {
                    foreach (DataRow row in linq)
                    {
                        gcSections.Text += String.Format(
                            @"<tr>
                                    <td style='padding: 3px; font-size: 12px;'>
                                        <a href='QESection.aspx?c={0}&s={1}' class='glyphicon glyphicon-new-window' aria-hidden='true'> {2} [{3}]</a>
                                    </td>
                                    <td style='padding: 3px; font-size: 12px;width:100px;'>
                                        <a href='QEQuestion.aspx?s={3}' class='glyphicon glyphicon-log-out' aria-hidden='true'> Questions ({4})</a>
                                    </td>
                                </tr>",
                            row["CourseId"],
                            row["SectionId"],
                            row["Section"],
                            row["SectionId"],
                            row["Questions"]);
                    }
                }
                else
                {
                    gcSections.Text += "<tr><td colspan='2'>No Sections Found</td></tr>";
                }
            }
            else
            {
                gcSections.Text += "<tr><td colspan='2'>No Sections Found</td></tr>";
            }

        }
    }

    protected void gvCourses_OnRowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "gcModifyCourse")
        {
            #region REGION: gcModifyCourse

            //reinstates dynamically created controls
            ConnectToSql(1, "Form");
            BindControls("Form");

            // Retrieve the row index stored in the 
            // CommandArgument property.
            int index = Convert.ToInt32(e.CommandArgument);

            // Retrieve the row that contains the button 
            // from the Rows collection.
            GridViewRow row = gvCourses.Rows[index];
            gvCourses.SelectedIndex = index;

            //Gets data to fill in Editor Panel
            HiddenField gcCourseId = (HiddenField)row.FindControl("gcCourseId");

            gvCourses_OnRowCommand_LoadCourse(Int32.Parse(gcCourseId.Value));

            #endregion            
        }

        if (e.CommandName == "gcModifySection")
        {
            #region REGION: gcModifySection

            //reinstates dynamically created controls
            ConnectToSql(1, "Form");
            BindControls("Form");

            // Retrieve the row index stored in the 
            // CommandArgument property.
            int index = Convert.ToInt32(e.CommandArgument);

            // Retrieve the row that contains the button 
            // from the Rows collection.
            GridViewRow row = gvCourses.Rows[index];
            gvCourses.SelectedIndex = index;

            //Gets data to fill in Editor Panel
            HiddenField gcCourseId = (HiddenField)row.FindControl("gcCourseId");

            gvCourses_OnRowCommand_LoadSection(Int32.Parse(gcCourseId.Value));

            #endregion
        }
    }

    protected void ModalCourseHistory_OnRowDataBound(object sender, GridViewRowEventArgs e)
    {
        foreach (TableCell cell in e.Row.Cells)
        {
            cell.Style["padding"] = "3px";
            cell.Style["font-size"] = "12px";
            cell.Style["white-space"] = "nowrap";
        }
    }


    private void gvCourses_OnRowCommand_LoadCourse(int courseId)
    {
        var linq = _ds.Tables[0].AsEnumerable().First(x => x.Field<int>("CourseId") == courseId);


        ModalCourseCourse.Text = linq["Course"].ToString();
        ModalCourseCourseId.Value = linq["CourseId"].ToString();

        ListItem currentCourseType = ModalCourseCourseType.Items.FindByValue(linq["CourseTypeId"].ToString());
        ModalCourseCourseType.SelectedIndex = ModalCourseCourseType.Items.IndexOf(currentCourseType);

        ModalCourseStatus.Checked = (bool)linq["Status"];

        ConnectToSql(0, "Modal");
        ModalCourseHistoryWrapper.Visible = true;
        ModalCourseHistory.DataSource = _dsModal.Tables[0];
        ModalCourseHistory.DataBind();
        ModalCourseHistoryCount.Text = String.Format("[{0}] ", _dsModal.Tables[0].Rows.Count);

        ModalCourseDialog.Attributes["style"] = "max-width: 1200px;width: 100%;";

        ModalCourseInsert.Visible = false;
        ModalCourseInsertAndAddSection.Visible = false;
        ModalCourseDelete.Visible = _pass.IsAuthorized("Website_Questionnaire2_Editor", 0);
        ModalCourseUpdate.Visible = true;

        ScriptManager.RegisterStartupScript(this, GetType(), "onrowcommandscript1", @"
            var obj = document.getElementById('" + ModalCourseCourse.ClientID + "'); " + "taCount(obj,'ModalCourseCourseCounter', 500);", true);
        ScriptManager.RegisterStartupScript(this, GetType(), "onrowcommandscript2", "$('#ModalCourse').modal({backdrop: 'static', keyboard: false}).modal('show');", true);
    }

    private void gvCourses_OnRowCommand_LoadSection(int courseId, bool autoShowCreateMenu = false)
    {
        Response.RedirectPermanent("~/Services/QESection.aspx?c=" + courseId + (autoShowCreateMenu ? "&z=1" : ""));
    }

    //----------------------------------------------------
    // HANDLERS
    //----------------------------------------------------
    protected void ModalCourseInsert_OnClick(object sender, EventArgs e)
    {
        try
        {
            string course = ModalCourseCourse.Text.Trim();
            if (course.Equals(""))
                throw new Exception("Course is required");
            if (course.Length >= 500 || course.Length <= 0)
                throw new Exception("Course length must be between 1 and 500 characters");

            if (ConnectToSql(0, "Insert"))
            {
                MessageBox1.Add(
                    "Sucessfully created Course: [" + ModalCourseCourse.Text + "] of type [" + ModalCourseCourseType.SelectedItem.Text + @"].", 
                    MessageStatus.Success);
            }
        }
        catch (Exception exception)
        {
            ModalCourseMessageBox.Add(exception.Message, MessageStatus.Error);
            ScriptManager.RegisterStartupScript(this, GetType(), "onrowcommandscript1", @"
            var obj = document.getElementById('" + ModalCourseCourse.ClientID + "'); " + "taCount(obj,'ModalCourseCourseCounter', 500);", true);
            ScriptManager.RegisterStartupScript(this, GetType(), "onrowcommandscript2", "$('#ModalCourse').modal({backdrop: 'static', keyboard: false}).modal('show');", true);
        }

        ConnectToSql(0, "Form");
        BindControls("Form");
    }

    protected void ModalCourseUpdate_OnClick(object sender, EventArgs e)
    {
        try
        {
            string course = ModalCourseCourse.Text.Trim();
            if (course.Equals(""))
                throw new Exception("Course is required");
            if (course.Length > 500 || course.Length <= 0)
                throw new Exception("Course length must be between 1 and 500 characters");

            if (ConnectToSql(0, "Update"))
            {
                MessageBox1.Add(
                    "Sucessfully Updated the Course: [" + ModalCourseCourse.Text + "] of type [" + ModalCourseCourseType.SelectedItem.Text + @"].",
                    MessageStatus.Success);
            }
        }
        catch (Exception exception)
        {
            ModalCourseMessageBox.Add(exception.Message, MessageStatus.Error);
            ScriptManager.RegisterStartupScript(this, GetType(), "onrowcommandscript1", @"
            var obj = document.getElementById('" + ModalCourseCourse.ClientID + "'); " + "taCount(obj,'ModalCourseCourseCounter', 500);", true);
            ScriptManager.RegisterStartupScript(this, GetType(), "onrowcommandscript2", "$('#ModalCourse').modal({backdrop: 'static', keyboard: false}).modal('show');", true);
        }

        ConnectToSql(0, "Form");
        BindControls("Form");
    }

    protected void ModalCourseDelete_OnClick(object sender, EventArgs e)
    {
        try
        {
            if (ConnectToSql(0, "Delete"))
            {
                MessageBox1.Add(
                    "Sucessfully Deleted the Course: [" + ModalCourseCourse.Text + "] of type [" + ModalCourseCourseType.SelectedItem.Text + "]",
                    MessageStatus.Success);
            }
        }
        catch (Exception exception)
        {
            ModalCourseMessageBox.Add(exception.Message, MessageStatus.Error);
            ScriptManager.RegisterStartupScript(this, GetType(), "onrowcommandscript1", @"
            var obj = document.getElementById('" + ModalCourseCourse.ClientID + "'); " + "taCount(obj,'ModalCourseCourseCounter', 500);", true);
            ScriptManager.RegisterStartupScript(this, GetType(), "onrowcommandscript2", "$('#ModalCourse').modal({backdrop: 'static', keyboard: false}).modal('show');", true);
        }

        ConnectToSql(0, "Form");
        BindControls("Form");
    }

    protected void ModalCourseInsertAndAddSection_OnClick(object sender, EventArgs e)
    {
        try
        {
            ModalCourseInsert_OnClick(sender, e);
            var linq = _ds.Tables[0].AsEnumerable()
                .OrderByDescending(x => x.Field<DateTimeOffset>("DateCreated"))
                .Select(x => x.Field<int>("CourseId"))
                .First();
            gvCourses_OnRowCommand_LoadSection(linq, true);
        }
        catch (Exception exception)
        {
            ModalCourseMessageBox.Add(exception.Message, MessageStatus.Error);
            ScriptManager.RegisterStartupScript(this, GetType(), "onrowcommandscript1", @"
            var obj = document.getElementById('" + ModalCourseCourse.ClientID + "'); " + "taCount(obj,'ModalCourseCourseCounter', 500);", true);
            ScriptManager.RegisterStartupScript(this, GetType(), "onrowcommandscript2", "$('#ModalCourse').modal({backdrop: 'static', keyboard: false}).modal('show');", true);
        }
    }
}
