//
//  EPSChartsView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/11/24.
//

import SwiftUI

struct EPSChartsView: View {
    let periods: [String]
    let actual: [String]
    let estimate: [String]
    
    private var chartOptions: String {
        """
        Highcharts.stockChart('container', {
            "title": {
                "text": "HistoricalEPSSurprises",
                "style": {
                    "color": "#333333"
                }
            },
            "xAxis": {
                "type": "datetime",
                "categories": \(arrayToString(periods)),
            },
            "yAxis": {
                "title": {
                    "text": "QuarterlyEPS"
                },
                "min": 0
            },
            "tooltip": {
                "shared": true,
                "formatter": "function() { let tooltipText = ''; if (this.points && this.points.length > 0) { tooltipText += `${this.x}<br>`; this.points.forEach(function(point) { tooltipText += `<span style=\"color:${point.color}\">\\u25CF</span>${point.series.name}:<b>${point.y}</b><br>`; }); } return tooltipText; }"
            },
            "legend": {
                "align": "center",
                "verticalAlign": "bottom",
                "shadow": false,
                "borderColor": "#CCC",
                "backgroundColor": "#f2f2f2"
            },
            "series": [
                {
                    "name": "Actual",
                    "type": "spline",
                    "data": \(arrayToString(actual))
                },
                {
                    "name": "Estimate",
                    "type": "spline",
                    "data": \(arrayToString(estimate))
                }
            ],
            "chart": {
                "backgroundColor": "#f2f2f2"
            }
        });
        """
    }
    
    var body: some View {
        HighchartsView(
            chartOptions: chartOptions
        )
        .frame(width: 410, height: 350)
    }
    
    func arrayToString(_ array: [String]) -> String {
        return "[" + array.joined(separator: ", ") + "]"
    }
}

#Preview {
    EPSChartsView(
        periods: ["1648378800", "1648465200", "1648551600", "1648638000", "1648724400"],
        actual: ["1648378800: 1.5", "1648465200: 1.6", "1648551600: 1.7", "1648638000: 1.8", "1648724400: 1.9"],
        estimate: ["1648378800: 1.3", "1648465200: 1.4", "1648551600: 1.5", "1648638000: 1.6", "1648724400: 1.7"]
    )
}
