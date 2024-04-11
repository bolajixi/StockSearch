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
        VStack {
            FirstNewsListItem(newsItem: newsItems[0])
                .padding(.vertical, 5)
                .onTapGesture {
                    selectedItem = newsItems[0]
                }
            Divider()
            
            ForEach(newsItems.indices, id: \.self) { index in
                if index != 0 {
                    VStack {
                        NewsListItem(newsItem: newsItems[index])
                            .padding(.vertical, 5)
                            .onTapGesture {
                                selectedItem = newsItems[index]
                            }
                        if index != newsItems.indices.last {
                            Divider()
                        }
                    }
                }
            }
            .sheet(item: $selectedItem) { selectedItem in
                NewsDetailsView(newsItem: selectedItem)
            }
        }
        .padding()
    }
}

struct FirstNewsListItem: View {
    let newsItem: NewsItem
    
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            AsyncImageView(url: URL(string: newsItem.image), width: 360, height: 250)
                .padding(.vertical, 10)
            
            VStack (alignment: .leading, spacing: 8) {
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
            
            AsyncImageView(url: URL(string: newsItem.image), width: 70, height: 70)
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

struct AsyncImageView: View {
    let url: URL?
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .frame(width: width, height: height)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(10)
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: width, height: height)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(18)
            @unknown default:
                EmptyView()
            }
        }
    }
}

#Preview {
    LatestNewsView(newsItems: [NewsItem.dummyData, NewsItem.dummyData2])
}
