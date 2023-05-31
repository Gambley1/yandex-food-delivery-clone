import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocProvider, MultiBlocProvider;
import 'package:papa_burger/src/restaurant.dart'
    show Api, AppTheme, LoginCubit, Routes, ShowPasswordCubit, UserRepository;
import 'package:papa_burger/src/views/pages/register/state/register_cubit.dart';

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
  });

  late final _userApi = Api();
  late final _userRepository = UserRepository(api: _userApi);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(userRepository: _userRepository),
        ),
        BlocProvider(create: (context) => ShowPasswordCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
      ],
      child: MaterialApp(
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        title: 'Papa Burger',
        theme: AppTheme.lightTheme,
        routes: Routes.routes,
      ),
    );
  }
}
