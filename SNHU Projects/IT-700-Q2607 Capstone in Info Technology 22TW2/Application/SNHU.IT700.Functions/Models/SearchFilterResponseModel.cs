using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static SNHU.IT700.Functions.Contexts.DBContext;

namespace SNHU.IT700.Functions.Models
{
	public class SearchFilterResponseModel : IDBContextResponse
	{
		public List<SearchFilterResponseCountryModel> CountryList { get; set; } = new List<SearchFilterResponseCountryModel>();
		public List<SearchFilterResponseStateModel> StateList { get; set; } = new List<SearchFilterResponseStateModel>();
		public List<SearchFilterResponseEyeColorModel> EyeColorList { get; set; } = new List<SearchFilterResponseEyeColorModel>();
		public List<SearchFilterResponseHairColorModel> HairColorList { get; set; } = new List<SearchFilterResponseHairColorModel>();
		public List<SearchFilterResponseEthnicityModel> EthnicityList { get; set; } = new List<SearchFilterResponseEthnicityModel>();

	}

	public class SearchFilterResponseCountryModel
	{
		public int ID { get; set; }
		public string PrintableName { get; set; }
		public string ISOCode3 { get; set; }
		public SearchFilterResponseCountryModel(int iD, string printableName, string iSOCode3)
		{
			ID = iD;
			PrintableName = printableName;
			ISOCode3 = iSOCode3;
		}
	}
	public class SearchFilterResponseStateModel
	{
		public int ID { get; set; }
		public string Name { get; set; }
		public string Abbreviation { get; set; }
		public SearchFilterResponseStateModel(int iD, string name, string abbreviation)
		{
			ID = iD;
			Name = name;
			Abbreviation = abbreviation;
		}
	}
	public class SearchFilterResponseEyeColorModel
	{
		public int ID { get; set; }
		public string Color { get; set; }
		public SearchFilterResponseEyeColorModel(int iD, string color)
		{
			ID = iD;
			Color = color;
		}
	}
	public class SearchFilterResponseHairColorModel
	{
		public int ID { get; set; }
		public string Color { get; set; }
		public SearchFilterResponseHairColorModel(int iD, string color)
		{
			ID = iD;
			Color = color;
		}
	}
	public class SearchFilterResponseEthnicityModel
	{
		public int ID { get; set; }
		public string Name { get; set; }
		public SearchFilterResponseEthnicityModel(int iD, string name)
		{
			ID = iD;
			Name = name;
		}
	}
}
