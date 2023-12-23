import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

import 'main/side_menu_page.dart';

const _tex = r'''
<p>                                
  When \(a \ne 0 \), there are two solutions to \(ax^2 + bx + c = 0\) and they are
  $$x = {-b \pm \sqrt{b^2-4ac} \over 2a}.$$
</p>
''';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SideMenuPage(
      title: 'Dashboard',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TeXView(
            child: TeXViewColumn(children: [
              TeXViewInkWell(
                id: 'id_0',
                child: TeXViewColumn(
                  children: [
                    TeXViewDocument(
                      r'''<h2>Flutter \( \rm\\TeX \)</h2>''',
                      style: TeXViewStyle(textAlign: TeXViewTextAlign.center),
                    ),
                    TeXViewDocument(
                      _tex,
                      style: TeXViewStyle.fromCSS('padding: 15px; color: white; background: green'),
                    ),
                  ],
                ),
              )
            ]),
            style: TeXViewStyle(
              elevation: 10,
              borderRadius: TeXViewBorderRadius.all(25),
              border: TeXViewBorder.all(TeXViewBorderDecoration(
                  borderColor: Colors.blue, borderStyle: TeXViewBorderStyle.solid, borderWidth: 5)),
              backgroundColor: Colors.white,
            ),
          ),
          SizedBox(height: 50),
          Text(_tex)
        ],
      ),
    );
  }
}
