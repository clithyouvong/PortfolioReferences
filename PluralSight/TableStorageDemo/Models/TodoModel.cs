using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace TableStorageDemo.Models
{
    public class TodoModel
    {
        public string Id { get; set; }
        public string Group { get; set; }
        public string Content { get; set; }
        public string DueDate { get; set; }
        public bool Completed { get; set; }

        public DateTimeOffset Timestamp { get; set; }
        public DateTime? CompletedDate { get; set; }
    }
}
