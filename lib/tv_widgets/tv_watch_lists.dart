import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movieappnew/constant/style.dart';
import 'package:movieappnew/model/hive_tv_model.dart';

class TVWatchLists extends StatefulWidget {
  const TVWatchLists({super.key});

  @override
  State<TVWatchLists> createState() => _TVWatchListsState();
}

class _TVWatchListsState extends State<TVWatchLists> {
  late Box<HiveTVModel> _tvWatchLists;

  @override
  void initState() {
    _tvWatchLists = Hive.box<HiveTVModel>('tv_lists');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: _tvWatchLists.isEmpty
          ? Center(
              child: Text("No TV Shows added to list yet!",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Style.textColor)),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  ValueListenableBuilder(
                    valueListenable: _tvWatchLists.listenable(),
                    builder: (context, Box<HiveTVModel> item, _) {
                      List<int> keys = item.keys.cast<int>().toList();
                      return ListView.builder(
                        itemCount: keys.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final key = keys[index];
                          final HiveTVModel? _item = item.get(key);
                          return Card(
                            elevation: 5,
                            child: ListTile(
                              title: Text(_item!.name),
                              subtitle: Text(_item.overview,
                                  overflow: TextOverflow.ellipsis),
                              leading: Image.network(
                                  "https://image.tmdb.org/t/p/w200" +
                                      _item.poster,
                                  fit: BoxFit.cover),
                              trailing: IconButton(
                                icon: Icon(Icons.delete_outline),
                                onPressed: () {
                                  setState(() {
                                    _tvWatchLists.deleteAt(index);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            ),
    );
  }
}
