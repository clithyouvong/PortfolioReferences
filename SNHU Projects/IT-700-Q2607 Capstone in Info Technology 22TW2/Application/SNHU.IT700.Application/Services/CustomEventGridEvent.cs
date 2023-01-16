using Microsoft.Azure.EventGrid;
using Microsoft.Azure.EventGrid.Models;
using Newtonsoft.Json;
using SNHU.IT700.Application.Interfaces;
using static NuGet.Client.ManagedCodeConventions;

namespace SNHU.IT700.Application.Services
{
    public class CustomEventGridEvent : ICustomEventGridEvent
    {
        #region REGION: Variables
        /// <summary>
        /// You can find this topic endpoint value in the "Overview" section in the "Event Grid Topics" blade in Azure Portal.
        /// </summary>
        public string TopicName { get; set; } = "";

        /// <summary>
        /// You can find this in the "Access Keys" section in the "Event Grid Topics" blade in Azure Portal.
        /// </summary>
        public string TopicKey { get; set; } = "";

        /// <summary>
        /// You can find this topic endpoint value in the "Overview" section in the "Event Grid Topics" blade in Azure Portal.
        /// </summary>
        public string TopicRegion { get; set; } = "";

        /// <summary>
        /// The Version of the Event. Consider the notation: 1.0.0 (Default: 1.0)
        /// </summary>
        public string DataVersion { get; set; } = "1.0";

        /// <summary>
        /// The identifier of the Event. Consider GUIDs for better identification. (Default: New Guid)
        /// </summary>        
        public string EventId { get; set; } = Guid.NewGuid().ToString();

        /// <summary>
        /// A JSON object expressed as a c# nested POCO class
        /// </summary>
        public CustomEventData EventData { get; set; } = new CustomEventData();

        /// <summary>
        /// A JSON object expressed as a c# nested POCO class
        /// </summary>
        public Object EventData2 { get; set; } = new object();

        /// <summary>The Time the Event was Published on (Default: DateTime UtcNow)</summary>
        /// <remarks>
        ///     From the (https://docs.microsoft.com/en-us/azure/event-grid/event-schema) <para>The time the event is generated based on the provider's UTC time.</para>
        /// </remarks>        
        public DateTime EventTime { get; set; } = DateTime.UtcNow;

        /// <summary>
        /// The Event that can be advance filtered by the Event Grid Service.Consider the notation: Contoso.Items.ItemReceived
        /// </summary>
        public string EventType { get; set; } = "";

        /// <summary>
        /// The posted event name. This can be subject filtered by the Event Grid Service. Consider the notation: Contoso.Items.ItemReceived
        /// </summary>
        public string Subject { get; set; } = "";
        CustomEventData ICustomEventGridEvent.EventData { get; set; }= new CustomEventData();
        #endregion

        #region REGION: Constructors
        // This captures the "Data" portion of an EventGridEvent on a custom topic
        public class CustomEventData
        {
            [JsonProperty(PropertyName = "itemSku")]
            public string ItemSku { get; set; } = "";
        }

        /// <summary>
        /// <para>
        ///     Allows you to create an instance of this class. You must set at least the
        ///     topicName, topicRegion, topicKey, eventType, and subject to continue.
        /// </para>
        /// <para>Once these required variables have been set, call the Publish() method.</para>
        /// </summary>
        public CustomEventGridEvent()
        {
        }

