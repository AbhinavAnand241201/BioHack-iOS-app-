import Foundation

// Custom Errors help us debug exactly what went wrong
enum APIError: Error {
    case invalidURL
    case invalidResponse
    case productNotFound
    case decodingError
}

class APIService {
    
    // Singleton instance - we only need one network manager in the app
    static let shared = APIService()
    
    private init() {}
    
    /// Fetches product details using the barcode
    func fetchProduct(barcode: String) async throws -> Product {
        
        // 1. Construct the URL
        let urlString = "https://world.openfoodfacts.org/api/v0/product/\(barcode).json"
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        // 2. Make the Network Call
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // 3. Check for valid HTTP Response (200 OK)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        // 4. Decode the JSON
        do {
            let decodedResponse = try JSONDecoder().decode(OpenFoodFactsResponse.self, from: data)
            
            // 5. Verify the product exists
            guard let product = decodedResponse.product else {
                throw APIError.productNotFound
            }
            
            return product
            
        } catch {
            print("Debug: Decoding error: \(error)")
            throw APIError.decodingError
        }
    }
}