namespace servicemgmt.common;

type EmailAddress: String(100);
type PhoneNumber: String(20);

type ServiceStatus: String(20) enum {
    OPEN;
    IN_PROGRESS;
    COMPLETED;
    CANCELLED;
};

type Priority       : String(10) enum {
  Low;
  Medium;
  High;
  Critical;
}