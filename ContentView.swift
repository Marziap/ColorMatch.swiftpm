import SwiftUI

struct ContentView: View {
    @State private var next = false
    var body: some View {
        GeometryReader { geometry in
        NavigationStack {

                ZStack {
                   
                    Image("firstBackground")
                   

                        Button {
                            next=true
                        } label: {
                            Image(systemName: "play.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width / 10)
                                
                        }.offset(y:60)
                    
                }.navigationDestination(isPresented: $next) {
                    MainView()
            }
            }
        }
    }
}

#Preview {
    ContentView()
}
