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
    public static class Review3
    {
        [FunctionName("Review3")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = "Review3/ID/{ID}/Mode/{Mode}")] HttpRequest req,
            string ID,
            string Mode,
            ILogger log)
        {
            string str = Environment.GetEnvironmentVariable("AzureSqlDB");
            log.LogInformation("C# HTTP trigger function processed a request.");

            DataTable dt = new DataTable();
            using (SqlConnection cn = new SqlConnection(str))
            {
                cn.Open();
                using (SqlCommand cm = new SqlCommand("[Workspace].[Review3]", cn))
                {
                    cm.CommandType = CommandType.StoredProcedure;
                    cm.Parameters.AddWithValue("@ID", ID);
                    cm.Parameters.AddWithValue("@Mode", Mode);
                    using (SqlDataAdapter da = new SqlDataAdapter(cm))
                    {
                        da.Fill(dt);
                    }
                }

                cn.Close();
            }

            log.LogInformation($"output: {JsonConvert.SerializeObject(dt)}");

            return dt != new DataTable()
                ? (ActionResult)new OkObjectResult(dt)
                : new BadRequestObjectResult("StudentUsername/courseCode is required on the query string");
        }
    }
}
