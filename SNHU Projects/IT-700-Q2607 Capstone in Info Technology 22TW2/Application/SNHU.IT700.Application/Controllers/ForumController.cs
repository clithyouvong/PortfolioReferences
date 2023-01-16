using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RestSharp;
using SNHU.IT700.Application.Interfaces;
using SNHU.IT700.Application.Models;
using SNHU.IT700.Application.Services;
using System.Reflection;

namespace SNHU.IT700.Application.Controllers
{
    [Authorize]
    public class ForumController : Controller
    {
        private readonly ILogger<SearchController> _logger;
        private readonly IConfigurationRoot _configuration;
        private readonly IBodyAsExtractorService _extractorService;
        private readonly ICustomEventGridEvent _eventGrid;

        public ForumController(ILogger<SearchController> logger, IConfigurationRoot configurationRoot, IBodyAsExtractorService bodyAsExtractorService, ICustomEventGridEvent eventGrid)
        {
            _logger = logger;
            _configuration = configurationRoot;
            _extractorService = bodyAsExtractorService;
            _eventGrid = eventGrid;
        }

        public async Task<IActionResult> Index()
        {
            List<ForumTopicModel> model = await GetForumTopics();
            ViewData["RowCount"] = model.Count();

            return View(model);
		}
            
        public IActionResult Create()
		{
			ViewData["ReCaptchaKey"] = _configuration["ReCaptchaKey"];

            return View();
        }
        public async Task<IActionResult> Topic(int id)
        {
            List<ForumPostModel> model = await GetForumPosts(id);
            ViewData["RowCount"] = model.Count();
            ViewData["ForumTopicId"] = id.ToString();

            if(model.Count() == 0)
            {
                model.Add(
                new ForumPostModel()
                {
                    Post = "No Posts! Create one?",
                    Topic = ""
                });
            }
            ViewData["Topic"] = model[0].Topic;

            return View(model);
        }

        public IActionResult PostCreate(int id)
		{
			ViewData["ReCaptchaKey"] = _configuration["ReCaptchaKey"];
			ViewData["ForumTopicId"] = id.ToString();
			return View();
        }

		[HttpPost]
		public async Task<IActionResult> PostSubmit(IFormCollection collection)
		{
			string message = "";
			try
			{
				ForumPostModel requestModel = new ForumPostModel();
				requestModel.ForumTopicId = Int32.Parse(collection["ForumTopicId"].ToString());
				requestModel.Post = collection["Post"].ToString().Trim();
				requestModel.DateCreatedBy = 1004; //todo - hard coded right now, it should be based on user ID after login
                requestModel.DateCreatedByName = User.Identity?.Name ?? "";

                PostForumPost(requestModel);

				await Task.Delay(5 * 1000);

				message = "<div class=\"alert alert-success\" role=\"alert\">Successfully Created Post! Please wait a few seconds if you don't see it immediately!</div>";
			}
			catch (Exception e)
			{
				message = "<div class=\"alert alert-warning\" role=\"alert\">Submission Failed! " + e.Message + "</div>";
			}


            ViewData["ForumTopicId"] = collection["ForumTopicId"].ToString();
			ViewData["Message"] = message;

			return RedirectToAction("Topic", "Forum", new { id = Int32.Parse(collection["ForumTopicId"].ToString()) });
		}

		[HttpPost]
        public async Task<IActionResult> Submit(IFormCollection collection)
        {
            string message = "";
            try { 
                ForumTopicModel requestModel = new ForumTopicModel();
                requestModel.Topic = collection["Topic"].ToString().Trim();
                requestModel.DateCreatedBy = 1004; //todo - hard coded right now, it should be based on user ID after login
                requestModel.DateCreatedByName = User.Identity?.Name ?? "";

                PostForumTopic(requestModel);

                await Task.Delay(5 * 1000);

                message = "<div class=\"alert alert-success\" role=\"alert\">Successfully Created Forum! Please wait a few seconds if you don't see it immediately!</div>";
            }
            catch (Exception e)
            {
                message = "<div class=\"alert alert-warning\" role=\"alert\">Submission Failed! " + e.Message + "</div>";
            }

            List<ForumTopicModel> model = await GetForumTopics();
            ViewData["RowCount"] = model.Count();
			ViewData["Message"] = message;

			return View("Index", model);
        }


        private async Task<List<ForumTopicModel>> GetForumTopics()
        {
            return await new RestClient(_configuration["API-GetForums"] ?? "")
                .GetAsync<List<ForumTopicModel>>(new RestRequest()) ?? new List<ForumTopicModel>();
        }

        private async Task<List<ForumPostModel>> GetForumPosts(int id)
        {
            string url = _configuration["API-GetForumPosts"] ?? "";

            var request = new RestRequest($"{url}&ID={id}", Method.Get);
            request.RequestFormat = DataFormat.Json;
            var client = new RestClient(url);
            var response = await client.ExecuteAsync<List<ForumPostModel>>(request);

            return response.Data ?? new List<ForumPostModel>()
            {
                new ForumPostModel()
                {
                    Post = "No Posts! Create one?", 
                    Topic = ""
                }
            };
        }

        private void PostForumTopic(ForumTopicModel model)
        {
            _eventGrid.EventType = "PostForumTopic";
            _eventGrid.Subject = "PostForumTopic";
            _eventGrid.EventTime = DateTime.Now;
            _eventGrid.EventId = Guid.NewGuid().ToString();
            _eventGrid.EventData2 = model;
            _eventGrid.EventData = model;
			_eventGrid.Publish();
        }

		private void PostForumPost(ForumPostModel model)
		{
			_eventGrid.EventType = "PostForumPost";
			_eventGrid.Subject = "PostForumPost";
			_eventGrid.EventTime = DateTime.Now;
			_eventGrid.EventId = Guid.NewGuid().ToString();
			_eventGrid.EventData2 = model;
			_eventGrid.EventData = model;
			_eventGrid.Publish();
		}
	}
}
