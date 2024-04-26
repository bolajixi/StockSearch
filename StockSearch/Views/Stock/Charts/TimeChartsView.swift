//
//  TimeChartsView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/11/24.
//

import SwiftUI

struct TimeChartsView: View {
    let stocktTicker: String
    let stockColor: String

    let price: [[Any]]
    let volume: [[Any]]
    let ohlc: [[Any]]
    @State var selectedTab = "hourly"
    
    var hourlyChartOptions: String {
        """
        Highcharts.chart('container', {
            title: { text: `\(stocktTicker) Hourly Price Variation`, style: { color: '#333333'} },
            xAxis: {
                  type: 'datetime',
                  dateTimeLabelFormats: {
                        month: '%e %b',
                        hour: '%H:%M'
                  },
            },
            yAxis: [
                {
                    title: {
                        text: ''
                    },
                    labels: {
                        align: 'right',
                        x: 0,
                        y: -3,
                    },
                    opposite: true,
                }
            ],
            tooltip: {
                split: true
            },
            scrollbar: {
                enabled: true
            },
            legend: {
                enabled: false
            },
            series: [
                {
                    name: '\(stocktTicker)',
                    type: 'line',
                    data: \(price),
                    color: '\(stockColor)',
                    tooltip: {
                        valueDecimals: 2
                    },
                    marker: {
                        enabled: false
                    }
                },
            ],
        });
        """
    }
    
    var historicalChartOptions: String {
        """
        Highcharts.stockChart('container', {
            title: { text: `\(stocktTicker) Historical`, style: { color: '#333333'} },
            subtitle: {
                text: 'With SMA and Volume by Price technical indicators'
            },
            rangeSelector: {
                selected: 2
            },
            tooltip: {
                split: true
            },
            xAxis: {
                type: 'datetime',
                labels: {
                    format: '{value:%e %b}'
                }
            },
            yAxis: [
                {
                    startOnTick: false,
                    endOnTick: false,
                    labels: {
                        align: 'right',
                        x: -3
                    },
                    title: {
                        text: 'OHLC'
                    },
                    opposite: true,
                    height: '60%',
                    lineWidth: 2,
                    resize: {
                        enabled: true
                    }
                }, {
                    labels: {
                        align: 'right',
                        x: -3
                    },
                    title: {
                        text: 'Volume'
                    },
                    opposite: true,
                    top: '65%',
                    height: '35%',
                    offset: 0,
                    lineWidth: 2
                }
            ],
            chart: {
                height: 430,
            },
            series: [
                {
                    name: '\(stocktTicker)',
                    type: 'candlestick',
                    id: 'stockTicker',
                    data: \(ohlc),
                    zIndex: 2,
                },
                {
                    name: 'Volume',
                    type: 'column',
                    id: 'stockVolume',
                    data: \(volume),
                    yAxis: 1,
                    tooltip: {
                        valueDecimals: 2
                    },
                },
                {
                    linkedTo: 'stockTicker',
                    type: 'vbp',
                    params: {
                        volumeSeriesID: 'stockVolume'
                    },
                    dataLabels: {
                        enabled: false
                    },
                    zoneLines: {
                        enabled: false
                    }
                },
                {
                    linkedTo: 'stockTicker',
                    type: 'sma',
                    zIndex: 1,
                    marker: {
                        enabled: false
                    }
                }
            ],
        });
        """
    }
    
    var body: some View {
        TabView {
            HighchartsView(chartOptions: hourlyChartOptions)
                .tabItem {
                    Image(systemName: "chart.xyaxis.line")
                        .font(.title2)
                    Text("Hourly")
                }
            
            HighchartsView(chartOptions: historicalChartOptions)
                .tabItem {
                    Image(systemName: selectedTab == "historical" ? "clock.fill" : "clock")
                        .font(.title2)
                    Text("Historical")
                }
        }
    }
}

#Preview {
    TimeChartsView(
        stocktTicker: "AAPL",
        stockColor: "green",
        price: [
            [1712822400000, 168.09],
            [1712826000000, 168.08],
            [1712829600000, 168.16],
            [1712833200000, 167.83],
            [1712836800000, 168.52]
       ],
        volume: [
            [1650254400000, 69023941],
            [1650340800000, 67723833],
            [1650427200000, 67929814],
            [1650513600000, 87227768],
            [1650600000000, 84875424]
        ],
        ohlc: [
            [1650254400000, 163.92, 166.5984, 163.57, 165.07],
            [1650340800000, 165.02, 167.82, 163.91, 167.4],
            [1650427200000, 168.76, 168.88, 166.1, 167.23],
            [1650513600000, 168.91, 171.53, 165.91, 166.42],
            [1650600000000, 166.46, 167.8699, 161.5, 161.79]
        ]
    )
}
