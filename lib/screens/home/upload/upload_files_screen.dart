import 'dart:io';

import 'package:advance_player_academy_trainer/controllers/loading_controller.dart';
import 'package:advance_player_academy_trainer/controllers/storage_controller.dart';
import 'package:advance_player_academy_trainer/screens/home/upload/widgets/file_widget.dart';
import 'package:advance_player_academy_trainer/themes/app_colors.dart';
import 'package:advance_player_academy_trainer/widgets/alert_dialog.dart';
import 'package:advance_player_academy_trainer/widgets/show_custom_msg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../widgets/custom_text_input.dart';

enum FilterOptions {
  All,
  WordFiles,
  ExcelFiles,
  PdfFiles,
}

class UploadFilesScreen extends StatefulWidget {
  @override
  State<UploadFilesScreen> createState() => _UploadFilesScreenState();
}

class _UploadFilesScreenState extends State<UploadFilesScreen> {
  TextEditingController controller = TextEditingController();
  TextEditingController searchController = TextEditingController();
  File? pdf;
  String? pdfFileName;
  FilterOptions selectedFilter = FilterOptions.All;

  void _handleFilterChange(FilterOptions selectedOption) {
    setState(() {
      selectedFilter = selectedOption;
    });
  }

  uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xlsx', 'xls'],
    );
    if (result != null) {
      setState(() {
        pdf = File(result.files.single.path!);
        pdfFileName = pdf!.path.split('/').last;
      });
    }
  }

  bool isPdfFile() {
    return pdfFileName!.toLowerCase().endsWith('.pdf');
  }

  bool isDocFile() {
    return pdfFileName!.toLowerCase().endsWith('.doc') || pdfFileName!.toLowerCase().endsWith('.docx');
  }

  bool isExcelFile() {
    return pdfFileName!.toLowerCase().endsWith('.xlsx') || pdfFileName!.toLowerCase().endsWith('.xls');
  }

  @override
  Widget build(BuildContext context) {
    final loadingController = Provider.of<LoadingController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Files"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.mainColor,
        onPressed: () {
          uploadFile();
        },
        child: Icon(Icons.add, color: AppColors.primaryWhite),
      ),
      body: Column(
        children: [
          pdf == null
              ? const SizedBox()
              : Center(
                  child: Card(
                    color: Colors.deepPurple.shade50,
                    child: Column(
                      children: [
                        Text(pdfFileName!),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
                            controller: controller,
                            decoration: const InputDecoration(hintText: 'file Description'),
                          ),
                        ),
                        loadingController.isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  try {
                                    var docId = Uuid().v1();
                                    Provider.of<LoadingController>(context, listen: false).setLoading(true);
                                    String url = await StorageController().uploadImageToDb(pdf!);

                                    bool isPdf = isPdfFile();
                                    bool isDoc = isDocFile();
                                    bool isExcel = isExcelFile();

                                    await FirebaseFirestore.instance.collection("files").doc(docId).set({
                                      'url': url,
                                      'createdAt': DateTime.now(),
                                      'trainerId': FirebaseAuth.instance.currentUser!.uid,
                                      'isPdf': isPdf,
                                      'isDoc': isDoc,
                                      'isExcel': isExcel,
                                      'isLocked': false,
                                      'description': controller.text,
                                    });
                                    setState(() {
                                      controller.clear();
                                    });

                                    Provider.of<LoadingController>(context, listen: false).setLoading(false);

                                    showCustomMsg("File Upload Successfully");
                                    setState(() {
                                      pdf = null;
                                    });
                                  } on FirebaseException catch (error) {
                                    Provider.of<LoadingController>(context, listen: false).setLoading(false);
                                    showCustomMsg(error.message.toString());
                                  }
                                },
                                child: const Text("Upload"),
                              ),
                      ],
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: CustomTextInput(
                    controller: searchController,
                    onChanged: (v) {
                      setState(() {});
                    },
                    hintText: "Search",
                  ),
                ),
                SizedBox(width: 20),
                PopupMenuButton<FilterOptions>(
                  onSelected: _handleFilterChange,
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterOptions>>[
                    const PopupMenuItem<FilterOptions>(
                      value: FilterOptions.All,
                      child: Text('All'),
                    ),
                    const PopupMenuItem<FilterOptions>(
                      value: FilterOptions.WordFiles,
                      child: Text('Word Files'),
                    ),
                    const PopupMenuItem<FilterOptions>(
                      value: FilterOptions.ExcelFiles,
                      child: Text('Excel Files'),
                    ),
                    const PopupMenuItem<FilterOptions>(
                      value: FilterOptions.PdfFiles,
                      child: Text('PDF Files'),
                    ),
                  ],
                  child: Icon(Icons.filter_alt),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("files")
                  .where('trainerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No Document Found"),
                  );
                }

                List<DocumentSnapshot> filteredDocuments = snapshot.data!.docs.where((data) {
                  if (searchController.text.isNotEmpty &&
                      !data['description'].toString().toLowerCase().contains(searchController.text.toLowerCase())) {
                    return false;
                  }

                  switch (selectedFilter) {
                    case FilterOptions.All:
                      return true;
                    case FilterOptions.WordFiles:
                      return data['isDoc'];
                    case FilterOptions.ExcelFiles:
                      return data['isExcel'];
                    case FilterOptions.PdfFiles:
                      return data['isPdf'];
                    default:
                      return true;
                  }
                }).toList();

                return GridView.builder(
                  itemCount: filteredDocuments.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    var data = filteredDocuments[index];
                    return companyFileWidget(
                      onDeletedBtnClicked: () {
                        customAlertDialog(context, () async {
                          Get.back();
                          await FirebaseFirestore.instance
                              .collection('files')
                              .doc(snapshot.data!.docs[index].id)
                              .delete();
                        }, 'Are You Sure To Delete This File?');
                      },
                      data: data,
                      context: context,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
