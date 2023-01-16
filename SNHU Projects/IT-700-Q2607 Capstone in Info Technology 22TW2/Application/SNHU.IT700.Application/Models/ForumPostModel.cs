using SNHU.IT700.Application.Services;

namespace SNHU.IT700.Application.Models
{
    public class ForumPostModel : CustomEventGridEvent.CustomEventData
	{
        public int Id { get; set; } = 0;
        public int ForumTopicId { get; set; }= 0;
        public string Post { get; set; } = "";
        public DateTime DateCreated { get; set; } = DateTime.Parse("1900-01-01");
        public int DateCreatedBy { get; set; }
        public string DateCreatedByName { get; set; } = "";
        public DateTime DateUpdated { get; set; } = DateTime.Parse("1900-01-01");
        public int DateUpdatedBy { get; set; } = 0;
        public string DateUpdatedByName { get; set; } = "";
        public string Topic { get; set; } = "";

        public ForumPostModel() { }
        public ForumPostModel(int id, int forumTopicId, string post, DateTime dateCreated, int dateCreatedBy, string dateCreatedByName, DateTime dateUpdated, int dateUpdatedBy, string dateUpdatedByName, string topic)
        {
            Id = id;
            ForumTopicId = forumTopicId;
            Post = post;
            DateCreated = dateCreated;
            DateCreatedBy = dateCreatedBy;
            DateCreatedByName = dateCreatedByName;
            DateUpdated = dateUpdated;
            DateUpdatedBy = dateUpdatedBy;
            DateUpdatedByName = dateUpdatedByName;
            Topic = topic;
        }
    }
}
