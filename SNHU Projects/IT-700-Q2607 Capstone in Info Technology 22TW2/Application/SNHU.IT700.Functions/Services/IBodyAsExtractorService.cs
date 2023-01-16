using Azure.Messaging.EventGrid;
using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;
using SNHU.IT700.Functions.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SNHU.IT700.Functions.Services
{
	public interface IBodyAsExtractorService
	{
		Task<SearchRequestModel> GetSearchRequestModelBody(HttpRequest request);
		Task<ReportRequestModel> GetReportRequestModelBody(HttpRequest request);
        ForumPostModel GetForumPostBody(BinaryData data);
        ForumTopicModel GetForumTopicBody(BinaryData data);

        T Deserialize<T>(Stream s);
	}

	public class BodyAsExtractorService : IBodyAsExtractorService
	{
		public async Task<SearchRequestModel> GetSearchRequestModelBody(HttpRequest request) =>
			JsonConvert.DeserializeObject<SearchRequestModel>(await new StreamReader(request.Body).ReadToEndAsync());

		public async Task<ReportRequestModel> GetReportRequestModelBody(HttpRequest request) =>
			JsonConvert.DeserializeObject<ReportRequestModel>(await new StreamReader(request.Body).ReadToEndAsync());
        public ForumPostModel GetForumPostBody(BinaryData data) =>
            data.ToObjectFromJson<ForumPostModel>();
        public ForumTopicModel GetForumTopicBody(BinaryData data) =>
            data.ToObjectFromJson<ForumTopicModel>();
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
