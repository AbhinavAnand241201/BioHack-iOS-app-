import SwiftUI

struct ContentView: View {
    
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
            

            ScannerScreen()
                .tabItem {
                    Label("Scan", systemImage: "barcode.viewfinder")
                }
            
            HistoryView()
                .tabItem {
                    Label("Sharing", systemImage: "person.2.fill")
                }
        }
        .accentColor(Color.appleGreen)
        .preferredColorScheme(.dark)
    }
}
