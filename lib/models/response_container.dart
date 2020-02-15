class RequestOutput {
  int statusCode;
  RequestStatus requestStatus;

  @override
  String toString() {
    return 'RequestOutput{statusCode: $statusCode, isRequestSucceed: $requestStatus, failureCause: $failureCause, data: $data}';
  }

  String failureCause;
  dynamic data;

  RequestOutput(
      {this.data, this.failureCause, this.requestStatus, this.statusCode});
}

enum RequestStatus { inProgress, succeed, failed, idle }
