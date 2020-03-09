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
    public static class Review4
    {
        [FunctionName("Review4")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = "Review4")] HttpRequest req,
            ILogger log)
        {
            string str = Environment.GetEnvironmentVariable("AzureSqlDB");
            log.LogInformation("C# HTTP trigger function processed a request.");

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);


            string point1 =  data.point1;
            string point2 = data.point2;
            string point3 = data.point3;

            try
            {
                using (SqlConnection cn = new SqlConnection(str))
                {
                    cn.Open();
                    using (SqlCommand cm = new SqlCommand("[Workspace].[Review4]", cn))
                    {
                        cm.CommandType = CommandType.StoredProcedure;
                        cm.Parameters.AddWithValue("@point1", point1);
                        cm.Parameters.AddWithValue("@point2", new Guid(point2));
                        cm.Parameters.AddWithValue("@point3", Int32.Parse(point3));
                        cm.ExecuteNonQuery();
                    }

                    cn.Close();
                }
            }
            catch (Exception e)
            {
                return new BadRequestObjectResult(e.Message + e.StackTrace);
            }

            return (ActionResult) new OkObjectResult($"Success");
        }
    }
}
