import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examplecodingtalk3/item_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore =
        FirebaseFirestore.instance; //nyambungin/pointer ke firestore
    CollectionReference users = firestore
        .collection("users"); //nyambungin ke collection dan kasih nama users

    return Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.green,
          // title: StreamBuilder<DocumentSnapshot>(
          //     stream: users
          //         .doc('QzLIagrAOr75yNa2prmk')
          //         .snapshots(), //mengambil satu aja dari id nya
          //     // ignore: missing_return
          //     builder: (context, snasphot) {
          //       if (snasphot.hasData) {
          //         return Text(snasphot.data.data()['nama'].toString());
          //       } else {
          //         Text('Loading');
          //       }
          //     }),
          title: Text('Flutter FireStore'),
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ListView(
              children: [
                StreamBuilder<QuerySnapshot>(
                    // stream: users.where('umur', isGreaterThan: 20).snapshots(),
                    // stream: users.orderBy('umur', descending: true).snapshots(),
                    stream: users.snapshots(), //get 1x, snapshots banyak kali
                    // ignore: missing_return
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        //jiiak punya data
                        return Column(
                          children: snapshot.data
                              .docs //ambil data yang menagndung dokumen docs
                              .map((e) => //lalukakn mapping diwakili e akan diwakili dimasukakn ke card dengan parameter
                                  ItemCard(
                                    e.data()['nama'],
                                    e.data()['umur'],
                                    onUpdate: () {
                                      users.doc(e.id).update(
                                          {'umur': e.data()['umur'] + 1});
                                    },
                                    onDelete: () {
                                      users.doc(e.id).delete();
                                    },
                                  )) //data dari e setelah mapping di sebelah kanan
                              .toList(),
                        );
                      } else {
                        Text('Loading');
                      }
                    }),
                SizedBox(
                  height: 150,
                ),
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(-5, -20),
                        blurRadius: 87,
                        spreadRadius: 19)
                  ]),
                  width: double.infinity,
                  height: 130,
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 160,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                              style: GoogleFonts.poppins(),
                              controller: nameController,
                              decoration:
                                  InputDecoration(hintText: "Nama Lengkap"),
                            ),
                            TextField(
                              style: GoogleFonts.poppins(),
                              controller: ageController,
                              decoration: InputDecoration(hintText: "Umur"),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 130,
                        width: 130,
                        padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                        child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: Colors.green,
                            child: Text(
                              'Tambah Data',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              //// ADD DATA HERE
                              users.add({
                                //users.nama collectionnya
                                'nama': nameController.text,
                                'umur': int.parse(ageController.text) ??
                                    0 //int.parse untuk jadiin string ke int
                              });
                              nameController.text = '';
                              ageController.text = '';
                            }),
                      )
                    ],
                  ),
                )),
          ],
        ));
  }
}
