//
//  SplashScreenView.swift
//  StockSearch
//
//  Created by Mobolaji Olawale on 4/6/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    let splashScreenDuration = 3.0
    
    var body: some View {
        if isActive {
            HomeView()
        } else {
            VStack {
                Image(systemName: "hare.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.red)
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + splashScreenDuration) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
