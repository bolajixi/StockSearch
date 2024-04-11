//
//  LatestNewsView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/10/24.
//

import SwiftUI

struct LatestNewsView: View {
    let newsItems: [NewsItem]
    @State private var selectedItem: NewsItem?
    
    var body: some View {
        List(newsItems) { newsItem in
            NewsListItem(newsItem: newsItem)
                .onTapGesture {
                    selectedItem = newsItem
                }
        }
        .ignoresSafeArea()
        .sheet(item: $selectedItem) { selectedItem in
            NewsDetailsView(newsItem: selectedItem)
        }
    }
}

struct NewsListItem: View {
    let newsItem: NewsItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                let timeDifference = getTimeDifference(from: newsItem.datetime)
                
                HStack {
                    Text(newsItem.source)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text(timeDifference)
                }
                .foregroundStyle(.gray)
                .font(.footnote)
                
                Text(newsItem.headline)
                    .foregroundStyle(.black)
                    .font(.headline)
            }
            
            Spacer()
            
            AsyncImage(url: URL(string: newsItem.image)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: 70, height: 70)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(18)
                @unknown default:
                    EmptyView()
                }
            }
        }
    }
    
    private func getTimeDifference(from datetime: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        guard let newsDateTime = dateFormatter.date(from: datetime) else {
            return ""
        }
        
        let currentTime = Date()
        let timeDifference = currentTime.timeIntervalSince(newsDateTime)
        
        let hours = Int(timeDifference) / 3600
        let minutes = (Int(timeDifference) % 3600) / 60
        
        if hours > 0 {
            return "\(hours) hours, \(minutes) min"
        } else {
            return "\(minutes) min"
        }
    }
}

struct NewsDetailsView: View {
    let newsItem: NewsItem
    
    var body: some View {
        VStack {
            // Display the details of the news item
            Text("Category: \(newsItem.category)")
            Text("Headline: \(newsItem.headline)")
            Text("Source: \(newsItem.source)")
            // Add more details as needed
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    LatestNewsView(newsItems: [NewsItem.dummyData, NewsItem.dummyData2])
}
