namespace SNHU.IT700.Application.Models
{
	public class ReportFilterModel
	{
		public List<ReportFilterCountryModel> CountryList { get; set; } = new List<ReportFilterCountryModel>();
		public List<ReportFilterStateModel> StateList { get; set; } = new List<ReportFilterStateModel>();
		public List<ReportFilterEyeColorModel> EyeColorList { get; set; } = new List<ReportFilterEyeColorModel>();
		public List<ReportFilterHairColorModel> HairColorList { get; set; } = new List<ReportFilterHairColorModel>();
		public List<ReportFilterEthnicityModel> EthnicityList { get; set; } = new List<ReportFilterEthnicityModel>();

		public List<int> Age { get; set; } = new List<int>();

	}
	public class ReportFilterCountryModel
	{
		public int ID { get; set; }
		public string PrintableName { get; set; }
		public string ISOCode3 { get; set; }
		public ReportFilterCountryModel(int iD, string printableName, string iSOCode3)
		{
			ID = iD;
			PrintableName = printableName;
			ISOCode3 = iSOCode3;
		}
	}
	public class ReportFilterStateModel
	{
		public int ID { get; set; }
		public string Name { get; set; }
		public string Abbreviation { get; set; }
		public ReportFilterStateModel(int iD, string name, string abbreviation)
		{
			ID = iD;
			Name = name;
			Abbreviation = abbreviation;
		}
	}
	public class ReportFilterEyeColorModel
	{
		public int ID { get; set; }
		public string Color { get; set; }
		public ReportFilterEyeColorModel(int iD, string color)
		{
			ID = iD;
			Color = color;
		}
	}
	public class ReportFilterHairColorModel
	{
		public int ID { get; set; }
		public string Color { get; set; }
		public ReportFilterHairColorModel(int iD, string color)
		{
			ID = iD;
			Color = color;
		}
	}
	public class ReportFilterEthnicityModel
	{
		public int ID { get; set; }
		public string Name { get; set; }
		public ReportFilterEthnicityModel(int iD, string name)
		{
			ID = iD;
			Name = name;
		}
	}
}
