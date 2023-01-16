using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RestSharp;
using SNHU.IT700.Application.Models;
using SNHU.IT700.Application.Services;
using System.Reflection;
using System.Security.Cryptography.X509Certificates;

namespace SNHU.IT700.Application.Controllers
{
    [Authorize]
    public class SearchController : Controller
    {
        private readonly ILogger<SearchController> _logger;
        private readonly IConfigurationRoot _configuration;
        private readonly IBodyAsExtractorService _extractorService;

		public SearchController(ILogger<SearchController> logger, IConfigurationRoot configurationRoot, IBodyAsExtractorService bodyAsExtractorService) {
            _logger = logger;
            _configuration = configurationRoot;
            _extractorService = bodyAsExtractorService;
        }

        public async Task<IActionResult> Index()
        {
            SearchFilterModel model = await GetSearchFilters();

            //fill age 
            model.Age.Clear();
            for(int i=1; i<100; i++)
            {
                model.Age.Add(i);
            }


            return View(model);
        }


		[HttpPost]
		public async Task<IActionResult> Submit(IFormCollection collection)
		{
            SearchRequestModel requestModel = new SearchRequestModel();
			requestModel.FirstName = collection["FirstName"].ToString().Trim();
			requestModel.LastName = collection["LastName"].ToString().Trim();
			requestModel.City = collection["City"].ToString().Trim();
			requestModel.StateId = Int32.Parse(collection["State"].ToString().Trim());
			requestModel.CountryId = Int32.Parse(collection["Country"].ToString().Trim());
            requestModel.DateLostStart = 
                collection["DateLostStart"].ToString().Trim().Equals("") 
                    ? DateTime.Parse("1900-01-01") 
                    : DateTime.Parse(collection["DateLostStart"].ToString().Trim());
			requestModel.DateLostEnd =
				collection["DateLostEnd"].ToString().Trim().Equals("")
					? DateTime.Parse("1900-01-01")
					: DateTime.Parse(collection["DateLostEnd"].ToString().Trim());
			requestModel.AgeStart = Int32.Parse(collection["AgeStart"].ToString().Trim());
			requestModel.AgeEnd = Int32.Parse(collection["AgeEnd"].ToString().Trim());
			requestModel.GenderId = Int32.Parse(collection["GenderRadios"].ToString().Trim());
			requestModel.EthnicityId = Int32.Parse(collection["Ethnicity"].ToString().Trim());
			requestModel.HairColorId = Int32.Parse(collection["HairColor"].ToString().Trim());
			requestModel.EyeColorId = Int32.Parse(collection["EyeColor"].ToString().Trim());

            List<SearchResponseModel> responseModel = await GetSearchResults(requestModel);
 
			ViewData["RowCount"] = responseModel.Count();

			return View("View",responseModel);
		}

		private async Task<SearchFilterModel> GetSearchFilters()
        {
			return await new RestClient(_configuration["API-GetSearchFilters"] ?? "")
                .GetAsync<SearchFilterModel>(new RestRequest()) ?? new SearchFilterModel();
        }

        private async Task<List<SearchResponseModel>> GetSearchResults(SearchRequestModel model)
        {
            string url = _configuration["API-GetSearchResults"] ?? "";

			var request = new RestRequest(url, Method.Get);
			request.RequestFormat = DataFormat.Json;
			request.AddBody(model);
            var client = new RestClient(url);
			var response = await client.ExecuteAsync<List<SearchResponseModel>>(request);
            
			return response.Data ?? new List<SearchResponseModel>();
        }
    }

}
