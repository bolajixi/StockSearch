//
//  TimeChartsView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/11/24.
//

import SwiftUI

struct TimeChartsView: View {
    var body: some View {
        VStack {
            TabView {
                // Hourly charts
                HighchartsView(
                    chartOptions: "Highcharts.chart('container', { chart: { type: 'bar' }, title: { text: 'Fruit Consumption' }, xAxis: { categories: ['Apples', 'Bananas', 'Oranges'] }, yAxis: { title: { text: 'Fruit eaten' } }, series: [{ name: 'Jane', data: [1, 0, 4] }, { name: 'John', data: [5, 7, 3] }] });"
                )
    //            .frame(width: 410, height: 350)
                .tabItem {
                    Image(systemName: "chart.xyaxis.line")
                    Text("Hourly")
                }
                
                // Yearly charts
                HighchartsView(
                    chartOptions: "Highcharts.chart('container', { chart: { type: 'bar' }, title: { text: 'Fruit Consumption' }, xAxis: { categories: ['Apples', 'Bananas', 'Oranges'] }, yAxis: { title: { text: 'Fruit eaten' } }, series: [{ name: 'Jane', data: [1, 0, 4] }, { name: 'John', data: [5, 7, 3] }] });"
                )
    //            .frame(width: 410, height: 350)
                .tabItem {
                    Image(systemName: "clock")
                    Text("Historical")
                }
            }
        }
    }
}

#Preview {
    TimeChartsView()
}
