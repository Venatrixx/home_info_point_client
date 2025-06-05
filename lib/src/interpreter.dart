part of 'hip_client.dart';

/// Helper function used to convert the html response from Home.InfoPoint into json format.
Map interpretData(String htmlString) {
  final document = parser.parse(htmlString);

  Map data = {};

  final tables01 = document.querySelectorAll('table[class="t01"]');

  data['name'] = tables01[0].children[0].children[0].children[1].text;
  final classString = tables01[0].children[0].children[1].children[1].text;
  final truncClassString = classString.substring(0, classString.indexOf(RegExp('[^0-9A-Z]')));
  data['class'] = truncClassString;
  data['level'] = int.tryParse(truncClassString.substring(0, truncClassString.indexOf(RegExp('[^0-9]'))));

  RegExp subjectTitlePattern = RegExp(r'[a-zA-ZäöüÄÖÜß\(\)]+[-]+[a-zA-ZäöüÄÖÜß]+\(+');
  final htmlData = document.querySelectorAll('h3, table[class="t02"]');

  List subjects = [];

  for (int i = 0; i < htmlData.length; i++) {
    if (htmlData[i].localName == 'h3' && RegExp(r'[a-zA-Z]+').hasMatch(htmlData[i].text)) {
      if (htmlData[i].text == "Fehltage") {
        List missingDays = [];
        for (final row in htmlData[i + 1].children[0].children..removeAt(0)) {
          Map missingDay = {};
          missingDay['date'] = row.children[0].text;
          missingDay['reason'] = row.children[1].text;
          missingDay['excused'] = row.children[2].text;
          missingDay['semester'] = row.children[3].text;
          missingDays.add(missingDay);
        }
        data['missingDays'] = missingDays;
      } else if (htmlData[i].text == "Fehlstunden") {
        List missingHours = [];
        for (final row in htmlData[i + 1].children[0].children..removeAt(0)) {
          Map missingHour = {};
          missingHour['date'] = row.children[0].text;
          missingHour['subject'] = row.children[1].text;
          missingHour['time'] = row.children[2].text;
          missingHour['reason'] = row.children[3].text;
          missingHour['excused'] = row.children[4].text;
          missingHour['semester'] = row.children[5].text;
          missingHours.add(missingHour);
        }
        data['missingHours'] = missingHours;
      } else if (htmlData[i].text == "Zusammenfassung") {
        final rows = htmlData[i + 1].children[0].children;
        data['totalMissingDays'] = int.tryParse(rows[0].children[1].text);
        data['totalUnexcusedMissingDays'] = int.tryParse(rows[1].children[1].text);

        data['totalMissingHours'] = int.tryParse(
          rows[2].children[1].text.substring(0, rows[2].children[1].text.indexOf(RegExp(r'[^0-9]'))),
        );
        data['totalUnexcusedMissingHours'] = int.tryParse(
          rows[3].children[1].text.substring(0, rows[3].children[1].text.indexOf(RegExp('[^0-9]'))),
        );
      }
    }

    if (htmlData[i].localName != 'h3' || !subjectTitlePattern.hasMatch(htmlData[i].text.replaceAll(RegExp(r' '), ''))) {
      continue;
    }

    Map subject = {};

    final String subjectTitle = htmlData[i].text;

    subject['name'] = subjectTitle.substring(subjectTitle.indexOf('-') + 1, subjectTitle.lastIndexOf('(')).trim();
    subject['abbr'] = subjectTitle.substring(0, subjectTitle.indexOf('-')).trim();

    subject['finalGradeSem1'] = null;
    subject['finalGradeSem2'] = null;

    for (final row in htmlData[i + 2].children[0].children..removeAt(0)) {
      try {
        String sem = row.children[0].text;
        if (!row.children[2].text.toLowerCase().contains('schnitt')) {
          if (sem.contains('1')) {
            subject['finalGradeSem1'] = row.children[1].text;
          } else if (sem.contains('2')) {
            subject['finalGradeSem2'] = row.children[1].text;
          }
        }
      } catch (_) {}
    }

    List grades = [];

    final rows = (htmlData[i + 1].children[0].children)..removeAt(0);

    for (int j = 0; j < rows.length; j++) {
      final row = rows[j];

      Map grade = {};
      grade['date'] = row.children[0].text;
      grade['value'] = row.children[1].text;
      grade['comment'] = row.children[2].text;
      grade['isExam'] = (['klausur', 'klassenarbeit', 'ka'].any(row.children[3].text.toLowerCase().contains));
      grade['semester'] = int.parse(row.children[4].text.substring(0, row.children[4].text.indexOf(RegExp('[^0-9]'))));

      grades.add(grade);
    }

    subject['grades'] = grades;

    subjects.add(subject);
  }

  data['subjects'] = subjects;

  return data;
}
