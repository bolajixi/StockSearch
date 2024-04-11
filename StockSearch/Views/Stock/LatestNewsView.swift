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
        VStack (alignment: .leading) {
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
        VStack (alignment: .leading, spacing: 0) {
            AsyncImageView(url: URL(string: newsItem.image), width: 400, height: 250)
                .padding(.vertical, 10)
            
            VStack (alignment: .leading) {
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
            VStack(alignment: .leading) {
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
    @Environment(\.presentationMode) var presentationMode
    let newsItem: NewsItem
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack(content: {
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                        .font(.headline)
                        .padding(10)
                })
                .frame(width: 30, height: 30)
            })
            
            Text(newsItem.source)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            Text(newsItem.datetime)
                .font(.headline)
                .foregroundStyle(.gray)
            
            Divider()
                .padding(.vertical, 10)
            
            Text(newsItem.headline)
                .font(.headline)
            
            Text(newsItem.summary)
            
            HStack {
                Text("For more details click")
                    .foregroundColor(Color.gray.opacity(0.8))
                
                Button(action: {
                    if let url = URL(string: newsItem.url) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("here")
                        .foregroundColor(Color.blue)
                        .padding(0)
                }
            }
            .fontWeight(.medium)
            .padding(0.5)
            
            HStack {
                ShareButton(shareLink: "https://twitter.com/intent/tweet?text=\(newsItem.headline)&url=\(newsItem.url)",
                            shareImage: "x_share_icon",
                            width: 50,
                            height: 50)
                
                ShareButton(shareLink: "https://www.facebook.com/sharer/sharer.php?u=\(newsItem.url)",
                            shareImage: "fb_share_icon",
                            width: 50,
                            height: 50)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct ShareButton: View {
    let shareLink: String
    let shareImage: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Button(action: {
            guard let url = URL(string: shareLink) else { return }
            UIApplication.shared.open(url)
        }) {
            Image(shareImage)
                .resizable()
                .scaledToFit()
                .frame(width: width, height: height)
        }
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
