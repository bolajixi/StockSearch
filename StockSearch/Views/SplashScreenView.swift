//
//  SplashScreenView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/6/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isShowingProgress = false
    @State private var isShowingHome = false
    @State private var isActive = false
    let splashScreenDuration = 2.5
    
    var body: some View {
        if isShowingHome {
            HomeView()
        } else {
            VStack {
                if isShowingProgress {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation {
                                    self.isShowingHome = true
                                }
                            }
                        }
                } else {
                    Image("AppIcon_512")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 290, height: 290)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + splashScreenDuration) {
                                withAnimation {
                                    self.isShowingProgress = true
                                }
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
        .environmentObject(StockViewModel())
        .environmentObject(WatchlistViewModel())
        .environmentObject(PortfolioViewModel())
}
