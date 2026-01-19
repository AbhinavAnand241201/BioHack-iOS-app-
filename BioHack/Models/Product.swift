import Foundation

struct OpenFoodFactsResponse: Codable {
    let code: String?
    let status: Int
    let product: Product?
}

struct Product: Codable, Identifiable {
    var id: String { _id }
    
    let _id: String
    let product_name: String?
    let brands: String?
    let image_url: String?
    let nutriscore_grade: String?
    let ingredients_text: String?
    let nutriments: Nutriments?
    

    let categories_tags: [String]?
    
    var cleanName: String {
        return product_name ?? "Unknown Product"
    }
    
    var scoreColor: String {
        switch nutriscore_grade?.lowercased() {
        case "a": return "Green"
        case "b": return "LightGreen"
        case "c": return "Yellow"
        case "d": return "Orange"
        case "e": return "Red"
        default: return "Gray"
        }
    }
}

struct Nutriments: Codable {
    let energy_kcal_100g: Double?
    let proteins_100g: Double?
    let carbohydrates_100g: Double?
    let fat_100g: Double?
    let sugars_100g: Double?
    let fiber_100g: Double?
    let salt_100g: Double?
    
    enum CodingKeys: String, CodingKey {
        case energy_kcal_100g = "energy-kcal_100g"
        case proteins_100g = "proteins_100g"
        case carbohydrates_100g = "carbohydrates_100g"
        case fat_100g = "fat_100g"
        case sugars_100g = "sugars_100g"
        case fiber_100g = "fiber_100g"
        case salt_100g = "salt_100g"
    }
}