//
//  EPSChartsView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/11/24.
//

import SwiftUI

struct EPSChartsView: View {
    let periods: [String]
    let actual: [[Any]]
    let estimate: [[Any]]
    
    var chartOptions: String {
         """
         Highcharts.chart('container', {
             title: {
                 text: "Historical EPS Surprises",
                 style: {
                     color: "#333333"
                 }
             },
             xAxis: {
                 type: 'datetime',
                 categories: \(periods),
             },
             yAxis: {
                 title: {
                     text: 'Quarterly EPS'
                 },
             },
             legend: {
                 align: "center",
                 verticalAlign: "bottom",
                 shadow: false,
                 borderColor: "#CCC",
             },
             tooltip: {
                 shared: true,
                 formatter: function () {
                     let tooltipText = '';
                     if (this.points && this.points.length > 0) {
                     tooltipText += `${this.x} <br>`;
                     
                     this.points.forEach(function(point) {
                         tooltipText += `<span style="color: ${point.color}">\\u25CF</span> ${point.series.name}: <b>${point.y}</b><br>`;
                     });
                     }
                     return tooltipText;
                 },
             },
             plotOptions: {
                 spline: {
                     marker: {
                         enable: false
                     }
                 }
             },
             series: [
                 {
                     name: 'Actual',
                     type: 'spline',
                     data: \(actual),
                 },{
                     name: 'Estimate',
                     type: 'spline',
                     data: \(estimate),
                 }
             ]
         })
        """
    }
    
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, content: {
            HighchartsView(
                chartOptions: chartOptions
            )
            .frame(width: UIScreen.main.bounds.width, height: 430)
        })
    }
}

#Preview {
    EPSChartsView(
        periods: ["2023-12-31<br>Surprise: 0.0399", "2023-09-30<br>Surprise: 0.0406", "2023-06-30<br>Surprise: 0.0417", "2023-03-31<br>Surprise: 0.0577"],
        actual: [["2023-12-31", 2.18], ["2023-09-30", 1.46], ["2023-06-30", 1.26], ["2023-03-31", 1.52]],
        estimate: [["2023-12-31", 2.1401], ["2023-09-30", 1.4194], ["2023-06-30", 1.2183], ["2023-03-31", 1.4623]]
    )
}
