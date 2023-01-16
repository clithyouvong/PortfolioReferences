using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static SNHU.IT700.Functions.Contexts.DBContext;

namespace SNHU.IT700.Functions.Models
{
    public class ForumPostListModel : IDBContextResponse
    {
        public List<ForumPostModel> ForumPosts { get; set; } = new List<ForumPostModel>();
    }
}
