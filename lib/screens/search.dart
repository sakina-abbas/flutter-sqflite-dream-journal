import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dream_form.dart';
import '../services/services.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<Dream> dreams = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          autofocus: true,
          textInputAction: TextInputAction.search,
          onFieldSubmitted: (input) {
            DatabaseProvider.db.getDreamsByName(input).then(
              (dreamsList) {
                setState(() {
                  dreams.clear();
                  dreams.addAll(dreamsList);
                });
              },
            );
          },
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            hintStyle: const TextStyle(color: Colors.white30),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: dreams.length,
        shrinkWrap: true,
        separatorBuilder: (BuildContext context, int index) =>
            Divider(
              color: Colors.black,
              indent: 10,
              endIndent: 10,
            ),
        itemBuilder: (BuildContext context, int index) {
          Dream dream = dreams[index];
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
