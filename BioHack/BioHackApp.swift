import SwiftUI
import SwiftData

@main
struct BioHackApp: App {

    @AppStorage("userId") var userId: String = ""
    @State private var isAuthenticated: Bool = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isAuthenticated || !userId.isEmpty {

                    ContentView()
                        .transition(.opacity)
                } else {

                    LoginView(isAuthenticated: $isAuthenticated)
                }
            }
        }
        .modelContainer(for: SavedItem.self)
    }
}