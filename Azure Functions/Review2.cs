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
    public static class Review2
    {
        [FunctionName("Review2")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = "Review2/ID/{ID}/Mode/{Mode}")] HttpRequest req,
            string ID,
            string Mode,
            ILogger log)
        {
            string validMessage = "Success";
            bool isValid = true;
            string str = Environment.GetEnvironmentVariable("AzureSqlDB");
            log.LogInformation("C# HTTP trigger function processed a request.");
            log.LogInformation($"ID: {ID}, Mode: {Mode}");


            try
            {
                DataTable dt = new DataTable();
                using (SqlConnection cn = new SqlConnection(str))
                {
                    cn.Open();
                    using (SqlCommand cm = new SqlCommand("[Workspace].[Review2]", cn))
                    {
                        cm.CommandType = CommandType.StoredProcedure;
                        cm.Parameters.AddWithValue("@ID", Int32.Parse(ID));
                        cm.Parameters.AddWithValue("@Mode", Int32.Parse(Mode));
                        using (SqlDataAdapter da = new SqlDataAdapter(cm))
                        {
                            da.Fill(dt);
                        }
                    }
                    cn.Close();
                }
            }
            catch (Exception e)
            {
                validMessage = 
                    e.Message.Contains("UNIQUE KEY") 
                        ? "Invalid, User already exists with this override"
                        : "Invalid, " + e.Message;

                
                isValid = false;
            }
            
            return isValid 
                ? (ActionResult)new OkObjectResult(validMessage)
                : new BadRequestObjectResult(validMessage);
        }
    }
}
