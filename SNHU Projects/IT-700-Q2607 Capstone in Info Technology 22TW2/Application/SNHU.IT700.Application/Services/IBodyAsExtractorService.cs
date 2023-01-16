using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;
using SNHU.IT700.Application.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SNHU.IT700.Application.Services
{
	public interface IBodyAsExtractorService
	{
		Task<SearchFilterModel> GetSearchFilterBody(HttpRequest request);
		T Deserialize<T>(Stream s);
	}

	public class BodyAsExtractorService : IBodyAsExtractorService
	{
		public async Task<SearchFilterModel> GetSearchFilterBody(HttpRequest request) =>
			JsonConvert.DeserializeObject<SearchFilterModel>(await new StreamReader(request.Body).ReadToEndAsync()) ?? new SearchFilterModel();


		public T Deserialize<T>(Stream s)
		{
			using (StreamReader reader = new StreamReader(s))
			using (JsonTextReader jsonReader = new JsonTextReader(reader))
			{
				JsonSerializer ser = new JsonSerializer();
				return ser.Deserialize<T>(jsonReader);
			}
		}
	}
}
