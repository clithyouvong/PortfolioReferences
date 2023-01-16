using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SNHU.IT700.Functions.Models
{
	public class SearchRequestModel
	{
		public string FirstName { get; set; } = "";
		public string LastName { get; set; } = "";
		public string City { get; set; } = "";
		public int StateId { get; set; } = 0;
		public int CountryId { get; set; } = 0;
		public DateTime DateLostStart { get; set; } = DateTime.Parse("1900-01-01");
		public DateTime DateLostEnd { get; set; } = DateTime.Parse("1900-01-01");
		public int AgeStart { get; set; } = 0;
		public int AgeEnd { get; set; } = 0;
		public int GenderId { get; set; } = 0;
		public int EthnicityId { get; set; } = 0;
		public int HairColorId { get; set; } = 0;
		public int EyeColorId { get; set; } = 0;
	}
}
