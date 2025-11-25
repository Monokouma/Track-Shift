//
//  WebViewScreen.swift
//  iosApp
//
//  Created by Monokouma on 25/11/2025.
//

import SwiftUI
import WebKit

struct WebViewScreen: View {
    let url: String
    let title: String?
    
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = true
    @State private var progress: Double = 0
    @State private var contentOpacity: Double = 0
    
    init(url: String, title: String? = nil) {
        self.url = url
        self.title = title
    }
    
    var body: some View {
        ZStack {
            // Background
            Color.backgroundColor1
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.textColor1)
                            .frame(width: 36, height: 36)
                            .background(
                                Circle()
                                    .fill(.textColor2.opacity(0.1))
                            )
                    }
                    
                    Spacer()
                    
                    if let title = title {
                        Text(title)
                            .font(.custom("Montserrat-SemiBold", size: 17))
                            .foregroundStyle(.textColor1)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    // Placeholder pour centrer le titre
                    Color.clear
                        .frame(width: 36, height: 36)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                // Progress bar
                if isLoading {
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [.primaryPurple, .primaryPurple.opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * progress, height: 3)
                            .animation(.easeInOut(duration: 0.2), value: progress)
                    }
                    .frame(height: 3)
                }
                
                // WebView
                WebView(
                    url: url,
                    isLoading: $isLoading,
                    progress: $progress
                )
                .opacity(contentOpacity)
            }
            
            // Loading overlay
            if isLoading && progress < 0.3 {
                LoadingOverlay()
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
                contentOpacity = 1.0
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: String
    @Binding var isLoading: Bool
    @Binding var progress: Double
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        
        // Observer pour le progress
        webView.addObserver(
            context.coordinator,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil
        )
        
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        override func observeValue(
            forKeyPath keyPath: String?,
            of object: Any?,
            change: [NSKeyValueChangeKey : Any]?,
            context: UnsafeMutableRawPointer?
        ) {
            if keyPath == "estimatedProgress",
               let webView = object as? WKWebView {
                DispatchQueue.main.async {
                    self.parent.progress = webView.estimatedProgress
                }
            }
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = true
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
                self.parent.progress = 1.0
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
            }
        }
        
        deinit {
            // Note: Le webView doit être retiré de l'observer manuellement si nécessaire
        }
    }
}

struct LoadingOverlay: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            Color.backgroundColor1.opacity(0.9)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ZStack {
                    // Glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.primaryPurple.opacity(0.3),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 40
                            )
                        )
                        .frame(width: 80, height: 80)
                        .blur(radius: 10)
                    
                    // Spinner
                    Circle()
                        .stroke(
                            AngularGradient(
                                colors: [
                                    Color.primaryPurple,
                                    Color.primaryPurple.opacity(0.3),
                                    Color.clear,
                                    Color.clear
                                ],
                                center: .center,
                                startAngle: .degrees(0),
                                endAngle: .degrees(360)
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 50, height: 50)
                        .rotationEffect(.degrees(rotation))
                }
                
                Text("Chargement...")
                    .font(.custom("Montserrat-Medium", size: 15))
                    .foregroundStyle(.textColor2)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

#Preview {
    WebViewScreen(
        url: "https://www.apple.com",
        title: "Apple"
    )
}
