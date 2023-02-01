public with sharing class IncomingLeadHandlerHelper {
  public static void insertLead(Object data) {
    if (!(data instanceof Lead)) {
      return;
    }
    Lead leadToInsert = (Lead) data;
    if (leadToInsert.FirstName == null) {
      throw new ArgumentException();
    } else {
      insert leadToInsert;
    }
  }
}
