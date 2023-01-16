using Microsoft.AspNetCore.Mvc;
using SNHU.IT700.Application.Interfaces;
using SNHU.IT700.Application.Models;

namespace SNHU.IT700.Application.Controllers
{
    public class ContactController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IConfigurationRoot _configuration;
        private readonly ICustomEventGridEvent _eventGrid;

        public ContactController(ILogger<HomeController> logger, IConfigurationRoot configurationRoot, ICustomEventGridEvent eventGrid)
        {
            _logger = logger;
            _configuration = configurationRoot;
            _eventGrid = eventGrid;
        }

        public IActionResult Index()
        {
            ViewData["Banner"] = _configuration["Contact-Banner"];
            ViewData["ReCaptchaKey"] = _configuration["ReCaptchaKey"];
            return View();
        }

        [HttpPost]
        public IActionResult Submit(IFormCollection collection)
        {
            string message = "";

            try
            {
                ContactModel model = new ContactModel();

                model.NameOfSubmitter = collection["NameOfSubmitter"].ToString();
                model.NameOfLostIndividual = collection["NameOfLostIndividual"].ToString();
                model.LastKnownLocation = collection["LastKnownLocation"].ToString();
                model.Description = collection["Description"].ToString();
                model.EmailAddress = collection["EmailAddress"].ToString();
                model.PhoneNumber = collection["PhoneNumber"].ToString();

                _eventGrid.EventType = "ContactUs";
                _eventGrid.Subject = $"Contact Us {model.NameOfSubmitter}";
                _eventGrid.EventTime = DateTime.Now;
                _eventGrid.EventId = Guid.NewGuid().ToString();
                _eventGrid.EventData2 = model;
                _eventGrid.EventData = model;
                _eventGrid.Publish();

                message = "<div class=\"alert alert-success\" role=\"alert\">Submission Successful! We'll be in contact with you shortly!</div>";
            }
            catch(Exception e)
            {
                message = "<div class=\"alert alert-warning\" role=\"alert\">Submission Failed! "+e.Message+"</div>";
            }


            ViewData["Banner"] = _configuration["Contact-Banner"];
            ViewData["ReCaptchaKey"] = _configuration["ReCaptchaKey"];
            ViewData["Message"] = message;

            return View("Index");
        }
    }
}
