using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System.Web.Http;
using SNHU.IT700.Functions.Models;

namespace SNHU.IT700.Functions.Contexts
{
	public class DBContext
	{

		public interface IDbContext
		{
			string ExecuteStoredProcedure(ILogger log, string procedureName, List<SqlParameter> parameters, bool hasOutput = false);
			IDBContextResponse ExecuteStoredProcedure(ILogger log, string procedureName, List<SqlParameter> parameters, string mode);
		}

		public interface IDbContextFactory
		{
			IDbContext GetDbContext(string connectionString);
		}


		public class DbContextFactory : IDbContextFactory
		{
			public IDbContext GetDbContext(string connectionString)
			{
				return new DbContext(connectionString);
			}
		}

		public interface IDBContextResponse
		{
			//nothing for abstraction only
		}

		public class DBContextResponseDefaultModel : IDBContextResponse
		{
			//nothing for abstraction only
			public string ExceptionMessage { get; set; } = "";
			public string ExceptionStacktrace { get; set; } = "";
			public DBContextResponseDefaultModel()
			{

			}

			public DBContextResponseDefaultModel(string exceptionMessage, string exceptionStacktrace)
			{
				ExceptionMessage = exceptionMessage;
				ExceptionStacktrace = exceptionStacktrace;
			}
		}

		public class DbContext : IDbContext
		{
			private string _connectionString { get; set; }

			public DbContext(string connectionString)
			{
				_connectionString = connectionString;
			}

			/// <summary>
			/// Performs an ADO Stored Procedure Execution
			/// </summary>
			/// <param name="log">The Log Instance of Azure Functions</param>
			/// <param name="procedure">The Key Vault Secret name to lookup the SQL procedure name</param>
			/// <param name="parameters">The abstracted Model of SQL Parameters to be inserted</param>
			/// <param name="hasOutput">If true, returns a scalar value as a string. If false, returns "success" if complete, or ExceptionResult </param>
			/// <returns>
			///    OK Result - 200 - If successful - Possible return of Scalar Value from Database
			///    No Content - 204 - Nothing provided
			///    Exception - 500 - Error in SQL, See Azure Function Monitor Logs in the Portal
			/// </returns>
			public string ExecuteStoredProcedure(ILogger log, string procedure, List<SqlParameter> parameters, bool hasOutput = false)
			{
				string output = "Success";

				SqlConnection cn = new SqlConnection(_connectionString);

				// Begin
				SqlTransaction transaction = null;
				try
				{
					cn.Open();
					transaction = cn.BeginTransaction();
					using (SqlCommand cm = new SqlCommand(procedure, cn, transaction))
					{
						cm.CommandType = CommandType.StoredProcedure;
						cm.CommandTimeout = 120;

						// Adding Parameters
						foreach (SqlParameter parameter in parameters)
						{
							string str3 = $"Adding parameter: {parameter.ParameterName}, value: {parameter.Value}";
							log.LogInformation(str3);


							// Do nothing checks
							// For Null references
							if (parameter.DbType == DbType.DateTime && (DateTime)parameter.Value == DateTime.MinValue)
								cm.Parameters.AddWithValue(parameter.ParameterName, DBNull.Value);
							else if (parameter.DbType == DbType.Int32 && (int)parameter.Value < 0)
								cm.Parameters.AddWithValue(parameter.ParameterName, DBNull.Value);
							else
								cm.Parameters.Add(parameter);
						}

						// Output something if an output is provided
						if (hasOutput)
						{
							output = cm.ExecuteScalar().ToString();
						}
						else
						{
							cm.ExecuteNonQuery();
						}

						transaction.Commit();
						log.LogInformation($"Successfully Executed Procedure: {procedure}");
					}
					cn.Close();
				}
				catch (Exception exception)
				{
					log.LogInformation(exception.Message + " " + procedure, parameters);
					log.LogInformation(exception.StackTrace);

					if (transaction != null) transaction.Rollback();
					if (cn.State != ConnectionState.Closed) cn.Close();

					return exception.Message;
				}

				return output;
			}


