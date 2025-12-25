import Foundation
import SwiftData

@Model
class SavedItem {
    var id: UUID
    var name: String
    var barcode: String
    var score: String?
    var calories: Double
    var dateScanned: Date
    
    // FIX: Store the full JSON so we can re-hydrate the "Glucose Time Machine" offline
    @Attribute(.externalStorage) var productData: Data?
    
    // We initialize it just like a normal class
    init(product: Product) {
        self.id = UUID()
        self.name = product.cleanName
        self.barcode = product._id
        self.score = product.nutriscore_grade
        self.calories = product.nutriments?.energy_kcal_100g ?? 0
        self.dateScanned = Date()
        
        // Encode the full product
        if let encoded = try? JSONEncoder().encode(product) {
            self.productData = encoded
        }
    }
    
    // Helper to revive the full object
    var decodedProduct: Product? {
        guard let data = productData else { return nil }
        return try? JSONDecoder().decode(Product.self, from: data)
    }
}