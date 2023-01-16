using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RestSharp;
using SNHU.IT700.Application.Models;
using SNHU.IT700.Application.Services;

namespace SNHU.IT700.Application.Controllers
{
	[Authorize]
	public class ReportController : Controller
	{
		private readonly ILogger<SearchController> _logger;
		private readonly IConfigurationRoot _configuration;
		private readonly IBodyAsExtractorService _extractorService;

		public ReportController(ILogger<SearchController> logger, IConfigurationRoot configurationRoot, IBodyAsExtractorService bodyAsExtractorService)
		{
			_logger = logger;
			_configuration = configurationRoot;
			_extractorService = bodyAsExtractorService;
		}

		public async Task<IActionResult> Create()
		{
			ReportFilterModel model = await BindReportFilterModel();

			return View(model);
		}

		private async Task<ReportFilterModel> BindReportFilterModel()
		{
			ViewData["ReCaptchaKey"] = _configuration["ReCaptchaKey"];
			ReportFilterModel model = await GetReportFilters();

			//fill age 
			model.Age.Clear();
			for (int i = 1; i < 100; i++)
			{
				model.Age.Add(i);
			}

			return model;
		}


		[HttpPost]
		public async Task<IActionResult> Submit(IFormCollection collection)
		{
			string message = "";

			try
			{
				ReportRequestModel requestModel = new ReportRequestModel();
				requestModel.FirstName = collection["FirstName"].ToString().Trim();
				requestModel.LastName = collection["LastName"].ToString().Trim();
				requestModel.City = collection["City"].ToString().Trim();
				requestModel.StateId = Int32.Parse(collection["State"].ToString().Trim());
				requestModel.CountryId = Int32.Parse(collection["Country"].ToString().Trim());
				requestModel.DateLost =
					collection["DateLost"].ToString().Trim().Equals("")
						? DateTime.Parse("1900-01-01")
						: DateTime.Parse(collection["DateLost"].ToString().Trim());
				requestModel.Age = Int32.Parse(collection["Age"].ToString().Trim());
				requestModel.GenderId = Int32.Parse(collection["GenderRadios"].ToString().Trim());
				requestModel.EthnicityId = Int32.Parse(collection["Ethnicity"].ToString().Trim());
				requestModel.HairColorId = Int32.Parse(collection["HairColor"].ToString().Trim());
				requestModel.EyeColorId = Int32.Parse(collection["EyeColor"].ToString().Trim());
				requestModel.Phone1 = collection["Phone1"].ToString().Trim();
				requestModel.Phone2 = collection["Phone2"].ToString().Trim();
				requestModel.Phone3 = collection["Phone3"].ToString().Trim();
				requestModel.Email1 = collection["Email1"].ToString().Trim();
				requestModel.Email2 = collection["Email2"].ToString().Trim();
				requestModel.Email3 = collection["Email3"].ToString().Trim();
				requestModel.Description = collection["Description"].ToString().Trim();

				await PostReportResult(requestModel);

				message = "<div class=\"alert alert-success\" role=\"alert\">Submission Successful! We hope to find your love ones soon!</div>";
			}
			catch (Exception e)
			{
				message = "<div class=\"alert alert-warning\" role=\"alert\">Submission Failed! " + e.Message + "</div>";
			}

			ViewData["Message"] = message;


			ReportFilterModel model = await BindReportFilterModel();

			return View("Create", model);
		}


		private async Task<ReportFilterModel> GetReportFilters()
		{
			return await new RestClient(_configuration["API-GetReportFilters"] ?? "")
				.GetAsync<ReportFilterModel>(new RestRequest()) ?? new ReportFilterModel();
		}


		private async Task PostReportResult(ReportRequestModel model)
		{
			string url = _configuration["API-PostReportResults"] ?? "";

			var request = new RestRequest(url, Method.Post);
			request.RequestFormat = DataFormat.Json;
			request.AddBody(model);
			var client = new RestClient(url);
			var response = await client.ExecuteAsync(request);
		}
	}
}
