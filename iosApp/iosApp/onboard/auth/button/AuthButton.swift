//
//  AuthButton.swift
//  iosApp
//
//  Created by Monokouma on 31/10/2025.
//

import SwiftUI

struct AuthButton: View {
    let provider: AuthProvider
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                
                if let imageName = provider.imageName {
                    if provider.isSystemImage {
                        Image(systemName: imageName)
                            .frame(width: 24, height: 24)
                            .fontWeight(.regular)
                    } else {
                        Image(imageName)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                
                
                Text(provider.title)
                    .font(.system(size: 16, weight: .semibold))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 12)
        }
        .buttonStyle(
            RoundButtonStyle(
                backgroundColor: provider.backgroundColor,
                foregroundColor: provider.foregroundColor,
                cornerRadius: provider.cornerRadius,
                borderColor: provider.borderColor,
                borderWidth: provider.borderWidth
            )
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 2)
        .frame(minHeight: 48)
    }
}


enum AuthProvider {
    case google
    case apple
    case meta
    case guest
    
    var title: String {
        switch self {
        case .google:
            return "Continuer avec Google"
        case .apple:
            return "Continuer avec Apple"
        case .meta:
            return "Continuer avec Meta"
        case .guest:
            return "Continuer en tant qu'invité"
        }
    }
    
    var imageName: String? {
        switch self {
        case .google:
            return "google_icon"
        case .apple:
            return "apple.logo"
        case .meta:
            return "meta_icon"
        case .guest:
            return nil
        }
    }
    
    var isSystemImage: Bool {
        switch self {
        case .apple:
            return true
        default:
            return false
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .google, .meta:
            return .textColor1
        case .apple:
            return .backgroundColor1
        case .guest:
            return .backgroundColor3
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .google:
            return .backgroundColor1
        case .apple, .guest:
            return .textColor1
        case .meta:
            return Color(red: 0, green: 0.506, blue: 0.984)
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .guest:
            return .infinity
        default:
            return 8
        }
    }
    
    var borderColor: Color? {
        switch self {
        case .google:
            return .textColor2
        case .apple:
            return .textColor1
        case .meta:
            return .backgroundColor3
        case .guest:
            return nil
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .google, .meta:
            return 2
        case .apple:
            return 0.4
        case .guest:
            return 0
        }
    }
}
#Preview {
    AuthButton(provider: .apple) {
        
    }
}
