//
//  RecommendationChartsView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/11/24.
//

import SwiftUI

struct RecommendationChartsView: View {
    var strongBuy: [String]
    var buy: [String]
    var hold: [String]
    var sell: [String]
    var strongSell: [String]
    var periods: [String]
    
    var chartOptions: String {
        """
        Highcharts.chart('container', {
            "title": {
                "text": "Recommendation Trends",
                "style": {
                    "color": "#333333"
                }
            },
            "tooltip": {
                "headerFormat": '{point.x}<br/>',
                "pointFormat": '`<span style="color: {point.color}">\\u25CF</span> {series.name}: <b>{point.y}</b>'
            },
            "xAxis": {
                "categories": \(periods),
                "labels": {
                    format: '{value:%Y-%b}'
                }
            },
            "yAxis": {
                "title": {
                    "text": "#Analysis"
                },
                "min": 0
            },
            "plotOptions": {
                "column": {
                    "dataLabels": {
                        "enabled": true
                    },
                    "stacking": "normal"
                }
            },
            "series": [
                {
                    "type": "column",
                    "name": "Strong Buy",
                    "data": \(arrayToString(strongBuy)),
                    "color": "rgb(22,94,43)"
                },
                {
                    "type": "column",
                    "name": "Buy",
                    "data": \(arrayToString(buy)),
                    "color": "rgb(32,149,61)"
                },
                {
                    "type": "column",
                    "name": "Hold",
                    "data": \(arrayToString(hold)),
                    "color": "rgb(134,99,22)"
                },
                {
                    "type": "column",
                    "name": "Sell",
                    "data": \(arrayToString(sell)),
                    "color": "rgb(199,72,73)"
                },
                {
                    "type": "column",
                    "name": "Strong Sell",
                    "data": \(arrayToString(strongSell)),
                    "color": "rgb(103,39,42)"
                }
            ],
            "chart": {
                "type": "column",
            }
        });
        """
    }
    
    var body: some View {
        HighchartsView(
            chartOptions: chartOptions
        )
        .frame(width: UIScreen.main.bounds.width, height: 350)
    }
    
    func arrayToString(_ array: [String]) -> String {
        return "[" + array.joined(separator: ", ") + "]"
    }

}

#Preview {
    RecommendationChartsView(
        strongBuy: ["11", "12", "12", "12"],
        buy: ["20", "20", "19", "22"],
        hold: ["14", "14", "13", "13"],
        sell: ["2", "2", "2", "1"],
        strongSell: ["8", "9", "7", "5"],
        periods: ["2024-04", "2024-03", "2024-02", "2024-01"]
    )
}
