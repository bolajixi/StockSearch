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
    
    private var chartOptions: String {
        """
        Highcharts.stockChart('container', {
            "title": {
                "text": "RecommendationTrends",
                "style": {
                    "color": "#333333"
                }
            },
            "tooltip": {
                "split": true
            },
            "xAxis": {
                "type": "datetime",
                "categories": \(arrayToString(periods)),
                "labels": {
                    "format": "{value:%Y-%b}"
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
                    "name": "StrongBuy",
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
                    "name": "StrongSell",
                    "data": \(arrayToString(strongSell)),
                    "color": "rgb(103,39,42)"
                }
            ],
            "chart": {
                "type": "column",
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
    RecommendationChartsView(
        strongBuy: ["5", "7", "6", "4", "8"],
        buy: ["3", "6", "8", "5", "7"],
        hold: ["7", "5", "4", "6", "8"],
        sell: ["4", "6", "5", "7", "9"],
        strongSell: ["8", "9", "7", "5", "6"],
        periods: ["1648378800", "1648465200", "1648551600", "1648638000", "1648724400"]
    )
}
