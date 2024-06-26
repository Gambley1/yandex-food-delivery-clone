import 'dart:async' show StreamSubscription;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show CameraPosition, GoogleMap, LatLng;
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/home/bloc/address_result.dart';
import 'package:papa_burger/src/home/services/location_service.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared/shared.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({
    super.key,
    this.placeDetails,
    this.fromLogin = false,
  });

  final PlaceDetails? placeDetails;
  final bool fromLogin;

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView>
    with TickerProviderStateMixin {
  final LocationService _locationService = LocationService();

  late StreamSubscription<dynamic> _addressResultSubscription;
  late StreamSubscription<dynamic> _isMovingSubscription;
  final bool _isLoading = false;
  bool _isMoving = false;

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.ease),
    );

    _animationController.forward();
    _locationService.locationHelper.initMapConfiguration;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribeToAddress();
    _subscribeToMoving();
  }

  void _subscribeToAddress() {
    _addressResultSubscription =
        _locationService.locationBloc.addressName.listen((result) {
      final isLoading = result is Loading || result is InProgress;
      if (isLoading) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    });
  }

  void _subscribeToMoving() {
    _isMovingSubscription =
        _locationService.locationBloc.moving.listen((isMoving) {
      _isMoving = isMoving;
    });
  }

  @override
  void dispose() {
    _locationService.locationHelper.dispose();
    _locationService.locationBloc.dispose();
    _isMovingSubscription.cancel();
    _addressResultSubscription.cancel();
    super.dispose();
  }

  Widget _buildSaveLocationBtn(BuildContext context) {
    return Positioned(
      left: 40,
      right: 80,
      bottom: AppSpacing.lg,
      child: ListenableBuilder(
        listenable: _animationController,
        builder: (context, _) {
          return AnimatedOpacity(
            opacity: _opacityAnimation.value,
            duration: const Duration(milliseconds: 150),
            child: ShadButton(
              text: const Text('Save'),
              width: double.infinity,
              onPressed: () {
                _locationService.locationHelper
                    .saveLocation(
                      _locationService.locationHelper.dynamicMarkerPosition,
                    )
                    .then(
                      (value) => widget.fromLogin
                          ? context
                              .pushReplacementNamed(AppRoutes.restaurants.name)
                          : context.pop(),
                    );
              },
              shadows: const [BoxShadowEffect.defaultValue],
            ),
            // child: InkWell(
            //   onTap: () {},
            //   child: Container(
            //     height: 40,
            //     width: double.infinity,
            //     alignment: Alignment.center,
            //     decoration: BoxDecoration(
            //       borderRadius:
            //           BorderRadius.circular(AppSpacing.md + AppSpacing.sm),
            //       boxShadow: const [
            //         BoxShadow(
            //           blurRadius: 5,
            //           color: Colors.black54,
            //           offset: Offset(0, 3),
            //         ),
            //       ],
            //     ),
            //     child: Text(
            //       'Save',
            //       style: context.headlineSmall?.copyWith(
            //         fontWeight: AppFontWeight.regular,
            //         color: AppColors.white,
            //       ),
            //     ),
            //   ),
            // ).ignorePointer(isMoving: _isMoving),
          );
        },
      ),
    );
  }

  Widget _buildErrorAddress(String error) => GestureDetector(
        onTap: () => context.pushNamed(AppRoutes.searchLocation.name),
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(
            horizontal: 60,
          ),
          child: Text(
            "Delivery address isn't found",
            textAlign: TextAlign.center,
            style: context.headlineMedium,
          ),
        ),
      );

  Widget _buildInProgress({bool alsoLoading = false}) {
    final finding = Text('Finding you...', style: context.headlineMedium);
    return GestureDetector(
      onTap: () => context.pushNamed(AppRoutes.searchLocation.name),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(
          horizontal: 60,
        ),
        child: alsoLoading
            ? Column(
                children: [
                  finding,
                  const SizedBox(height: 6),
                  const AppCircularProgressIndicator(
                    color: Colors.black,
                  ),
                ],
              )
            : finding,
      ),
    );
  }

  Widget _buildNoResult() => _buildErrorAddress('');

  Widget _buildAddressName(BuildContext context, String address) =>
      GestureDetector(
        onTap: () => context.pushNamed(AppRoutes.searchLocation.name),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, _) {
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(
                horizontal: 60,
              ),
              child: Column(
                children: [
                  Text(
                    address,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: context.headlineLarge
                        ?.copyWith(fontWeight: AppFontWeight.semiBold),
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  ListenableBuilder(
                    listenable: _animationController,
                    builder: (context, _) {
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 150),
                        opacity: _opacityAnimation.value,
                        child: Container(
                          width: 220,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xxs,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.md + AppSpacing.sm + 12,
                            ),
                          ),
                          child: const Text(
                            'Change delivery address',
                            maxLines: 1,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      );

  Widget _buildNoInternet() => Text(
        'No Internet',
        textAlign: TextAlign.center,
        style: context.headlineMedium,
      ).ignorePointer(isMoving: _isMoving);

  Widget _buildMap(BuildContext context) {
    return SizedBox(
      height: context.screenHeight,
      width: context.screenWidth,
      child: StreamBuilder<LatLng>(
        stream: _locationService.locationHelper.dynamicMarkerPositionStream,
        builder: (context, snapshot) {
          return Stack(
            children: [
              GoogleMap(
                onMapCreated: _locationService.locationHelper.onMapCreated,
                mapType: _locationService.locationHelper.mapType,
                initialCameraPosition:
                    _locationService.locationHelper.initialCameraPosition,
                myLocationEnabled: true,
                mapToolbarEnabled: false,
                myLocationButtonEnabled: false,
                indoorViewEnabled: true,
                padding: const EdgeInsets.fromLTRB(0, 100, 12, 160),
                zoomControlsEnabled: _animationController.isCompleted,
                onCameraMoveStarted: () {
                  if (mounted) {
                    _locationService.locationHelper
                        .onCameraStarted(_animationController);
                  }
                },
                onCameraIdle: () {
                  if (mounted) {
                    _locationService.locationHelper.onCameraIdle(
                      isLoading: _isLoading,
                      _animationController,
                    );
                  }
                },
                onCameraMove: (CameraPosition position) {
                  if (mounted) {
                    _locationService.locationHelper.onCameraMove(position);
                  }
                },
              ),
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 100, right: AppSpacing.md),
                  child: Assets.icons.pinIcon.svg(height: 50, width: 50),
                ).ignorePointer(isMoving: true),
              ),
            ],
          );
        },
      ),
    );
  }

  Positioned _buildAddress(BuildContext context) => Positioned(
        top: 100,
        right: 0,
        left: 0,
        child: StreamBuilder<AddressResult>(
          stream: _locationService.locationBloc.addressName,
          builder: (context, snapshot) {
            final addressResult = snapshot.data;
            if (addressResult is AddressError) {
              final error = addressResult.error.toString();
              return _buildErrorAddress(error)
                  .ignorePointer(isMoving: _isMoving);
            }
            if (addressResult is InProgress) {
              return _buildInProgress();
            }
            if (addressResult is Loading) {
              return _buildInProgress(alsoLoading: true);
            }
            if (addressResult is AddressWithNoResult) {
              return _buildNoResult();
            }
            if (addressResult is AddressNoInternet) {
              return _buildNoInternet();
            }
            if (addressResult is AddressWithResult) {
              final address = addressResult.address;
              return _buildAddressName(context, address);
            }
            return _buildNoResult();
          },
        ),
      );

  Widget _buildNavigateToPlaceDetailsAndPopBtn(BuildContext context) =>
      Positioned(
        left: AppSpacing.md,
        top: AppSpacing.md,
        child: ListenableBuilder(
          listenable: _animationController,
          builder: (context, child) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: _opacityAnimation.value,
              child: Row(
                children: [
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadowEffect.defaultValue,
                      ],
                    ),
                    child: AppIcon(
                      icon: Icons.adaptive.arrow_back_sharp,
                      type: IconType.button,
                      onPressed: context.pop,
                    ),
                  ),
                  const SizedBox(
                    width: AppSpacing.md,
                  ),
                  if (widget.placeDetails != null)
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadowEffect.defaultValue,
                        ],
                      ),
                      child: AppIcon(
                        icon: LucideIcons.send,
                        type: IconType.button,
                        onPressed: () {
                          _locationService.locationHelper
                              .navigateToPlaceDetails(
                            widget.placeDetails,
                          );
                        },
                      ),
                    ),
                ],
              ).ignorePointer(isMoving: _isMoving),
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Stack(
        children: [
          _buildMap(context),
          _buildAddress(context),
          _buildNavigateToPlaceDetailsAndPopBtn(context),
          _buildSaveLocationBtn(context),
        ],
      ),
      floatingActionButton: ListenableBuilder(
        listenable: _animationController,
        builder: (context, child) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: _opacityAnimation.value,
            child: FloatingActionButton(
              onPressed:
                  _locationService.locationHelper.navigateToCurrentPosition,
              elevation: 3,
              shape: const CircleBorder(),
              backgroundColor: Colors.white,
              child: const AppIcon(icon: LucideIcons.circleDot),
            ).ignorePointer(isMoving: _isMoving),
          );
        },
      ),
    );
  }
}
