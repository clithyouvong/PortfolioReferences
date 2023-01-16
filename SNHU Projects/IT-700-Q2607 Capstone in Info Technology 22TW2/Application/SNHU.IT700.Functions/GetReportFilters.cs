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
using System.Data.SqlClient;
using System.Collections.Generic;
using SNHU.IT700.Functions.Models;

namespace SNHU.IT700.Functions
{
    public class GetReportFilters
    {
        private readonly IConfigurationRoot _configuration;
        private readonly IDbContextFactory _dbContext;

        public GetReportFilters(IConfigurationRoot configuration, IDbContextFactory dbContextFactory)
        {
            _dbContext= dbContextFactory;
            _configuration= configuration;
        }

        [FunctionName("GetReportFilters")]
        public IActionResult Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            var context = _dbContext.GetDbContext(_configuration["SQL-ConnectionString"]);
            IDBContextResponse response = context.ExecuteStoredProcedure(log, _configuration["SQL-ReportScreenLoad"], new List<SqlParameter>(), "ReportFilters");

            ReportFilterResponseModel responseModel = (ReportFilterResponseModel)response;

            return new OkObjectResult(responseModel);
        }
    }
}
