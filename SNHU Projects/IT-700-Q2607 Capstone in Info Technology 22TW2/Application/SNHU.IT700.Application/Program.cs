using Azure.Identity;
using Microsoft.Azure.Services.AppAuthentication;
using SNHU.IT700.Application.Interfaces;
using SNHU.IT700.Application.Services;
using SNHU.IT700.Application.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity.UI.Services;
using Microsoft.Data.SqlClient;

namespace SNHU.IT700.Application
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);
            var region = builder.Configuration.GetValue("Region", "");

            // Add services to the container.
            builder.Services.AddControllersWithViews();

            // ======================================
            // Attaching to key vault
            IConfigurationBuilder configurationBuilder = new ConfigurationBuilder()
                .SetBasePath(Environment.CurrentDirectory)
                .AddEnvironmentVariables();

            AzureServiceTokenProvider tokenProvider = new AzureServiceTokenProvider();
            configurationBuilder.AddAzureKeyVault(new Uri($"https://SNHU-IT700-KV-{region}.vault.azure.net/"), new DefaultAzureCredential());


            IConfigurationRoot currentConfiguration = configurationBuilder.Build();


			// ======================================
            // Services
			builder.Services.AddScoped<IConfigurationRoot>(x => currentConfiguration);

			builder.Services.AddScoped<ICustomEventGridEvent>(sb => new CustomEventGridEvent
            {
                TopicKey = currentConfiguration["EventGrid-TopicKey"] ?? "",
                TopicName = currentConfiguration["EventGrid-TopicName"] ?? "",
                TopicRegion = currentConfiguration["EventGrid-TopicRegion"] ?? ""
            });
			builder.Services.AddTransient<IBodyAsExtractorService, BodyAsExtractorService>();


			// ======================================
			// Add Database services to the container.
			var connectionString = currentConfiguration["SQL-ConnectionString2"] ?? throw new InvalidOperationException("Connection string 'DefaultConnection' not found.");
            
            using(SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("Select 'hello world' as [hello];", conn))
                {
                    cmd.CommandType = System.Data.CommandType.Text;
                    string output = cmd.ExecuteScalar().ToString();
                    Console.WriteLine(output);
                }
            }


            builder.Services.AddDbContext<ApplicationDbContext>(options =>
				options.UseSqlServer(connectionString));
			builder.Services.AddDatabaseDeveloperPageExceptionFilter();

			builder.Services.AddDefaultIdentity<ApplicationUser>(options => options.SignIn.RequireConfirmedAccount = true)
				.AddEntityFrameworkStores<ApplicationDbContext>();
            builder.Services.AddControllersWithViews();


            builder.Services.AddTransient<IEmailSender, EmailSender>();
            builder.Services.Configure<AuthMessageSenderOptions>(builder.Configuration);


			// ======================================
			//everything else..
			var app = builder.Build();


            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseMigrationsEndPoint();
            }
            else
            {
                app.UseExceptionHandler("/Home/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseStaticFiles();

            app.UseRouting();

            app.UseAuthentication();
            app.UseAuthorization();



			app.MapControllerRoute(
                name: "default",
                pattern: "{controller=Home}/{action=Index}/{id?}");
            app.MapRazorPages();

            app.Run();
        }
    }
}