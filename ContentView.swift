import SwiftUI

struct ContentView: View {
    @State private var next = false
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    next=true
                } label: {
                    Text("Play")
                        .font(.largeTitle)
                }
                
            }.navigationDestination(isPresented: $next) {
                MainView()
        }
        }
    }
}
