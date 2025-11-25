//
//  OnBoardingView.swift
//  iosApp
//
//  Created by Monokouma on 24/10/2025.
//

import SwiftUI

struct OnBoardingView: View {
    @State private var path = NavigationPath()
    let onAuthComplete: () -> Void
    
    var body: some View {
        NavigationStack(path: $path) {
            WelcomeView(path: $path)
                .navigationDestination(for: String.self) { destination in
                    if destination == "auth" {
                        AuthView(
                            path: $path,
                            onAuthComplete: onAuthComplete
                        )
                        .navigationBarBackButtonHidden(true)
                    }
                }
        }
    }
}

#Preview {
    OnBoardingView(onAuthComplete: {
        print("Auth complete!")
    })
}
