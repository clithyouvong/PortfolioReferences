using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace func_Review
{
    public static class Review
    {
        [FunctionName("Review")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = "Review/ID/{ID}")] HttpRequest req,
            int studentId,
            ILogger log)
        {
            string str = Environment.GetEnvironmentVariable("AzureSqlDB");
            log.LogInformation("C# HTTP trigger function processed a request.");
            
            try
            {
                using (SqlConnection cn = new SqlConnection(str))
                {
                    cn.Open();
                    using (SqlCommand cm = new SqlCommand("[Workspace].[Review]", cn))
                    {
                        cm.CommandType = CommandType.StoredProcedure;
                        cm.Parameters.AddWithValue("@StudentId", studentId);
                        cm.ExecuteNonQuery();
                    }

                    cn.Close();
                }
            }
            catch (Exception e)
            {
                return new BadRequestObjectResult(e.Message);
            }

            return (ActionResult) new OkObjectResult($"Success");
        }
    }
}
