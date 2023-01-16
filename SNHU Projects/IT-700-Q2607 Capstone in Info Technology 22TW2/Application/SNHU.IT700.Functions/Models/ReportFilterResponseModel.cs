using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static SNHU.IT700.Functions.Contexts.DBContext;

namespace SNHU.IT700.Functions.Models
{
	public class ReportFilterResponseModel : IDBContextResponse
	{
		public List<ReportFilterResponseCountryModel> CountryList { get; set; } = new List<ReportFilterResponseCountryModel>();
		public List<ReportFilterResponseStateModel> StateList { get; set; } = new List<ReportFilterResponseStateModel>();
		public List<ReportFilterResponseEyeColorModel> EyeColorList { get; set; } = new List<ReportFilterResponseEyeColorModel>();
		public List<ReportFilterResponseHairColorModel> HairColorList { get; set; } = new List<ReportFilterResponseHairColorModel>();
		public List<ReportFilterResponseEthnicityModel> EthnicityList { get; set; } = new List<ReportFilterResponseEthnicityModel>();

	}

	public class ReportFilterResponseCountryModel
	{
		public int ID { get; set; }
		public string PrintableName { get; set; }
		public string ISOCode3 { get; set; }
		public ReportFilterResponseCountryModel(int iD, string printableName, string iSOCode3)
		{
			ID = iD;
			PrintableName = printableName;
			ISOCode3 = iSOCode3;
		}
	}
	public class ReportFilterResponseStateModel
	{
		public int ID { get; set; }
		public string Name { get; set; }
		public string Abbreviation { get; set; }
		public ReportFilterResponseStateModel(int iD, string name, string abbreviation)
		{
			ID = iD;
			Name = name;
			Abbreviation = abbreviation;
		}
	}
	public class ReportFilterResponseEyeColorModel
	{
		public int ID { get; set; }
		public string Color { get; set; }
		public ReportFilterResponseEyeColorModel(int iD, string color)
		{
			ID = iD;
			Color = color;
		}
	}
	public class ReportFilterResponseHairColorModel
	{
		public int ID { get; set; }
		public string Color { get; set; }
		public ReportFilterResponseHairColorModel(int iD, string color)
		{
			ID = iD;
			Color = color;
		}
	}
	public class ReportFilterResponseEthnicityModel
	{
		public int ID { get; set; }
		public string Name { get; set; }
		public ReportFilterResponseEthnicityModel(int iD, string name)
		{
			ID = iD;
			Name = name;
		}
	}
}
