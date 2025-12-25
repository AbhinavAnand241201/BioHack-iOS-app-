import SwiftUI

struct ContentView: View {
    
    // Customizing the Tab Bar appearance to be Dark Mode
    init() {
        UITabBar.appearance().barTintColor = .black
        UITabBar.appearance().backgroundColor = .black
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Summary", systemImage: "chart.bar.fill")
                }
            
            // Scanner acts as "Fitness+" tab
            ScannerScreen()
                .tabItem {
                    Label("Scan", systemImage: "barcode.viewfinder")
                }
            
            HistoryView()
                .tabItem {
                    Label("Sharing", systemImage: "person.2.fill") // Using "Sharing" icon to mimic Apple Fitness
                }
        }
        .accentColor(Color.appleGreen) // The neon green active color
        .preferredColorScheme(.dark)
    }
}
