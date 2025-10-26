import SwiftUI


struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        Group {
            
            if viewModel.isAuthenticated {
                //HomeNavigationView()
            } else {
                OnBoardingView()
            }
        }.environmentObject(viewModel).onAppear {
            viewModel.checkAuth()
        }
    }
}



#Preview {
    ContentView()
}