        /// <summary>
        /// <para>
        ///     Defines the minimum requirements needed to send a custom event to the Event Grid.
        ///     If you need a different set of data points to be sent over, consider the Constructor
        ///     with the {object} variable
        /// </para>
        /// <para>See Az doc for more details: https://github.com/Azure-Samples/event-grid-dotnet-publish-consume-events/blob/master/EventGridPublisher/TopicPublisher/Program.cs</para>
        /// </summary>
        /// <param name="topicName">You can find this topic endpoint value in the "Overview" section in the "Event Grid Topics" blade in Azure Portal.</param>
        /// <param name="topicRegion">You can find this in the "Access Keys" section in the "Event Grid Topics" blade in Azure Portal.</param>
        /// <param name="topicKey">You can find this topic endpoint value in the "Overview" section in the "Event Grid Topics" blade in Azure Portal.</param>
        /// <param name="eventType">The Event that can be advance filtered by the Event Grid Service. Consider the notation: Contoso.Items.ItemReceived</param>
        /// <param name="subject">The posted event name. This can be subject filtered by the Event Grid Service. Consider the notation: Contoso.Items.ItemReceived</param>
        /// <param name="eventData">A JSON object expressed as a c# nested POCO class</param>
        public CustomEventGridEvent(string topicName, string topicRegion, string topicKey, string eventType, string subject, CustomEventData eventData)
        {
            TopicName = topicName;
            TopicRegion = topicRegion;
            TopicKey = topicKey;

            EventType = eventType;
            Subject = subject;
            EventData = eventData;
        }

        /// <summary>
        /// <para>
        ///     Defines the all required and optional variables needed to send a custom event to the Event Grid.
        ///     If you need a different set of data points to be sent over, consider the Constructor
        ///     with the {object} variable
        /// </para>
        /// <para>See Az doc for more details: https://github.com/Azure-Samples/event-grid-dotnet-publish-consume-events/blob/master/EventGridPublisher/TopicPublisher/Program.cs</para>
        /// </summary>
        /// <param name="topicName">You can find this topic endpoint value in the "Overview" section in the "Event Grid Topics" blade in Azure Portal.</param>
        /// <param name="topicRegion">You can find this in the "Access Keys" section in the "Event Grid Topics" blade in Azure Portal.</param>
        /// <param name="topicKey">You can find this topic endpoint value in the "Overview" section in the "Event Grid Topics" blade in Azure Portal.</param>
        /// <param name="eventType">The Event that can be advance filtered by the Event Grid Service. Consider the notation: Contoso.Items.ItemReceived</param>
        /// <param name="subject">The posted event name. This can be subject filtered by the Event Grid Service. Consider the notation: Contoso.Items.ItemReceived</param>
        /// <param name="eventData">A JSON object expressed as a c# nested POCO class</param>
        /// <param name="eventTime">The Time the Event was Published on (Default: DateTime Now)</param>
        /// <param name="eventId">The identifier of the Event. Consider GUIDs for better identification. (Default: New Guid) </param>
        /// <param name="dataVersion">The Version of the Event. Consider the notation: 1.0.0 (Default: 1.0)</param>
        public CustomEventGridEvent(string topicName, string topicRegion, string topicKey, string eventType, string subject, CustomEventData eventData, DateTime eventTime, string eventId, string dataVersion)
        {
            TopicName = topicName;
            TopicRegion = topicRegion;
            TopicKey = topicKey;

            EventType = eventType;
            Subject = subject;
            EventData = eventData;

            EventTime = eventTime;
            EventId = eventId;
            DataVersion = dataVersion;
        }

        /// <summary>
        /// <para>
        ///     Defines the minimum requirements needed to send a custom event to the Event Grid.
        ///     If you need data points that are already already defined, consider the Constructor
        ///     with the {CustomEventData} variable
        /// </para> 
        /// <para>See Az doc for more details: https://github.com/Azure-Samples/event-grid-dotnet-publish-consume-events/blob/master/EventGridPublisher/TopicPublisher/Program.cs</para>
        /// </summary>
        /// <param name="topicName">You can find this topic endpoint value in the "Overview" section in the "Event Grid Topics" blade in Azure Portal.</param>
        /// <param name="topicRegion">You can find this in the "Access Keys" section in the "Event Grid Topics" blade in Azure Portal.</param>
        /// <param name="topicKey">You can find this topic endpoint value in the "Overview" section in the "Event Grid Topics" blade in Azure Portal.</param>
        /// <param name="eventType">The Event that can be advance filtered by the Event Grid Service. Consider the notation: Contoso.Items.ItemReceived</param>
        /// <param name="subject">The posted event name. This can be subject filtered by the Event Grid Service. Consider the notation: Contoso.Items.ItemReceived</param>
        /// <param name="eventData">A JSON object expressed as a c# nested POCO class</param>
        public CustomEventGridEvent(string topicName, string topicRegion, string topicKey, string eventType, string subject, object eventData)
        {
            TopicName = topicName;
            TopicRegion = topicRegion;
            TopicKey = topicKey;

            EventType = eventType;
            Subject = subject;
            EventData2 = eventData;
        }

