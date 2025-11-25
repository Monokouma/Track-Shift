import SwiftUI
import Shared
import GoogleSignIn

@main
struct iOSApp: App {
    
    init() {
        KoinModuleKt.doInitKoin()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}
