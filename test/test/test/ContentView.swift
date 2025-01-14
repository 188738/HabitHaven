import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to the Home Screen!")
                NavigationLink("Go to Details") {
                    DetailsView()
                }
            }
            .navigationTitle("Home")
            .padding(10)
        }
    }
}

struct DetailsView: View {
    var body: some View {
        VStack {
            Text("This is the Details Screen!")
        
        }
       
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