        /// <summary>
        /// <para>
        ///     Defines the all required and optional variables needed to send a custom event to the Event Grid.
        ///     If you need data points that are already already defined, consider the Constructor
        ///     with the {CustomEventData} variable
        /// </para>
        /// <para>See Az doc for more details: https://github.com/Azure-Samples/event-grid-dotnet-publish-consume-events/blob/master/EventGridPublisher/TopicPublisher/Program.cs</para>
        /// </summary>
        /// <param name="topicName">You can find this topic endpoint value in the "Overview" section in the "Event Grid Topics" blade in Azure Portal.</param>
        /// <param name="topicRegion">You can find this in the "Access Keys" section in the "Event Grid Topics" blade in Azure Portal.</param>
        /// <param name="topicKey">You can find this topic endpoint value in the "Overview" section in the "Event Grid Topics" blade in Azure Portal.</param>
        /// <param name="eventType">The Event that can be advance filtered by the Event Grid Service. Consider the notation: Contoso.Items.ItemReceived</param>
        /// <param name="subject">The posted event name. This can be subject filtered by the Event Grid Service. Consider the notation: Contoso.Items.ItemReceived</param>
        /// <param name="eventData">A JSON object expressed as a c# nested POCO class</param>
        /// <param name="eventTime">The Time the Event was Published on (Default: DateTime Now)</param>
        /// <param name="eventId">The identifier of the Event. Consider GUIDs for better identification. (Default: New Guid) </param>
        /// <param name="dataVersion">The Version of the Event. Consider the notation: 1.0.0 (Default: 1.0)</param>
        public CustomEventGridEvent(string topicName, string topicRegion, string topicKey, string eventType, string subject, object eventData, DateTime eventTime, string eventId, string dataVersion)
        {
            TopicName = topicName;
            TopicRegion = topicRegion;
            TopicKey = topicKey;

            EventType = eventType;
            Subject = subject;
            EventData2 = eventData;

            EventTime = eventTime;
            EventId = eventId;
            DataVersion = dataVersion;
        }
        #endregion

        #region REGION: Publishing
        /// <summary>
        /// <para>
        ///     Publishes a custom event to an event grid and returns its status.
        ///     All variables must be set before using this method.
        /// </para>
        /// <para>Optionally, you can set the Topic Variables via key vault to prevent bringing them in constantly. </para>
        /// <para>See Az doc for more details: https://github.com/Azure-Samples/event-grid-dotnet-publish-consume-events/blob/master/EventGridPublisher/TopicPublisher/Program.cs</para>
        /// </summary>
        /// <returns></returns>
        public string Publish()
        {
            string result;

            try
            {
                string topicHostname = new Uri($"https://{TopicName}.{TopicRegion}-1.eventgrid.azure.net/api/events").Host;
                TopicCredentials topicCredentials = new TopicCredentials(TopicKey);
                EventGridClient client = new EventGridClient(topicCredentials);

                client.PublishEventsAsync(topicHostname, GetEventsList()).GetAwaiter().GetResult();

                result = "Done";
            }
            catch (Exception exception)
            {
                result = $"Exception: {exception.Message}";
            }

            return result;
        }

        /// <summary>
        /// Constructs the Event to be sent over
        /// </summary>
        /// <returns></returns>
        private IList<EventGridEvent> GetEventsList()
        {
            return new List<EventGridEvent>
            {
                new EventGridEvent
                {
                    Id = EventId,
                    EventType = EventType,
                    Data = EventData2 ?? EventData,
                    EventTime = EventTime,
                    Subject = Subject,
                    DataVersion = DataVersion
                }
            };
        }
        #endregion
    }
}
