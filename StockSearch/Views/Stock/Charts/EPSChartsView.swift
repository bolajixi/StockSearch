//
//  EPSChartsView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/11/24.
//

import SwiftUI

struct EPSChartsView: View {
    var body: some View {
        HighchartsView(
            chartOptions: "Highcharts.chart('container', { chart: { type: 'bar' }, title: { text: 'Fruit Consumption' }, xAxis: { categories: ['Apples', 'Bananas', 'Oranges'] }, yAxis: { title: { text: 'Fruit eaten' } }, series: [{ name: 'Jane', data: [1, 0, 4] }, { name: 'John', data: [5, 7, 3] }] });"
        )
        .frame(width: 410, height: 350)
    }
}

#Preview {
    EPSChartsView()
}
