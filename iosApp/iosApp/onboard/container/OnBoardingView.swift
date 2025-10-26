//
//  OnBoardingView.swift
//  iosApp
//
//  Created by Monokouma on 24/10/2025.
//

import SwiftUI

struct OnBoardingView: View {
    @State private var path = NavigationPath()

    var body: some View {
        
        NavigationStack(path: $path) {
            WelcomeView(path: $path)
                .navigationDestination(for: String.self) { destination in
                    if destination == "auth" {
                        AuthView().navigationBarBackButtonHidden(true)
                    }
            }
        }
        
    }
}

#Preview {
    OnBoardingView()
}
