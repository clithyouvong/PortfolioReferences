using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using SNHU.IT700.Functions.Models;
using static SNHU.IT700.Functions.Contexts.DBContext;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using Microsoft.Extensions.Configuration;
using SNHU.IT700.Functions.Services;

namespace SNHU.IT700.Functions
{
    public class PostReportResults
	{
		private readonly IConfigurationRoot _configuration;
		private readonly IDbContextFactory _dbContext;
		private readonly IBodyAsExtractorService _extractorService;

		public PostReportResults(IConfigurationRoot configuration, IDbContextFactory dbContextFactory, IBodyAsExtractorService bodyAsExtractorService)
		{
			_dbContext = dbContextFactory;
			_configuration = configuration;
			_extractorService = bodyAsExtractorService;
		}

		[FunctionName("PostReportResults")]
        public async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = null)] HttpRequest req,
            ILogger log)
		{
			try
			{
				// Get Data
				ReportRequestModel model = await _extractorService.GetReportRequestModelBody(req);

				if (model == null)
					throw new Exception();

				List<SqlParameter> parameters = new List<SqlParameter>()
				{
					new SqlParameter("@FirstName", SqlDbType.VarChar) {Value = model.FirstName},
					new SqlParameter("@LastName", SqlDbType.VarChar) {Value = model.LastName},
					new SqlParameter("@City", SqlDbType.VarChar) {Value = model.City},
					new SqlParameter("@Description", SqlDbType.VarChar) {Value = model.Description},
					new SqlParameter("@Phone1", SqlDbType.VarChar) {Value = model.Phone1},
					new SqlParameter("@Phone2", SqlDbType.VarChar) {Value = model.Phone2},
					new SqlParameter("@Phone3", SqlDbType.VarChar) {Value = model.Phone3},
					new SqlParameter("@Email1", SqlDbType.VarChar) {Value = model.Email1},
					new SqlParameter("@Email2", SqlDbType.VarChar) {Value = model.Email2},
					new SqlParameter("@Email3", SqlDbType.VarChar) {Value = model.Email3},
				};

				parameters.Add(new SqlParameter("@Age", SqlDbType.Int) { Value = (model.Age > 0) ? model.Age : 1 });
				
				if (model.StateId > 0) parameters.Add(new SqlParameter("@StateId", SqlDbType.Int) { Value = model.StateId });
				if (model.CountryId > 0) parameters.Add(new SqlParameter("@CountryId", SqlDbType.Int) { Value = model.CountryId });
				if (model.GenderId > 0) parameters.Add(new SqlParameter("@GenderId", SqlDbType.Int) { Value = model.GenderId });
				if (model.EthnicityId > 0) parameters.Add(new SqlParameter("@EthnicityId", SqlDbType.Int) { Value = model.EthnicityId });
				if (model.HairColorId > 0) parameters.Add(new SqlParameter("@HairColorId", SqlDbType.Int) { Value = model.HairColorId });
				if (model.EyeColorId > 0) parameters.Add(new SqlParameter("@EyeColorId", SqlDbType.Int) { Value = model.EyeColorId });
				if (model.DateLost > DateTime.Parse("1900-01-01")) parameters.Add(new SqlParameter("@DateLost", SqlDbType.DateTime) { Value = model.DateLost });

				var context = _dbContext.GetDbContext(_configuration["SQL-ConnectionString"]);
				context.ExecuteStoredProcedure(log, _configuration["SQL-ReportSubmit"], parameters);

				return new OkObjectResult("OK");
			}catch(Exception ex)
			{
				return new BadRequestObjectResult(ex.Message);
			}

        }
    }
}
