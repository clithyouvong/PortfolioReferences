using CosmosDb.DotNetSdk.Demos;
using CosmosDb.ServerSide.Demos;
using Microsoft.Azure.Cosmos;
using Microsoft.Extensions.Configuration;
using System;
using System.Threading.Tasks;

namespace CosmosDBDemo
{
    class Program
    {
        static void Main(string[] args)
        {
            StoredProceduresDemo.Run().Wait();
            //ContainersDemo.Run().Wait();
            //QueryforDocuments().Wait();
        }

        private static async Task QueryforDocuments()
        {
            var config = new ConfigurationBuilder().AddJsonFile("appSettings.json").Build();
            var endpoint = config["CosmosEndpoint"];
            var masterKey = config["CosmosMasterKey"];


            using (var client = new CosmosClient(endpoint, masterKey))
            {
                var container = client.GetContainer("Families", "Families");
                var sql = "Select * From c Where Array_length(c.kids) > 0";

                var iterator = container.GetItemQueryIterator<dynamic>(sql);

                var page = await iterator.ReadNextAsync();

                foreach(var doc in page)
                {
                    Console.WriteLine($"Family {doc.id} has {doc.kids.Count} children");
                }
                Console.ReadLine();
            }
        }
    }
}
