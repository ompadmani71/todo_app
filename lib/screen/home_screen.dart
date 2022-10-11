import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_miner/helpers/cloud_firestore_helper.dart';
import 'package:firebase_miner/models/todo_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/getx_controller.dart';
import '../enum/error_type.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  GlobalKey<FormState> addTODOFormKey = GlobalKey<FormState>();

  final blueColor = const Color(0XFF5e92f3);
  final yellowColor = const Color(0XFFfdd835);

  String todo_title = "";
  String todo_description = "";


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(

        body: GetX<HomeController>(builder: (cont) {
          if (cont.error.value == ErrorType.internet) {
            Get.snackbar("ERROR:", "No Internet");
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Stack(
            children: [
              buildBackgroundTopCircle(),
              buildBackgroundBottomCircle(),
              Container(
                height: size.height,
                width: size.width,
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 50, bottom: 40),
                child: Column(
                  children: [
                    const Center(
                      child: Text(
                        "To Do",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 80),
                    Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("TODO")
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapShot) {
                          if (snapShot.hasError) {
                            Get.snackbar("ERROR:", "${snapShot.error}",
                                backgroundColor: Colors.red.withOpacity(0.6),
                                colorText: Colors.white);
                            return Center(
                              child: Text("${snapShot.error}"),
                            );
                          } else if (snapShot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Text("Please Wait!"),
                            );
                          } else if (snapShot.hasData) {
                            List<QueryDocumentSnapshot> todoDataList =
                                snapShot.data.docs;

                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: const BouncingScrollPhysics(),
                              itemCount: todoDataList.length,
                              itemBuilder: (context, index) {
                                List<TODO> todoList = [];

                                todoDataList.forEach((element) {
                                  TODO data =
                                      TODOFromJson(jsonEncode(element.data()));
                                  todoList.add(data);
                                });

                                TODO todo = todoList[index];

                                return Row(
                                  children: [
                                    Container(
                                      width: size.width * 0.7,
                                      height: size.height * 0.14,
                                      margin: const EdgeInsets.only(
                                          bottom: 7, right: 7),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 15),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.7),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 2,
                                              spreadRadius: 1,
                                              offset: const Offset(0, 1),
                                            )
                                          ]),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text("${todo.todo_id}"),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text.rich(
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  TextSpan(
                                                      text: "Title: ",
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black),
                                                      children: [
                                                        TextSpan(
                                                            text:
                                                                todo.todo_title,
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black54))
                                                      ]),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children:  [
                                              Expanded(
                                                child: SizedBox(
                                                  height: 50,
                                                  child: SingleChildScrollView(
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    child: Text.rich(
                                                      TextSpan(
                                                          text:
                                                              "       Description: ",
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.black),
                                                          children: [
                                                            TextSpan(
                                                                text:
                                                                    todo.todo_description,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black54))
                                                          ]),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        await CloudFirestoreHelper.cloudFireStoreHelper.deleteTODO(id: todo.todo_id!).then((value) {
                                          Get.snackbar("Successes", "Delete TODO",backgroundColor: Colors.green.withOpacity(0.6),colorText: Colors.white);
                                        });
                                      },
                                      child: Container(
                                        width: size.width * 0.18,
                                        height: size.height * 0.14,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 10),
                                        margin: const EdgeInsets.only(bottom: 7),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.60),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    Colors.black.withOpacity(0.1),
                                                blurRadius: 2,
                                                spreadRadius: 1,
                                                offset: const Offset(0, 1),
                                              )
                                            ]),
                                        child: const Icon(CupertinoIcons.delete,color: Colors.black,),
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: cont.isShowAdd.value ? 230  : 0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: cont.isShowAdd.value
                          ? Form(
                              key: addTODOFormKey,
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 15, 15, 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      buildTextField(
                                          labelText: "Title:",
                                          placeholder: "Enter Title",
                                          isPassword: false,
                                          onValue: (value) {
                                            todo_title = value ?? "";
                                          }),
                                      const SizedBox(height: 10),
                                      buildTextField(labelText: "Description", placeholder: "Enter Description", isPassword: false, onValue: (value){todo_description= value ?? "";}),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () async {
                                                addTODOFormKey.currentState!.save();

                                                if (todo_title.isEmpty) {
                                                  Get.snackbar("Failed",
                                                      "Please Enter Title",
                                                      backgroundColor: Colors
                                                          .red
                                                          .withOpacity(0.6),
                                                      colorText: Colors.white);
                                                }
                                                if (todo_description.isEmpty) {
                                                  Get.snackbar("Failed",
                                                      "Please Enter Description",
                                                      backgroundColor: Colors
                                                          .red
                                                          .withOpacity(0.6),
                                                      colorText: Colors.white);
                                                }

                                                if (todo_description.isNotEmpty && todo_title.isNotEmpty) {
                                                  await CloudFirestoreHelper.cloudFireStoreHelper.addTODO(title: todo_title, description: todo_description).then((value) {
                                                    todo_title = "";
                                                    todo_description = "";
                                                    cont.isShowAdd(false);
                                                    Get.snackbar("Successes", "Inserted TODO",backgroundColor: Colors.green.withOpacity(0.6),colorText: Colors.white);
                                                  });
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: blueColor,
                                                foregroundColor: yellowColor,
                                              ),
                                              child: const Text("Save")),
                                          OutlinedButton(
                                              onPressed: () {
                                                setState(() {
                                                  todo_title = "";
                                                  todo_description = "";
                                                  cont.isShowAdd(false);
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  foregroundColor: blueColor),
                                              child: const Text("Cancel"))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(height: 0, width: 0),
                    )
                  ],
                ),
              ),
              if(cont.isShowAdd == false)
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () async {
                    cont.isShowAdd.value = !cont.isShowAdd.value;
                  },
                  child: Container(
                    height: 40,
                    width: 110,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(10),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                        gradient:
                            LinearGradient(colors: [blueColor, yellowColor]),
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.create,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Create",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        }));
  }

  Positioned buildBackgroundTopCircle() {
    return Positioned(
      top: 0,
      child: Transform.translate(
        offset: Offset(0.0, -MediaQuery.of(context).size.width / 1.3),
        child: Transform.scale(
          scale: 1.35,
          child: Container(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: blueColor,
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width,
                )),
          ),
        ),
      ),
    );
  }

  Column buildTextField(
      {required String labelText,
      required String placeholder,
      required bool isPassword,
      required Function(String?) onValue,
      TextInputType? textInputType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(color: blueColor, fontSize: 12),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8)),
            child: TextFormField(
              obscureText: isPassword,
              keyboardType: (textInputType == null) ? null : textInputType,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                hintText: placeholder,
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              onSaved: onValue,
            ))
      ],
    );
  }

  Positioned buildBackgroundBottomCircle() {
    return Positioned(
      top: MediaQuery.of(context).size.height -
          MediaQuery.of(context).size.width,
      right: MediaQuery.of(context).size.width / 2,
      child: Container(
        height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: yellowColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width,
            )),
      ),
    );
  }
}
