using Microsoft.AspNetCore.Identity;

namespace SNHU.IT700.Application.Data
{
    public class ApplicationUser : IdentityUser
    {
        public int IndividualId { get; set; }
    }
}
