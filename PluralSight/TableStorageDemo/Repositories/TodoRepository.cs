
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Azure.Cosmos.Table;

namespace TableStorageDemo.Repositories
{
    public class TodoRepository
    {
        public IConfiguration Configuration { get; }
        public CloudTable todoTable;

        public TodoRepository(IConfiguration configuration)
        {
            Configuration = configuration;

            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(Configuration.GetConnectionString("assets"));

            var tableClient = storageAccount.CreateCloudTableClient();

            todoTable = tableClient.GetTableReference("Todo");

            var sas = todoTable.GetSharedAccessSignature(new SharedAccessTablePolicy
            {
                Permissions = SharedAccessTablePermissions.Query,
                SharedAccessStartTime = DateTime.Now.AddDays(-1),
                SharedAccessExpiryTime = DateTime.Now.AddDays(2)
            });

        }
        public IEnumerable<TodoEntity> All()
        {
            //var isCompleted = TableQuery.GenerateFilterConditionForBool(nameof(TodoEntity.Completed), QueryComparisons.Equal, false);
            var isVacation = TableQuery.GenerateFilterCondition(nameof(TodoEntity.PartitionKey), QueryComparisons.Equal, "Vacation");


            //var query = new TableQuery<TodoEntity>()
            //    .Where(TableQuery.CombineFilters(isCompleted, TableOperators.And, isVacation));
            var query = new TableQuery<TodoEntity>();

            var entities = todoTable.ExecuteQuery(query);

            return entities;
        }

        public void CreateOrUpdate(TodoEntity entity)
        {
            var operation = TableOperation.InsertOrReplace(entity);
            todoTable.Execute(operation);
        }
        public void Delete(TodoEntity entity)
        {
            var operation = TableOperation.Delete(entity);
            todoTable.Execute(operation);
        }

        public TodoEntity Get(string partitionKey, string rowKey)
        {
            var operation = TableOperation.Retrieve<TodoEntity>(partitionKey, rowKey);
            var result = todoTable.Execute(operation);
            return result.Result as TodoEntity ;
        }

        public class TodoEntity : TableEntity
        {
            public string Id { get; set; }
            public string Group { get; set; }
            public string Content { get; set; }
            public string DueDate { get; set; }
            public bool Completed { get; set; }

            public DateTime? CompletedDate { get; set; }
        }

    }
}
