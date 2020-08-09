import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter_svg/flutter_svg.dart';

class XDiPhoneXXS11Pro2 extends StatelessWidget {
  XDiPhoneXXS11Pro2({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
          Transform.translate(
            offset: Offset(108.0, 82.0),
            child: Container(
              width: 160.0,
              height: 150.0,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                color: const Color(0xffffffff),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(128.5, 108.5),
            child: SvgPicture.string(
              _svg_2glplg,
              allowDrawingOutsideViewBox: true,
            ),
          ),
          Transform.translate(
            offset: Offset(129.0, 42.0),
            child: Text(
              'Logo Company',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 15,
                color: const Color(0xff707070),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(108.0, 259.0),
            child: Text(
              'Name : Comapany',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 20,
                color: const Color(0xff1e3ede),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(40.0, 475.0),
            child:
                // Adobe XD layer: 'Continue' (group)
                SizedBox(
              width: 295.0,
              height: 48.0,
              child: Stack(
                children: <Widget>[
                  Pinned.fromSize(
                    bounds: Rect.fromLTWH(0.0, 0.0, 295.0, 48.0),
                    size: Size(295.0, 48.0),
                    pinLeft: true,
                    pinRight: true,
                    pinTop: true,
                    pinBottom: true,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        color: const Color(0xff2699fb),
                      ),
                    ),
                  ),
                  Pinned.fromSize(
                    bounds: Rect.fromLTWH(129.0, 19.0, 38.0, 11.0),
                    size: Size(295.0, 48.0),
                    fixedWidth: true,
                    fixedHeight: true,
                    child: Text(
                      'Over All',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 10,
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(40.0, 563.0),
            child:
                // Adobe XD layer: 'Continue' (group)
                SizedBox(
              width: 295.0,
              height: 48.0,
              child: Stack(
                children: <Widget>[
                  Pinned.fromSize(
                    bounds: Rect.fromLTWH(0.0, 0.0, 295.0, 48.0),
                    size: Size(295.0, 48.0),
                    pinLeft: true,
                    pinRight: true,
                    pinTop: true,
                    pinBottom: true,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        color: const Color(0xff2699fb),
                      ),
                    ),
                  ),
                  Pinned.fromSize(
                    bounds: Rect.fromLTWH(118.0, 19.0, 60.0, 11.0),
                    size: Size(295.0, 48.0),
                    fixedWidth: true,
                    fixedHeight: true,
                    child: Text(
                      'Limited Date',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 10,
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const String _svg_2glplg =
    '<svg viewBox="128.5 108.5 123.0 97.0" ><path transform="translate(128.5, 108.5)" d="M 0 0 L 123 91" fill="none" stroke="#707070" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(128.5, 108.5)" d="M 118 0 L 0 97" fill="none" stroke="#707070" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
