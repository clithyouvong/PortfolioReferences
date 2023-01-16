using Azure.Identity;
using Microsoft.Azure.Functions.Extensions.DependencyInjection;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using SNHU.IT700.Functions.Services;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static SNHU.IT700.Functions.Contexts.DBContext;

[assembly: FunctionsStartup(typeof(SNHU.IT700.Functions.Startup))]
namespace SNHU.IT700.Functions
{
	public class Startup : FunctionsStartup
	{
		private IConfigurationRoot _configuration;
		public override void Configure(IFunctionsHostBuilder builder)
		{
			
			var services = builder.Services;

			var hostingEnvironment = services
				.BuildServiceProvider()
				.GetService<IHostingEnvironment>();

			var configurationBuilder = new ConfigurationBuilder()
				.SetBasePath(hostingEnvironment.ContentRootPath)
				.AddJsonFile("local.settings.json", optional: true, reloadOnChange: true)
				.AddEnvironmentVariables();


			var region = Environment.GetEnvironmentVariable("Region");


			configurationBuilder
				.AddAzureKeyVault(new Uri($"https://SNHU-IT700-KV-{region}.vault.azure.net/"), new DefaultAzureCredential());

			_configuration = configurationBuilder.Build();

			services.AddSingleton(_configuration);

			builder.Services.AddTransient<IBodyAsExtractorService, BodyAsExtractorService>();
			builder.Services.AddTransient<IDbContextFactory, DbContextFactory>();


			builder.Services.AddLogging();
		}
	}
}
