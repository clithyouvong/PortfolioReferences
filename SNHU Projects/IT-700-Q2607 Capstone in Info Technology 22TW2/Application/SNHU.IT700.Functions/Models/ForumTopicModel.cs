using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SNHU.IT700.Functions.Models
{
    public class ForumTopicModel
    {
        public int Id { get; set; } = 0;
        public string Topic { get; set; } = "";
        public DateTime DateCreated { get; set; } = DateTime.Parse("1900-01-01");
        public int DateCreatedBy { get; set; }
        public string DateCreatedByName { get; set; } = "";
        public DateTime DateUpdated { get; set; } = DateTime.Parse("1900-01-01");
        public int DateUpdatedBy { get; set; } = 0;
        public string DateUpdatedByName { get; set; } = "";
        public int PostCount { get; set; } = 0;
        public ForumTopicModel() { }
        public ForumTopicModel(int id, string topic, int dateCreatedBy)
        {
            Id = id;
            Topic = topic;
            DateCreatedBy = dateCreatedBy;
        }
        public ForumTopicModel(int id, string topic, DateTime dateCreated, int dateCreatedBy, string dateCreatedByName, DateTime dateUpdated, int dateUpdatedBy, string dateUpdatedByName, int postCount)
        {
            Id = id;
            Topic = topic;
            DateCreated = dateCreated;
            DateCreatedBy = dateCreatedBy;
            DateCreatedByName = dateCreatedByName;
            DateUpdated = dateUpdated;
            DateUpdatedBy = dateUpdatedBy;
            DateUpdatedByName = dateUpdatedByName;
            PostCount = postCount;
        }
    }
}
