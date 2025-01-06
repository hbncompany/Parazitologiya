import 'package:flutter/material.dart';

class TextSection extends StatelessWidget {
  final String _title;
  final String _body;
  static const double _hPad = 16.0;

  TextSection(this._title, this._body);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          // decoration: BoxDecoration(
          //   boxShadow: const [
          //     // BoxShadow(color: Colors.green, spreadRadius: 8),
          //     BoxShadow(color: Color(0x4cffeb3b), spreadRadius: 5),
          //   ],
          // ),
          // padding: const EdgeInsets.fromLTRB(_hPad, 32.0, _hPad, 4.0),
          child: Text(_title,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  shadows: [
                    Shadow(
                      color: Colors.black, // Choose the color of the shadow
                      blurRadius:
                          2.0, // Adjust the blur radius for the shadow effect
                      offset: Offset(2.0,
                          2.0), // Set the horizontal and vertical offset for the shadow
                    ),
                  ],
                  fontSize: 16,
                  color: Color(0xff21d4f3))),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(_hPad, 7.0, _hPad, _hPad),
          child: Text(
            _body,
          ),
        ),
      ],
    );
  }
}


class TextSectionone extends StatelessWidget {
  final String _title;
  static const double _hPad = 16.0;

  TextSectionone(this._title);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(_hPad, 10.0, 0, 10.0),
          child: Container(
            child: Text(
              _title,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                color: Color(0xff090cf4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TextSectiontwo extends StatelessWidget {
  final double containerWidthFraction = 0.45;
  final double containerHeightFraction = 0.15;
  final String _title;
  static const double _hPad = 20.0;

  TextSectiontwo(this._title);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          // padding: const EdgeInsets.fromLTRB(1, 10.0, 1, 10.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * containerHeightFraction*0.5,
            width: MediaQuery.of(context).size.width * containerWidthFraction*1.2,
            child: Container(
              color: Colors.black38,
              child: Align(
                alignment: Alignment.center, // Aligns child in the center of the container
                child: Text(
                  _title,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          color: Colors.black, // Choose the color of the shadow
                          blurRadius:
                          3.0, // Adjust the blur radius for the shadow effect
                          offset: Offset(3.0,
                              3.0), // Set the horizontal and vertical offset for the shadow
                        ),
                      ],
                      fontSize: 18,
                      color: Color(0xff21d4f3),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
