using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Demo
{
    public class Individual
    {
        #region Class Level Private Variables
        private DataSet _ds = new DataSet();

        #endregion


        #region Public Properties
        public int IndividualId { get; private set; } = -1;

        public string FirstName { get; private set; } = "";
        public string MiddleName { get; private set; } = "";
        public string LastName { get; private set; } = "";
        public string Suffix { get; private set; } = "";
        public string IndividualNameWithId { get; private set; } = "";
        public string EmailAddress { get; private set; } = "";


        public string   Street1       { get ; private set; } = "";
        public string   Street2       { get ; private set; } = "";
        public string   City          { get ; private set; } = "";
        public int      StateId       { get ; private set; } = -1;
        public string   Zip           { get ; private set; } = "";
        public string   Gender        { get ; private set; } = "";
        public string   EthnicCode    { get ; private set; } = "";
        public int   VeteranTypeId    { get ; private set; } = -1;
        public string   Phone1        { get ; private set; } = "";
        public string   Phone1Desc    { get ; private set; } = "";
        public string   Phone2        { get ; private set; } = "";
        public string   Phone2Desc    { get ; private set; } = "";
        public string   Phone3        { get ; private set; } = "";
        public string   Phone3Desc    { get ; private set; } = "";
        public string   Fax           { get ; private set; } = "";
        public string   FaxDesc       { get ; private set; } = "";
        public string   Status        { get ; private set; } = "";
        public DateTime BirthDate     { get ; private set; } = DateTime.MinValue;


        #endregion

        #region Public Methods
        public Individual(int individualId, SqlConnection cn)
        {
            ConnectToSql(individualId, "", cn);
            BindControls(cn);
        }
        public Individual(string lastname, SqlConnection cn)
        {
            ConnectToSql(-1, lastname, cn);
            BindControls(cn);
        }
        #endregion

        #region Private Methods

        private void ConnectToSql(int individualId, string lastname, SqlConnection cn)
        {
            try
            {
                _ds = new DataSet();
                cn.Open();
                using (SqlCommand cm = new SqlCommand("[Workspace].[Individual_Select]", cn))
                {
                    cm.CommandType = CommandType.StoredProcedure;
                    cm.Parameters.AddWithValue("@IndividualId", individualId);
                    cm.Parameters.AddWithValue("@lastname", lastname);
                    using SqlDataAdapter da = new SqlDataAdapter(cm);
                    da.Fill(_ds);
                }
                cn.Close();
            }
            catch (Exception)
            {
                if (cn.State != ConnectionState.Closed) cn.Close();
                throw;
            }
        }

        private void BindControls(SqlConnection cn)
        {
            if (_ds.Tables[0].Rows.Count < 1)
                throw new Exception("Individual is missing");

            var linq0 = _ds.Tables[0].Rows[0];
            IndividualId = (int)linq0["IndividualId"];
            FirstName = linq0["FirstName"].ToString();
            MiddleName = linq0["Middlename"].ToString();
            LastName = linq0["Lastname"].ToString();
            Suffix = linq0["Suffix"].ToString();
            IndividualNameWithId = linq0["IndividualNameWithId"].ToString();
            Street1 = linq0["Street1"].ToString();
            Street2 = linq0["Street2"].ToString();
            City = linq0["City"].ToString();
            State = linq0["State"].ToString();
            StateId = (int) linq0["StateId"];
            Zip = linq0["Zip"].ToString();
            Phone1 = linq0["Phone1"].ToString();
            Phone1Desc = linq0["Phone1Desc"].ToString();
            Phone2 = linq0["Phone2"].ToString();
            Phone2Desc = linq0["Phone2Desc"].ToString();
            Phone3 = linq0["Phone3"].ToString();
            Phone3Desc = linq0["Phone3Desc"].ToString();
            Fax = linq0["Fax"].ToString();
            FaxDesc = linq0["FaxDesc"].ToString();
            EthnicCode = linq0["EthnicCode"].ToString();
            Gender = linq0["Gender"].ToString();
            Status = linq0["Status"].ToString();
            VeteranTypeId = (int) linq0["VeteranTypeId"];
        }
        #endregion
    }

}
