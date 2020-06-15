import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import '../../../constants.dart';

class HalfGaugeChart extends StatelessWidget {
  final List<GaugeSegment> gaugeSegments;
  final List<charts.Series> seriesList;
  final bool animate;
  final int arcWidth;
  final String header;
  final String value;
  final int valueLines;

  HalfGaugeChart(
    this.gaugeSegments,
    this.seriesList,
    this.header,
    this.value, {
    this.animate,
    this.arcWidth = 20,
    this.valueLines = 1,
  });

  static HalfGaugeChart fromSegments(
    gaugeSegments,
    String header,
    String value, {
    bool animate = true,
    double arcWidth = 20.0,
    valueLines = 1,
  }) {
    var seriesList = [
      charts.Series<GaugeSegment, String>(
        id: 'Segments',
        colorFn: (GaugeSegment segment, _) =>
            charts.ColorUtil.fromDartColor(segment.color),
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        data: gaugeSegments,
      )
    ];
    return HalfGaugeChart(
      gaugeSegments,
      seriesList,
      header,
      value,
      animate: animate,
      valueLines: valueLines,
    );
  }

  @override
  Widget build(BuildContext context) {
    var valuePadding = valueLines > 1
        ? const EdgeInsets.only(top: 50.0)
        : const EdgeInsets.only(top: 60.0);

    var theme = Theme.of(context);
    return Container(
      width: miniInfoWidgetSize.width,
      height: miniInfoWidgetSize.height,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: charts.PieChart(
              seriesList,
              animate: animate,
              defaultRenderer: charts.ArcRendererConfig(
                arcWidth: arcWidth,
                startAngle: pi,
                arcLength: pi,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 105.0,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  header,
                  style: theme.textTheme.headline2.copyWith(fontSize: 30.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: valuePadding,
              child: Text(
                value,
                style: theme.textTheme.bodyText1.copyWith(fontSize: 18.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GaugeSegment {
  final String segment;
  final double size;
  final Color color;

  GaugeSegment(this.segment, this.size, this.color);
}
