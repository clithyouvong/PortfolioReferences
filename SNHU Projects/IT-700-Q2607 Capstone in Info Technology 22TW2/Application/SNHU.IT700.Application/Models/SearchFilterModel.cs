namespace SNHU.IT700.Application.Models
{
	public class SearchFilterModel
	{
		public List<SearchFilterCountryModel> CountryList { get; set; } = new List<SearchFilterCountryModel>();
		public List<SearchFilterStateModel> StateList { get; set; } = new List<SearchFilterStateModel>();
		public List<SearchFilterEyeColorModel> EyeColorList { get; set; } = new List<SearchFilterEyeColorModel>();
		public List<SearchFilterHairColorModel> HairColorList { get; set; } = new List<SearchFilterHairColorModel>();
		public List<SearchFilterEthnicityModel> EthnicityList { get; set; } = new List<SearchFilterEthnicityModel>();

		public List<int> Age { get; set; } = new List<int>();

	}
	public class SearchFilterCountryModel
	{
		public int ID { get; set; }
		public string PrintableName { get; set; }
		public string ISOCode3 { get; set; }
		public SearchFilterCountryModel(int iD, string printableName, string iSOCode3)
		{
			ID = iD;
			PrintableName = printableName;
			ISOCode3 = iSOCode3;
		}
	}
	public class SearchFilterStateModel
	{
		public int ID { get; set; }
		public string Name { get; set; }
		public string Abbreviation { get; set; }
		public SearchFilterStateModel(int iD, string name, string abbreviation)
		{
			ID = iD;
			Name = name;
			Abbreviation = abbreviation;
		}
	}
	public class SearchFilterEyeColorModel
	{
		public int ID { get; set; }
		public string Color { get; set; }
		public SearchFilterEyeColorModel(int iD, string color)
		{
			ID = iD;
			Color = color;
		}
	}
	public class SearchFilterHairColorModel
	{
		public int ID { get; set; }
		public string Color { get; set; }
		public SearchFilterHairColorModel(int iD, string color)
		{
			ID = iD;
			Color = color;
		}
	}
	public class SearchFilterEthnicityModel
	{
		public int ID { get; set; }
		public string Name { get; set; }
		public SearchFilterEthnicityModel(int iD, string name)
		{
			ID = iD;
			Name = name;
		}
	}
}
