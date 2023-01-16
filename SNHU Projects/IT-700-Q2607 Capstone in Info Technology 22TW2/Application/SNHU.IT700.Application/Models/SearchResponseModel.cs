namespace SNHU.IT700.Application.Models
{
	public class SearchResponseModel
	{
		public int IndividualId { get; set; } = 0;
		public int IndividualStatusId { get; set; } = 0;
		public string IndividualStatus { get; set; } = "";
		public string FirstName { get; set; } = "";
		public string LastName { get; set; } = "";
		public string City { get; set; } = "";
		public int StateId { get; set; } = 0;
		public string State { get; set; } = "";
		public string StateAbbreviation { get; set; } = "";
		public int CountryId { get; set; } = 0;
		public string Country { get; set; } = "";
		public string CountryAbbreviation { get; set; } = "";
		public int GenderId { get; set; } = 0;
		public string Gender { get; set; } = "";
		public int EthnicityId { get; set; } = 0;
		public string Ethnicity { get; set; } = "";
		public int HairColorId { get; set; } = 0;
		public string HairColor { get; set; } = "";
		public int EyeColorId { get; set; } = 0;
		public string EyeColor { get; set; } = "";
		public string Description { get; set; } = "";
		public int Age { get; set; } = 0;
		public string Phone1 { get; set; } = "";
		public string Phone2 { get; set; } = "";
		public string Phone3 { get; set; } = "";
		public string Email1 { get; set; } = "";
		public string Email2 { get; set; } = "";
		public string Email3 { get; set; } = "";
		public DateTime DateLost { get; set; } = DateTime.MinValue;
		public DateTime DateCreated { get; set; } = DateTime.MinValue;
	}
}
