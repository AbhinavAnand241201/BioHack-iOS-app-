import SwiftUI
import SwiftData

@main
struct BioHackApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // This one line sets up the entire database!
        .modelContainer(for: SavedItem.self)
    }
}