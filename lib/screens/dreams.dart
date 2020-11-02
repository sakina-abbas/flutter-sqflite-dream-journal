import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/services.dart';
import 'screens.dart';

class DreamEntries extends StatefulWidget {
  const DreamEntries({Key key}) : super(key: key);

  @override
  _DreamEntriesState createState() => _DreamEntriesState();
}

class _DreamEntriesState extends State<DreamEntries> {
  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getDreams().then(
      (dreamsList) {
        BlocProvider.of<DreamBloc>(context).add(SetDreams(dreamsList));
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Tell Me Your Dreams 👀'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => SearchScreen(),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => DreamForm(),
          ),
        ),
      ),
      body: BlocConsumer<DreamBloc, List<Dream>>(
        builder: (context, dreamsList) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: dreamsList.length,
            shrinkWrap: true,
            separatorBuilder: (BuildContext context, int index) =>
                Divider(
              color: Colors.black,
              indent: 10,
              endIndent: 10,
            ),
            itemBuilder: (BuildContext context, int index) {
              Dream dream = dreamsList[index];
              return ListTile(
                title: Text(
                  dream.title,
                  style: TextStyle(fontSize: 20),
                ),
                subtitle: Text(
                  dream.details,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () =>
                      deleteConfirmationDialog(context, dream, index),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DreamForm(dream: dream, dreamIndex: index),
                  ),
                ),
              );
            },
          );
        },
        listener: (BuildContext context, dreamsList) {},
      ),
    );
  }

  deleteConfirmationDialog(BuildContext context, Dream dream, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure you want to delete this?'),
        content: Text('${dream.title} ID: ${dream.id}'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          FlatButton(
            onPressed: () => DatabaseProvider.db.delete(dream.id).then((_) {
              BlocProvider.of<DreamBloc>(context).add(
                DeleteDream(index),
              );
              Navigator.pop(context);
            }),
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }
}
