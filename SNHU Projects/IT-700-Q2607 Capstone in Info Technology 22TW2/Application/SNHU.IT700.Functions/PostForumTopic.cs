// Default URL for triggering event grid function in the local environment.
// http://localhost:7071/runtime/webhooks/EventGrid?functionName={functionname}
using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.EventGrid;
using Microsoft.Extensions.Logging;
using Azure.Messaging.EventGrid;
using Microsoft.Extensions.Configuration;
using static SNHU.IT700.Functions.Contexts.DBContext;
using SNHU.IT700.Functions.Services;
using SNHU.IT700.Functions.Models;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;

namespace SNHU.IT700.Functions
{
    public class PostForumTopic
    {
        private readonly IConfigurationRoot _configuration;
        private readonly IDbContextFactory _dbContext;
        private readonly IBodyAsExtractorService _extractorService;

        public PostForumTopic(IConfigurationRoot configuration, IDbContextFactory dbContextFactory, IBodyAsExtractorService bodyAsExtractorService)
        {
            _dbContext = dbContextFactory;
            _configuration = configuration;
            _extractorService = bodyAsExtractorService;
        }

        [FunctionName("PostForumTopic")]
        public void Run([EventGridTrigger]EventGridEvent eventGridEvent, ILogger log)
        {
            // Get Data
            ForumTopicModel model = _extractorService.GetForumTopicBody(eventGridEvent.Data);

            if (model == null)
                throw new Exception();

            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("@Topic", SqlDbType.VarChar) {Value = model.Topic},
                new SqlParameter("@DateCreatedBy", SqlDbType.Int) {Value = model.DateCreatedBy},
                new SqlParameter("@DateCreatedByName", SqlDbType.VarChar) {Value = model.DateCreatedByName}
            };

            var context = _dbContext.GetDbContext(_configuration["SQL-ConnectionString"]);
            context.ExecuteStoredProcedure(log, _configuration["SQL-PostForumTopic"], parameters);

        }
    }
}