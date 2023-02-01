/**
 * @description A simple Pub/Sub pattern implementation
 */
public with sharing class PubSubService {
  private PubSubService() {
  }

  private Map<String, List<IHandleMessages>> subscribers = new Map<String, List<IHandleMessages>>();

  /**
   * @description A singleton for service interaction.
   */
  public static PubSubService Instance {
    get {
      if (Instance == null) {
        Instance = new PubSubService();
      }

      return Instance;
    }
    private set;
  }

  /**
   * @description Subscribes a given IHandleMessages implementation to the channels it returns.
   * @param implementation An instance of IHandleMessages.
   * @throws ArgumentNullException if implementation is null.
   */
  public void subscribe(IHandleMessages implementation) {
    ArgumentNullException.throwIfNull(
      implementation,
      Constants.IMPLEMENTATION_PARAM
    );

    List<String> subscribedChannels = implementation.getSubscribedChannels();
    for (String channel : subscribedChannels) {
      if (!subscribers.containsKey(channel)) {
        subscribers.put(channel, new List<IHandleMessages>());
      }
      subscribers.get(channel).add(implementation);
    }
  }

  /**
   * @description Un-subscribes a given IHandleMessages implementation to the channels it returns.
   * @param implementation An instance of IHandleMessages.
   * @throws ArgumentNullException if implementation is null.
   */
  public void unsubscribe(IHandleMessages implementation) {
    ArgumentNullException.throwIfNull(
      implementation,
      Constants.IMPLEMENTATION_PARAM
    );

    List<String> subscribedChannels = implementation.getSubscribedChannels();
    for (String channel : subscribedChannels) {
      if (subscribers.containsKey(channel)) {
        List<IHandleMessages> handleMessages = subscribers.get(channel);
        if (handleMessages != null) {
          Integer handleMessageIndex = handleMessages.indexOf(implementation);
          if (handleMessageIndex != null) {
            handleMessages.remove(handleMessageIndex);
          }
        }
        if (handleMessages.isEmpty()) {
          subscribers.remove(channel);
        }
      }
    }
  }

  /**
   * @description Emits a message to a given channel containing the specified data.
   * @param channel The channel to emit a message on.
   * @param data The data to emit.
   * @throws ArgumentNullException if channel is null.
   */
  public void emit(String channel, Object data) {
    ArgumentNullException.throwIfNull(channel, Constants.CHANNEL_PARAM);

    if (subscribers.containsKey(channel)) {
      for (IHandleMessages subscriber : subscribers.get(channel)) {
        subscriber.handleMessage(channel, data);
      }
    }
  }
}
