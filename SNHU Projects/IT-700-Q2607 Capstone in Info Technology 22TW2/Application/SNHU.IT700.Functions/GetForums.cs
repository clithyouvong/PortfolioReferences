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

namespace SNHU.IT700.Functions
{
    public class GetForums
    {
        private readonly IConfigurationRoot _configuration;
        private readonly IDbContextFactory _dbContext;
        private readonly IBodyAsExtractorService _extractorService;

        public GetForums(IConfigurationRoot configuration, IDbContextFactory dbContextFactory, IBodyAsExtractorService bodyAsExtractorService)
        {
            _dbContext = dbContextFactory;
            _configuration = configuration;
            _extractorService = bodyAsExtractorService;
        }

        [FunctionName("GetForums")]
        public IActionResult Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            var context = _dbContext.GetDbContext(_configuration["SQL-ConnectionString"]);
            IDBContextResponse response = context.ExecuteStoredProcedure(log, _configuration["SQL-ForumTopics"], new List<SqlParameter>(), "ForumTopics");

            ForumTopicListModel responseModel = (ForumTopicListModel)response;

            return new OkObjectResult(responseModel.ForumTopics);
        }
    }
}
