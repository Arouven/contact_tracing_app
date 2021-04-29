import 'package:flutter/material.dart';
import '../pages/custom_crs/custom_crs.dart';
import '../pages/live_location.dart';
import '../pages/home.dart';
import '../pages/wms_tile_layer.dart';

Widget _buildMenuItem(
    BuildContext context, Widget title, String routeName, String currentRoute) {
  var isSelected = routeName == currentRoute;

  return ListTile(
    title: title,
    selected: isSelected,
    onTap: () {
      if (isSelected) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(context, routeName);
      }
    },
  );
}

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        const DrawerHeader(
          child: Center(
            child: Text('Contact Tracing'),
          ),
        ),
        _buildMenuItem(
          context,
          const Text('OpenStreetMap'),
          HomePage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('WMS Layer'),
          WMSLayerPage.route,
          currentRoute,
        ),
        // _buildMenuItem(
        //   context,
        //   const Text('Custom CRS'),
        //   CustomCrsPage.route,
        //   currentRoute,
        // ),
        // _buildMenuItem(
        //   context,
        //   const Text('Add Pins'),
        //   TapToAddPage.route,
        //   currentRoute,
        // ),
        // _buildMenuItem(
        //   context,
        //   const Text('Esri'),
        //   EsriPage.route,
        //   currentRoute,
        // ),
        // _buildMenuItem(
        //   context,
        //   const Text('Polylines'),
        //   PolylinePage.route,
        //   currentRoute,
        // ),
        // _buildMenuItem(
        //   context,
        //   const Text('MapController'),
        //   MapControllerPage.route,
        //   currentRoute,
        // ),
        // _buildMenuItem(
        //   context,
        //   const Text('Animated MapController'),
        //   AnimatedMapControllerPage.route,
        //   currentRoute,
        // ),
        // _buildMenuItem(
        //   context,
        //   const Text('Marker Anchors'),
        //   MarkerAnchorPage.route,
        //   currentRoute,
        // ),
        // _buildMenuItem(
        //   context,
        //   const Text('Marker Rotate'),
        //   MarkerRotatePage.route,
        //   currentRoute,
        // ),
        // _buildMenuItem(
        //   context,
        //   const Text('Plugins'),
        //   PluginPage.route,
        //   currentRoute,
        // ),
        // _buildMenuItem(
        //   context,
        //   const Text('ScaleBar Plugins'),
        //   PluginScaleBar.route,
        //   currentRoute,
        // ),
        // _buildMenuItem(
        //   context,
        //   const Text('ZoomButtons Plugins'),
        //   PluginZoomButtons.route,
        //   currentRoute,
        // ),
        // _buildMenuItem(
        //   context,
        //   const Text('Offline Map'),
        //   OfflineMapPage.route,
        //   currentRoute,
        // ),
        // _buildMenuItem(
        //   context,
        //   const Text('OnTap'),
        //   OnTapPage.route,
        //   currentRoute,
        // ),
        // _buildMenuItem(
        //   context,
        //   const Text('Moving Markers'),
        //   MovingMarkersPage.route,
        //   currentRoute,
        // ),
        // _buildMenuItem(
        //   context,
        //   const Text('Circle'),
        //   CirclePage.route,
        //   currentRoute,
        // ),
        // _buildMenuItem(
        //   context,
        //   const Text('Overlay Image'),
        //   OverlayImagePage.route,
        //   currentRoute,
        // ),
        // _buildMenuItem(
        //   context,
        //   const Text('Sliding Map'),
        //   SlidingMapPage.route,
        //   currentRoute,
        // ),
        // _buildMenuItem(
        //   context,
        //   const Text('Widgets'),
        //   WidgetsPage.route,
        //   currentRoute,
        // ),
        _buildMenuItem(
          context,
          const Text('Live Location Update'),
          LiveLocationPage.route,
          currentRoute,
        ),
        // _buildMenuItem(
        //   context,
        //   const Text('Tile loading error handle'),
        //   TileLoadingErrorHandle.route,
        //   currentRoute,
        // ),
        // _buildMenuItem(
        //   context,
        //   const Text('Tile builder'),
        //   TileBuilderPage.route,
        //   currentRoute,
        // ),
        // _buildMenuItem(
        //   context,
        //   const Text('Interactive flags test page'),
        //   InteractiveTestPage.route,
        //   currentRoute,
        // ),
      ],
    ),
  );
}
