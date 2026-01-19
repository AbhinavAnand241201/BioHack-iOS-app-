import Foundation
import UIKit

struct BioBrain {
    

    struct HealthJourney {
        let warningTitle: String
        let educationQuery: String // For YouTube
        let swapQuery: String      // For Amazon
        let workoutType: ActivityType
    }
    

    static func generateJourney(for product: Product) -> HealthJourney {
        let name = product.cleanName
        let tags = product.categories_tags ?? []
        

        var journey = HealthJourney(
            warningTitle: "Low Nutrition Detected",
            educationQuery: "Is \(name) healthy?",
            swapQuery: "Healthy organic snacks",
            workoutType: .walking
        )
        

        if tags.contains(where: { $0.contains("beverages") || $0.contains("sodas") }) {
            journey = HealthJourney(
                warningTitle: "Sugar Spike Alert",
                educationQuery: "What happens to body after drinking soda",
                swapQuery: "Sparkling water zero sugar variety pack",
                workoutType: .hiit // Needs intense burn
            )
        }

        else if tags.contains(where: { $0.contains("chips") || $0.contains("crisps") }) {
            journey = HealthJourney(
                warningTitle: "High Sodium Alert",
                educationQuery: "Health effects of processed chips",
                swapQuery: "Baked vegetable chips sea salt",
                workoutType: .running
            )
        }

        else if tags.contains(where: { $0.contains("chocolates") || $0.contains("sugary-snacks") }) {
            journey = HealthJourney(
                warningTitle: "Insulin Spike Alert",
                educationQuery: "Sugar addiction withdrawal tips",
                swapQuery: "Dark chocolate 85% organic",
                workoutType: .walking
            )
        }
        
        return journey
    }
    

    static func getYouTubeLink(query: String) -> URL? {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "https://www.youtube.com/results?search_query=\(encoded)")
    }
    
    static func getAmazonLink(query: String) -> URL? {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "https://www.amazon.com/s?k=\(encoded)")
    }
    

    static func getYouTubeWorkoutLink(minutes: Int, type: ActivityType) -> URL? {
        let typeString: String
        switch type {
        case .walking: typeString = "power walk workout"
        case .running: typeString = "treadmill run"
        case .hiit:    typeString = "fat burn HIIT workout"
        }
        let query = "\(minutes) minute \(typeString)"
        return getYouTubeLink(query: query)
    }
    

    static func calculateBurnTime(calories: Double, activity: ActivityType) -> Int {
        let burnRate: Double
        switch activity {
        case .walking: burnRate = 4.0
        case .running: burnRate = 11.5
        case .hiit:    burnRate = 14.0
        }
        return Int(ceil(calories / burnRate))
    }
    
    enum ActivityType {
        case walking, running, hiit
    }
}