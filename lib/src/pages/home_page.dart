import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_klip_wallet/src/widgets/title_text.dart';
import 'package:flutter_klip_wallet/src/functions/api.dart';
import 'package:flutter_klip_wallet/src/globals.dart' as globals;
import 'package:flutter_klip_wallet/src/functions/utilities.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  num klayBalance = 0;
  num klayQuote = 0;
  List<Map<String, dynamic>> cardList = [];
  TextEditingController walletAddressController = TextEditingController();

  /*
  Future _getUserKlipAddress() async {
    try {
      await platform.invokeMethod(
        'getUserAddress',
        <String, dynamic>{"requestKey": requestKey},
      ).then((result) {
        print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n" +
            "user klip address: " +
            result +
            "\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        globals.walletAddress = result;
      });
      setCardList();
    } on PlatformException catch (e) {
      print(e.message);
    }
  }
  */

  Widget _appBar() {
    return Row(
      children: <Widget>[
        const TitleText(text: 'Hello,'),
        const Text(' Ashley Kim',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black)),
        const Expanded(
          child: SizedBox(),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Klip wallet address'),
                  content: SizedBox(
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Enter your Klip wallet address :'),
                        TextFormField(
                          controller: walletAddressController,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                        child: const Text('Confirm'),
                        onPressed: () async {
                          globals.walletAddress = walletAddressController.text;
                          setCardList();
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString(
                              'wallet_address', walletAddressController.text);
                          walletAddressController.text = '';
                          Navigator.of(context).pop();
                        }),
                    TextButton(
                        child: const Text('Close'),
                        onPressed: () {
                          walletAddressController.text = '';
                          Navigator.of(context).pop();
                        })
                  ],
                );
              },
            );
          },
          child: Icon(
            Icons.short_text,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ],
    );
  }

  Widget _operationsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _icon(Icons.transfer_within_a_station, 'Transfer'),
        _icon(Icons.phone, 'Airtime'),
        _icon(Icons.payment, 'Pay Bills'),
        _icon(Icons.code, 'Qr Pay'),
      ],
    );
  }

  Widget _icon(IconData icon, String text) {
    return Column(
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {},
          child: Container(
            height: 80,
            width: 80,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color(0xfff3f3f3),
                    offset: Offset(5, 5),
                    blurRadius: 10,
                  )
                ]),
            child: Icon(icon),
          ),
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _nftList() {
    List<Map<String, dynamic>> evens = cardList
        .where((element) => (cardList.indexOf(element) % 2 == 0))
        .toList();
    List<Map<String, dynamic>> odds = cardList
        .where((element) => (cardList.indexOf(element) % 2 == 1))
        .toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: evens
              .map((e) => _nft(e['name'], e['description'], e['image'],
                  e['attributes'].toList()))
              .toList(),
        ),
        const SizedBox(
          width: 15,
        ),
        Column(
          children: odds
              .map((e) => _nft(e['name'], e['description'], e['image'],
                  e['attributes'].toList()))
              .toList(),
        ),
      ],
    );
  }

  Widget _nft(
      String name, String description, String image, List<dynamic> attributes) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    title: const Text('NFT Info'),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image.network(
                            image,
                            width: 300,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                            height: 0.5,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            color: Colors.grey,
                          ),
                          Text(
                            description,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            height: 0.5,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            color: Colors.grey,
                          ),
                          const Text(
                            'Attributes',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: attributes.length * 70,
                            width: 400,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: attributes.length,
                              itemBuilder: (BuildContext context, int index) {
                                String traitType =
                                    attributes[index]['trait_type'];
                                String value = attributes[index]['value'];
                                return Card(
                                  color: Colors.grey[100],
                                  child: ListTile(
                                    title: Text(
                                      '$traitType : $value',
                                      style: const TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                          child: const Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          })
                    ],
                  );
                });
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.43,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 1.5,
                  offset: Offset(1, 1),
                )
              ],
            ),
            child: Column(
              children: [
                Image.network(
                  image,
                  height: 150,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  void _setBalance() async {
    num i = await getBalance();
    num j = await getQuote();
    setState(() {
      klayBalance = i;
      klayQuote = j;
    });
  }

  Widget balanceCard() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 2, offset: Offset(1, 2))
        ],
      ),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            color: Colors.blueAccent,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Total Balance,',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          currencyFormat(klayBalance, 2),
                          style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w800,
                              color: Colors.yellow),
                        ),
                        const Text(
                          ' KLAY',
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w500,
                              color: Colors.yellow),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Eq: ',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        Text(
                          currencyFormat(klayBalance * klayQuote, 0) + ' KRW',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 150,
                          height: 50,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              border:
                                  Border.all(color: Colors.white, width: 1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Icon(
                                Icons.add,
                                color: Colors.blueAccent,
                                size: 20,
                              ),
                              const SizedBox(width: 5),
                              TextButton(
                                onPressed: () {
                                  getUserPermission();
                                },
                                child: const Text(
                                  'Klip으로 로그인',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 150,
                          height: 50,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              border:
                                  Border.all(color: Colors.white, width: 1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.zoom_in,
                                color: Colors.blueAccent[700],
                                size: 20,
                              ),
                              const SizedBox(width: 5),
                              TextButton(
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  globals.walletAddress =
                                      await getKlipAddress(globals.requestKey);
                                  await prefs.setString(
                                      'wallet_address', globals.walletAddress);
                                  setCardList();
                                },
                                child: Text(
                                  'NFT 조회',
                                  style: TextStyle(
                                    color: Colors.blueAccent[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: Text(
                        'Klip address : ' +
                            globals.walletAddress.substring(
                                0, min(globals.walletAddress.length, 10)) +
                            (globals.walletAddress.length > 10 ? '...' : ''),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const Positioned(
                  left: -170,
                  top: -170,
                  child: CircleAvatar(
                    radius: 130,
                    backgroundColor: Colors.indigo,
                  ),
                ),
                const Positioned(
                  left: -160,
                  top: -190,
                  child: CircleAvatar(
                    radius: 130,
                    backgroundColor: Colors.indigoAccent,
                  ),
                ),
                const Positioned(
                  right: -170,
                  bottom: -170,
                  child: CircleAvatar(
                    radius: 130,
                    backgroundColor: Colors.yellowAccent,
                  ),
                ),
                const Positioned(
                  right: -160,
                  bottom: -190,
                  child: CircleAvatar(
                    radius: 130,
                    backgroundColor: Colors.yellow,
                  ),
                )
              ],
            ),
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    _setBalance();
    loadPreferences();
    setCardList();
  }

  void setCardList() async {
    await Future.delayed(const Duration(seconds: 1), () {});
    cardList = await getCardList();
    setState(() {});
  }

  void loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    globals.walletAddress = prefs.getString('wallet_address') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 35),
              _appBar(),
              const SizedBox(
                height: 40,
              ),
              const TitleText(text: 'My wallet'),
              const SizedBox(
                height: 20,
              ),
              balanceCard(),
              const SizedBox(
                height: 50,
              ),
              const TitleText(
                text: 'NFTs',
              ),
              const SizedBox(
                height: 10,
              ),
              _nftList(),
              const SizedBox(
                height: 40,
              ),
              const TitleText(
                text: 'Operations',
              ),
              _operationsWidget(),
              const SizedBox(
                height: 20,
              ),
            ],
          )),
    )));
  }
}
