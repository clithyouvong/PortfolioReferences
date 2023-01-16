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
using Microsoft.Extensions.Configuration;
using System.Linq;

namespace SNHU.IT700.Functions
{
    public class GetForumPosts
    {
        private readonly IConfigurationRoot _configuration;
        private readonly IDbContextFactory _dbContext;

        public GetForumPosts(IConfigurationRoot configuration, IDbContextFactory dbContextFactory)
        {
            _dbContext = dbContextFactory;
            _configuration = configuration;
        }

        [FunctionName("GetForumPosts")]
        public async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            string id = req.Query["ID"];

            if (!id.Trim().All(Char.IsNumber))
            {
                return new BadRequestObjectResult("ID must be numeric");
            }

            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("@ForumTopicId", System.Data.SqlDbType.Int){Value = Int32.Parse(id.Trim())}
            };

            var context = _dbContext.GetDbContext(_configuration["SQL-ConnectionString"]);
            IDBContextResponse response = context.ExecuteStoredProcedure(log, _configuration["SQL-ForumTopicPosts"], parameters, "ForumTopicPosts");

            ForumPostListModel responseModel = (ForumPostListModel)response;

            return new OkObjectResult(responseModel.ForumPosts);
        }
    }
}
