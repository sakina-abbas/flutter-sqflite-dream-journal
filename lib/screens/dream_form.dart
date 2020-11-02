import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/services.dart';

class DreamForm extends StatefulWidget {
  final Dream dream;
  final int dreamIndex;

  DreamForm({this.dream, this.dreamIndex});

  @override
  State<StatefulWidget> createState() {
    return DreamFormState();
  }
}

class DreamFormState extends State<DreamForm> {
  String _title;
  String _details;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.dream != null) {
      _title = widget.dream.title;
      _details = widget.dream.details;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('What was the Dream?')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  labelText: 'Title',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigoAccent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigoAccent),
                  ),
                ),
                maxLength: 40,
                style: TextStyle(fontSize: 20),
                validator: (String value) {
                  return value.isEmpty ? 'Title is required' : null;
                },
                onSaved: (String value) {
                  _title = value;
                },
              ),
              SizedBox(height: 25),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.indigoAccent),
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.fromLTRB(15.0, 6.0, 0.0, 6.0),
                child: TextFormField(
                  initialValue: _details,
                  keyboardType: TextInputType.multiline,
                  maxLines: 12,
                  decoration: InputDecoration(
                    hintText: 'Details',
                    border: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 20),
                  validator: (String value) {
                    return value.isEmpty
                        ? 'You can\'t have a dream without details!'
                        : null;
                  },
                  onSaved: (String value) {
                    _details = value;
                  },
                ),
              ),
              SizedBox(height: 25),
              widget.dream == null
                  ? RaisedButton(
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }

                        _formKey.currentState.save();

                        Dream dream = Dream(
                          id: DateTime.now().millisecondsSinceEpoch,
                          title: _title,
                          details: _details,
                        );

                        DatabaseProvider.db.insert(dream).then(
                              (storedDream) =>
                                  BlocProvider.of<DreamBloc>(context).add(
                                AddDream(storedDream),
                              ),
                            );

                        Navigator.pop(context);
                      },
                    )
                  : RaisedButton(
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }

                        _formKey.currentState.save();

                        Dream dream = Dream(
                          id: widget.dream.id,
                          title: _title,
                          details: _details,
                        );

                        DatabaseProvider.db.update(dream).then(
                              (updatedDreamID) =>
                                  BlocProvider.of<DreamBloc>(context).add(
                                UpdateDream(widget.dreamIndex, dream),
                              ),
                            );

                        Navigator.pop(context);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
