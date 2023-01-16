using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Microsoft.Extensions.Configuration;
using static SNHU.IT700.Functions.Contexts.DBContext;
using SNHU.IT700.Functions.Services;
using SNHU.IT700.Functions.Models;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;

namespace SNHU.IT700.Functions
{
    public class GetSearchResults
	{
		private readonly IConfigurationRoot _configuration;
		private readonly IDbContextFactory _dbContext;
		private readonly IBodyAsExtractorService _extractorService;

		public GetSearchResults(IConfigurationRoot configuration, IDbContextFactory dbContextFactory, IBodyAsExtractorService bodyAsExtractorService)
		{
			_dbContext = dbContextFactory;
			_configuration = configuration;
			_extractorService = bodyAsExtractorService;
		}

		[FunctionName("GetSearchResults")]
        public async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            ILogger log)
		{
			log.LogInformation("C# HTTP trigger function processed a request.");

			// Get Data
			SearchRequestModel model = await _extractorService.GetSearchRequestModelBody(req);

			if (model == null)
				throw new Exception();

			List<SqlParameter> parameters = new List<SqlParameter>()
			{
				new SqlParameter("@FirstName", SqlDbType.VarChar) {Value = model.FirstName},
				new SqlParameter("@LastName", SqlDbType.VarChar) {Value = model.LastName},
				new SqlParameter("@City", SqlDbType.VarChar) {Value = model.City},
				new SqlParameter("@StateId", SqlDbType.Int) {Value = model.StateId},
				new SqlParameter("@CountryId", SqlDbType.Int) {Value = model.CountryId},
				new SqlParameter("@DateLostStart", SqlDbType.DateTime) {Value = model.DateLostStart},
				new SqlParameter("@DateLostEnd", SqlDbType.DateTime) {Value = model.DateLostEnd},
				new SqlParameter("@AgeStart", SqlDbType.Int) {Value = model.AgeStart},
				new SqlParameter("@AgeEnd", SqlDbType.Int) {Value = model.AgeEnd},
				new SqlParameter("@GenderId", SqlDbType.Int) {Value = model.GenderId},
				new SqlParameter("@EthnicityId", SqlDbType.Int) {Value = model.EthnicityId},
				new SqlParameter("@HairColorId", SqlDbType.Int) {Value = model.HairColorId},
				new SqlParameter("@EyeColorId", SqlDbType.Int) {Value = model.EyeColorId},
			};

			var context = _dbContext.GetDbContext(_configuration["SQL-ConnectionString"]);
			IDBContextResponse response = context.ExecuteStoredProcedure(log, _configuration["SQL-SearchScreenSearch"], parameters, "SearchResult");

			SearchResponseListModel responseModel = (SearchResponseListModel)response;

			return new OkObjectResult(responseModel.individualList);
        }
    }
}
