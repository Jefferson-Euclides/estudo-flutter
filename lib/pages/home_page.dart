import 'package:estudo/domain/carro.dart';
import 'package:estudo/pages/carro_form_page.dart';
import 'package:estudo/utils/nav.dart';
import 'package:estudo/widgets/carros_listView.dart';
import 'package:estudo/widgets/carros_page.dart';
import 'package:estudo/widgets/favoritos_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin<HomePage> {
  TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);

    SharedPreferences.getInstance().then((prefs) {
      tabController.index = prefs.getInt("tabIndex") ?? 0;
    });

    tabController.addListener(() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      int idx = tabController.index;

      pref.setInt("tabIndex", idx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carros"),
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(
              text: "Clássicos",
              icon: Icon(Icons.directions_car),
            ),
            Tab(
              text: "Esportivos",
              icon: Icon(Icons.directions_car),
            ),
            Tab(
              text: "Luxo",
              icon: Icon(Icons.directions_car),
            ),
            Tab(
              text: "Favoritos",
              icon: Icon(Icons.favorite),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          CarrosPage(TipoCarro.classicos),
          CarrosPage(TipoCarro.esportivos),
          CarrosPage(TipoCarro.luxo),
          FavoritosPage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed:() { 
          push(context, CarroFormPage());
        }
      )
    );
  }
}
