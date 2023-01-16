using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static SNHU.IT700.Functions.Contexts.DBContext;

namespace SNHU.IT700.Functions.Models
{
    public class ForumTopicListModel : IDBContextResponse
    {
        public List<ForumTopicModel> ForumTopics { get; set; } = new List<ForumTopicModel>();
    }
}
