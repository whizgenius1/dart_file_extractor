import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';

decompressZipFileWithInputFileStream(
    {required String fileNameWithExtion,
    required String saveDesination}) async {
  ///code to decompress a file
  ///
  /// Use an InputFileStream to access the zip file without storing it in memory.
  InputFileStream inputStream = InputFileStream(fileNameWithExtion);

  /// Decode the zip from the InputFileStream. The archive will have the contents of the
  /// zip, without having to store the data to memory
  Archive archive = ZipDecoder().decodeBuffer(inputStream);

  ///save file to any specified directory in disk
  extractArchiveToDisk(archive, saveDesination);
}

decompressZip(
    {required String fileNameWithExtion, required String saveDesination}) {
  ///read the file from disk
  Uint8List bytes = File(fileNameWithExtion).readAsBytesSync();

  /// Decode the zip from the InputFileStream. The archive will have the contents of the
  /// zip, without having to store the data to memory
  Archive archive = ZipDecoder().decodeBytes(bytes);

  ///save file to any specified directory in disk
  //extractArchiveToDisk(archive, saveDesination);

  // Encode the archive as a BZip2 compressed Tar file.

  List<int> tarData = TarEncoder().encode(archive);
  List<int> tarBz2 = BZip2Encoder().encode(tarData);
  List<int> zlip = ZLibEncoder().encode(tarData);
  List<int> gzip = GZipEncoder().encode(tarData)!;
// Write the compressed tar file to disk.
  try {
    File fp = File('test.tbz');
    fp.writeAsBytesSync(tarBz2);

    File fp2 = File('test.tar');
    fp2.writeAsBytesSync(tarData);

    File fp3 = File('text.gzip');
    fp3.writeAsBytesSync(gzip);
  } catch (e) {
    print(e);
  }
}

void main(List<String> arguments) {
  print('Hello world!');

  decompressZip(fileNameWithExtion: 'test.zip', saveDesination: 'decompressed');
  // decompressZipFileWithInputFileStream(
  //     fileNameWithExtion: 'pdf.zip', saveDesination: 'decompressed2');
}
