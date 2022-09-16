class ExportListID1 {
  final String pGroupPDA1;
  final int pQty;
  final int pid;

  ExportListID1({
    required this.pGroupPDA1,
    required this.pQty,
    required this.pid,
  });
  factory ExportListID1.fromJson(Map<String, dynamic> json) {
    return ExportListID1(
      pGroupPDA1: json['GroupPDA1'],
      pQty: json['Qty'],
      pid: json['id'],
    );
  }
}

class ExportListID {
  final String pGroupPDA1;
  final int pQty;
  final double pListNo;
  final int pid;
  final String pExportNo;
  final String pOrderNo;
  final String pPartNo;
  final String pCustItem;
  final String pInvoice;

  ExportListID({
    required this.pGroupPDA1,
    required this.pQty,
    required this.pListNo,
    required this.pid,
    required this.pExportNo,
    required this.pOrderNo,
    required this.pPartNo,
    required this.pCustItem,
    required this.pInvoice,
  });
  factory ExportListID.fromJson(Map<String, dynamic> json) {
    return ExportListID(
      pGroupPDA1: json['GroupPDA1'],
      pQty: json['Qty'],
      pid: json['id'],
      pListNo: json['ListNo'],
      pExportNo: json['InvoiceNo'],
      pOrderNo: json['OrderNo'],
      pPartNo: json['PartNo'],
      pCustItem: json['CustItem'],
      pInvoice: json['InvoiceNo'],
    );
  }
}

class ExListView {
  final int pQty;
  final int pid;
  final String pPartNo;
  final String pPDTAG;

  ExListView({
    required this.pQty,
    required this.pid,
    required this.pPartNo,
    required this.pPDTAG,
  });
  factory ExListView.fromJson(Map<String, dynamic> json) {
    return ExListView(
      pQty: json['Quantity'],
      pid: json['id'],
      pPartNo: json['PartNo'],
      pPDTAG: json['PKTAG'],
    );
  }
}

class ExportScanPost {
  final String pTAG;
  final String cTAG;
  final String pStatus;
  final int pid;
  final String sUser;

  ExportScanPost(
      {required this.pTAG,
      required this.cTAG,
      required this.pStatus,
      required this.pid,
      required this.sUser});
  factory ExportScanPost.fromJson(Map<String, dynamic> json) {
    return ExportScanPost(
        pTAG: json['pTAG'],
        cTAG: json['cTAG'],
        pStatus: json['pStatus'],
        pid: json['pid'],
        sUser: json['sUser']);
  }
}

class JException {
  final String mMess;
  JException({
    required this.mMess,
  });
  factory JException.fromJson(Map<String, dynamic> json) {
    return JException(mMess: json['Message']);
  }
}

//////////////////////TEST DATA////////////////////

