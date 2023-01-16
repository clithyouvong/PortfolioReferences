using static SNHU.IT700.Application.Services.CustomEventGridEvent;

namespace SNHU.IT700.Application.Interfaces
{
    /// <summary>
    /// An abstraction of the Azure Event Grid schema (https://docs.microsoft.com/en-us/azure/event-grid/event-schema)
    /// </summary>
    public interface ICustomEventGridEvent
    {
        /// <summary>
        /// You can find this topic endpoint value in the "Overview" section in the "Event Grid Topics" blade in Azure Portal.
        /// </summary>
        string TopicName { get; set; }
        /// <summary>
        /// You can find this in the "Access Keys" section in the "Event Grid Topics" blade in Azure Portal.
        /// </summary>
        string TopicKey { get; set; }
        /// <summary>
        /// You can find this topic endpoint value in the "Overview" section in the "Event Grid Topics" blade in Azure Portal.
        /// </summary>
        string TopicRegion { get; set; }
        /// <summary>
        /// The Version of the Event. Consider the notation: 1.0.0 (Default: 1.0)
        /// </summary>
        string DataVersion { get; set; }
        /// <summary>
        /// The identifier of the Event. Consider GUIDs for better identification. (Default: New Guid)
        /// </summary>        
        string EventId { get; set; }
        /// <summary>
        /// A JSON object expressed as a c# nested POCO class
        /// </summary>
        CustomEventData EventData { get; set; }
        /// <summary>
        /// A JSON object expressed as a c# nested POCO class
        /// </summary>
        object EventData2 { get; set; }
        /// <summary>The Time the Event was Published on (Default: DateTime UtcNow)</summary>
        /// <remarks>
        ///     From the (https://docs.microsoft.com/en-us/azure/event-grid/event-schema) <para>The time the event is generated based on the provider's UTC time.</para>
        /// </remarks>        
        DateTime EventTime { get; set; }
        /// <summary>
        /// The Event that can be advance filtered by the Event Grid Service.Consider the notation: Contoso.Items.ItemReceived
        /// </summary>
        string EventType { get; set; }

        /// <summary>
        /// The posted event name. This can be subject filtered by the Event Grid Service. Consider the notation: Contoso.Items.ItemReceived
        /// </summary>
        string Subject { get; set; }

        /// <summary>
        /// <para>
        ///     Publishes a custom event to an event grid and returns its status.
        ///     All variables must be set before using this method.
        /// </para>
        /// <para>Optionally, you can set the Topic Variables via key vault to prevent bringing them in constantly. </para>
        /// <para>See Az doc for more details: https://github.com/Azure-Samples/event-grid-dotnet-publish-consume-events/blob/master/EventGridPublisher/TopicPublisher/Program.cs</para>
        /// </summary>
        /// <returns></returns>
        string Publish();
    }
}
