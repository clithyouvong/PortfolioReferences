using Azure.Security.KeyVault.Secrets;
using Microsoft.AspNetCore.Mvc;
using SNHU.IT700.Application.Models;
using System.Diagnostics;

namespace SNHU.IT700.Application.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IConfigurationRoot _configuration;

        public HomeController(ILogger<HomeController> logger, IConfigurationRoot configurationRoot)
        {
            _logger = logger;
            _configuration = configurationRoot;
        }

        public IActionResult Index()
        {

            var str = _configuration["CoverPage-Banner"];
            ViewBag.Banner = str;
            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        public IActionResult Citations()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}