//
//  HighchartsView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/11/24.
//

import SwiftUI
import WebKit

struct HighchartsView: UIViewRepresentable {
    let htmlContent: String = "<!DOCTYPE html><html><head><script src=\"https://code.highcharts.com/highcharts.js\"></script></head><body><div id=\"container\" style=\"width:100%; height:100%;\"></div></body></html>"
    
    let chartOptions: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let modifiedHTMLContent = "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=3.0, minimum-scale=1.0, user-scalable=yes\"> \(htmlContent)"
        uiView.loadHTMLString(modifiedHTMLContent, baseURL: nil)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(chartOptions: chartOptions)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        let chartOptions: String

        init(chartOptions: String) {
            self.chartOptions = chartOptions
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript(chartOptions, completionHandler: nil)
        }
    }
}

#Preview {
    HighchartsView(chartOptions: "Highcharts.chart('container', { chart: { type: 'bar' }, title: { text: 'Fruit Consumption' }, xAxis: { categories: ['Apples', 'Bananas', 'Oranges'] }, yAxis: { title: { text: 'Fruit eaten' } }, series: [{ name: 'Jane', data: [1, 0, 4] }, { name: 'John', data: [5, 7, 3] }] });")
}
