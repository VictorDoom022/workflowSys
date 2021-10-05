class FileReceiver {
  String fileName;
  int fileSize;
  String filePath;

  FileReceiver({this.fileName, this.fileSize, this.filePath});

  FileReceiver.fromJson(Map<String, dynamic> json) {
    fileName = json['fileName'];
    fileSize = json['fileSize'];
    filePath = json['filePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fileName'] = this.fileName;
    data['fileSize'] = this.fileSize;
    data['filePath'] = this.filePath;
    return data;
  }
}