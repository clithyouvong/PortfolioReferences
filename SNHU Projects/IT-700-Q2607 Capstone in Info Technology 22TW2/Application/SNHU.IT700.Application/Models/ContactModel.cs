using SNHU.IT700.Application.Services;

namespace SNHU.IT700.Application.Models
{
    public class ContactModel : CustomEventGridEvent.CustomEventData
    {
        public string NameOfSubmitter { get; set; } = "";
        public string NameOfLostIndividual { get; set; } = "";
        public string LastKnownLocation { get; set; } = "";
        public string Description { get; set; } = "";
        public string EmailAddress { get; set; } = "";
        public string PhoneNumber { get; set; } = "";
    }
}