			/// <summary>
			/// Performs an ADO Stored Procedure Execution
			/// </summary>
			/// <param name="log">The Log Instance of Azure Functions</param>
			/// <param name="procedure">The Key Vault Secret name to lookup the SQL procedure name</param>
			/// <param name="parameters">The abstracted Model of SQL Parameters to be inserted</param>
			/// <param name="mode"></param>
			/// <returns>
			///    OK Result - 200 - If successful - Possible return of Scalar Value from Database
			///    No Content - 204 - Nothing provided
			///    Exception - 500 - Error in SQL, See Azure Function Monitor Logs in the Portal
			/// </returns>
			public IDBContextResponse ExecuteStoredProcedure(ILogger log, string procedure, List<SqlParameter> parameters, string mode)
			{
				IDBContextResponse output = null;

				SqlConnection cn = new SqlConnection(_connectionString);

				// Begin
				SqlTransaction transaction = null;
				try
				{
					cn.Open();
					transaction = cn.BeginTransaction();
					using (SqlCommand cm = new SqlCommand(procedure, cn, transaction))
					{
						cm.CommandType = CommandType.StoredProcedure;
						cm.CommandTimeout = 120;

						// Adding Parameters
						foreach (SqlParameter parameter in parameters)
						{
							string str3 = $"Adding parameter: {parameter.ParameterName}, value: {parameter.Value}";
							log.LogInformation(str3);


							// Do nothing checks
							// For Null references
							if (parameter.DbType == DbType.DateTime && (DateTime)parameter.Value == DateTime.MinValue)
								cm.Parameters.AddWithValue(parameter.ParameterName, DBNull.Value);
							else if (parameter.DbType == DbType.Int32 && (int)parameter.Value < 0)
								cm.Parameters.AddWithValue(parameter.ParameterName, DBNull.Value);
							else
								cm.Parameters.Add(parameter);
						}

						// Output something if an output is provided
						switch (mode)
						{
							case "SearchFilters":
								SearchFilterResponseModel model = new SearchFilterResponseModel();
								using(SqlDataReader dr = cm.ExecuteReader())
								{
									while (dr.Read())
									{
										model.CountryList.Add(new SearchFilterResponseCountryModel(
											(int)dr["ID"],
											dr["PrintableName"].ToString(),
											dr["ISOCode3"].ToString()
											));
									}

									dr.NextResult();

									while (dr.Read())
									{
										model.StateList.Add(new SearchFilterResponseStateModel(
											(int)dr["ID"],
											dr["Name"].ToString(),
											dr["Abbreviation"].ToString()
											));
									}

									dr.NextResult();

									while (dr.Read())
									{
										model.EyeColorList.Add(new SearchFilterResponseEyeColorModel(
											(int)dr["ID"],
											dr["Color"].ToString()
											));
									}

									dr.NextResult();

									while (dr.Read())
									{
										model.HairColorList.Add(new SearchFilterResponseHairColorModel(
											(int)dr["ID"],
											dr["Color"].ToString()
											));
									}

									dr.NextResult();

									while (dr.Read())
									{
										model.EthnicityList.Add(new SearchFilterResponseEthnicityModel(
											(int)dr["ID"],
											dr["Name"].ToString()
											));
									}
								}

								output = model;
								break;

							case "SearchResult":
								SearchResponseListModel searchResponseListModel = new SearchResponseListModel();
								using (SqlDataReader dr = cm.ExecuteReader())
								{
									while (dr.Read())
									{
										var currentModel = new SearchResponseModel();

										currentModel.IndividualId= (int)dr["IndividualId"];
										currentModel.IndividualStatus = dr["IndividualStatus"].ToString();
										currentModel.FirstName = dr["FirstName"].ToString();
										currentModel.LastName = dr["LastName"].ToString();
										currentModel.City = dr["City"].ToString();
										if (dr["StateId"] != DBNull.Value)
										{
											currentModel.StateId = (int)dr["StateId"];
											currentModel.State = dr["State"].ToString();
											currentModel.StateAbbreviation = dr["StateAbbreviation"].ToString();
										}
										if (dr["CountryId"] != DBNull.Value)
										{
											currentModel.CountryId = (int)dr["CountryId"];
											currentModel.Country = dr["Country"].ToString();
											currentModel.CountryAbbreviation = dr["CountryAbbreviation"].ToString();
										}
										if (dr["GenderId"] != DBNull.Value) 
										{
											currentModel.GenderId = (int)dr["GenderId"];
											currentModel.Gender = dr["Gender"].ToString();
										}
										if (dr["EthnicityId"] != DBNull.Value)
										{
											currentModel.EthnicityId = (int)dr["EthnicityId"];
											currentModel.Ethnicity = dr["Ethnicity"].ToString();
										}
										if (dr["HairColorId"] != DBNull.Value)
										{
											currentModel.HairColorId = (int)dr["HairColorId"];
											currentModel.HairColor = dr["HairColor"].ToString();
										}
										if (dr["EyeColorId"] != DBNull.Value)
										{
											currentModel.EyeColorId = (int)dr["EyeColorId"];
											currentModel.EyeColor = dr["EyeColor"].ToString();
										}

										currentModel.Description = dr["Description"].ToString();

										if (dr["Age"] != DBNull.Value)
											currentModel.Age =  (int)dr["Age"];

										currentModel.Phone1 = dr["Phone1"].ToString();
										currentModel.Phone2 = dr["Phone2"].ToString();
										currentModel.Phone3 = dr["Phone3"].ToString();
										currentModel.Email1 = dr["Email1"].ToString();
										currentModel.Email2 = dr["Email2"].ToString();
										currentModel.Email3 = dr["Email3"].ToString();

										currentModel.DateLost = (DateTime) dr["DateLost"];
										currentModel.DateCreated = (DateTime)dr["DateCreated"];

										searchResponseListModel.individualList.Add(currentModel);
									}
								}
								output = searchResponseListModel;
								break;

							case "ReportFilters":
								ReportFilterResponseModel modelr = new ReportFilterResponseModel();
								using (SqlDataReader dr = cm.ExecuteReader())
								{
									while (dr.Read())
									{
										modelr.CountryList.Add(new ReportFilterResponseCountryModel(
											(int)dr["ID"],
											dr["PrintableName"].ToString(),
											dr["ISOCode3"].ToString()
											));
									}

									dr.NextResult();

									while (dr.Read())
									{
										modelr.StateList.Add(new ReportFilterResponseStateModel(
											(int)dr["ID"],
											dr["Name"].ToString(),
											dr["Abbreviation"].ToString()
											));
									}

									dr.NextResult();

									while (dr.Read())
									{
										modelr.EyeColorList.Add(new ReportFilterResponseEyeColorModel(
											(int)dr["ID"],
											dr["Color"].ToString()
											));
									}

									dr.NextResult();

									while (dr.Read())
									{
										modelr.HairColorList.Add(new ReportFilterResponseHairColorModel(
											(int)dr["ID"],
											dr["Color"].ToString()
											));
									}

									dr.NextResult();

									while (dr.Read())
									{
										modelr.EthnicityList.Add(new ReportFilterResponseEthnicityModel(
											(int)dr["ID"],
											dr["Name"].ToString()
											));
									}
								}

								output = modelr;
								break;
							case "ForumTopics":
								ForumTopicListModel modelt = new ForumTopicListModel();
								using (SqlDataReader dr = cm.ExecuteReader())
								{
									while (dr.Read())
									{
										modelt.ForumTopics.Add(new ForumTopicModel(
											(int)dr["ID"],
											dr["Topic"].ToString(),
											(DateTime)dr["DateCreated"],
											(int)dr["DateCreatedBy"],
                                            dr["DateCreatedByName"].ToString(),
                                            (DateTime)dr["DateUpdated"],
                                            (int)dr["DateUpdatedBy"],
											dr["DateUpdatedByName"].ToString(),
											(int)dr["PostCount"]
                                        ));
									}
								}
								output = modelt;
                                break;
                            case "ForumTopicPosts":
                                ForumPostListModel modelp = new ForumPostListModel();
                                using (SqlDataReader dr = cm.ExecuteReader())
                                {
                                    while (dr.Read())
                                    {
                                        modelp.ForumPosts.Add(new ForumPostModel(
                                            (int)dr["ID"],
											(int)dr["ForumTopicId"],
                                            dr["Post"].ToString(),
                                            (DateTime)dr["DateCreated"],
                                            (int)dr["DateCreatedBy"],
                                            dr["DateCreatedByName"].ToString(),
                                            (DateTime)dr["DateUpdated"],
                                            (int)dr["DateUpdatedBy"],
                                            dr["DateUpdatedByName"].ToString(),
											dr["Topic"].ToString()
                                        ));
                                    }
                                }
                                output = modelp;
                                break;
                            default:
								output = new DBContextResponseDefaultModel("Unknown Mode", "switch statement line 223");
								break;
						}

						transaction.Commit();
						log.LogInformation($"Successfully Executed Procedure: {procedure}");
					}
					cn.Close();
				}
				catch (Exception exception)
				{
					log.LogInformation(exception.Message + " " + procedure, parameters);
					log.LogInformation(exception.StackTrace);

					if (transaction != null) transaction.Rollback();
					if (cn.State != ConnectionState.Closed) cn.Close();

					return new DBContextResponseDefaultModel(exception.Message, exception.StackTrace);
				}

				return output;
			}
		}
	}
}
