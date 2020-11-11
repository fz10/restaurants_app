import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurants_app/blocs/authentication/bloc/bloc.dart';
import 'package:restaurants_app/blocs/client_search/bloc/client_search_bloc.dart';
import 'package:restaurants_app/models/models.dart';
import 'package:restaurants_app/repositories/user_repository.dart';
import 'package:restaurants_app/resources/style.dart';

class SearchScreen extends StatefulWidget {
  final UserRepository _userRepository;
  final Client _user;

  const SearchScreen({Key key, @required userRepository, Client user})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _user = user,
        super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  UserRepository get _userRepository => widget._userRepository;
  Client get _user => widget._user;
  List<Restaurant> restaurantList;

  ClientSearchBloc _searchBloc;

  int count = 0;
  @override
  void initState() {
    super.initState();
    _searchBloc = ClientSearchBloc(userRepository: _userRepository);
    _searchBloc.add(InitSearch());
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('¡Bienvenido ${_user.name}!'),
        centerTitle: true,
        backgroundColor: brandColor,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(
                LoggedOut(),
              );
            },
          )
        ],
      ),
      body: ListView(
        children: [
          _showSearchBar(),
          SizedBox(height: 10),
          BlocProvider(
            create: (context) => _searchBloc,
            child: BlocListener(
              cubit: _searchBloc,
              listener: (context, ClientSearchState state) {
                if (state is Failure) {
                  Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(state.message),
                            Icon(Icons.error),
                          ],
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                }
              },
              child: BlocBuilder(
                cubit: _searchBloc,
                builder: (context, ClientSearchState state) {
                  if (state is Success) {
                    return _getRestaurantListView(state.restaurantList);
                  } else if (state is Failure) {
                    return _defaultContent();
                  } else if (state is LoadingData) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 100),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is NoResults) {
                    return Container(
                      margin: EdgeInsets.all(70),
                      child: Center(
                          child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      )),
                    );
                  } else {
                    return _defaultContent();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultContent() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 150, horizontal: 40),
      child: Center(
        child: Text(
          '¡Busca los mejores restaurantes!',
          style: searchScreenTextStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  ListView _getRestaurantListView(List<Restaurant> restaurantList) {
    this.count = restaurantList.length;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Card(
            color: Colors.white,
            elevation: 10.0,
            child: ListTile(
              title: Text(
                restaurantList[position].name,
                style: cardTitleStyle,
              ),
              subtitle: Text(
                restaurantList[position].cuisine,
                style: cardSubtytleStyle,
              ),
              trailing: Icon(
                Icons.restaurant,
                color: Colors.grey,
              ),
              onTap: () {},
            ),
          ),
        );
      },
    );
  }

  Widget _showSearchBar() {
    return Container(
      child: SizedBox(
        height: 80,
        child: Container(
          decoration: BoxDecoration(
            color: brandColor,
          ),
          child: Form(
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: Icon(Icons.search),
                  labelText: 'Restaurante, tipo de comida...',
                ),
                autocorrect: false,
                onFieldSubmitted: (queryText) {
                  _searchBloc.add(SearchSubmitted(queryText: queryText));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchBloc.close();
    super.dispose();
  }
}
