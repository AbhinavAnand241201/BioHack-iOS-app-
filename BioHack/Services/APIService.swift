import Foundation


enum APIError: Error {
    case invalidURL
    case invalidResponse
    case productNotFound
    case decodingError
}

class APIService {
    

    static let shared = APIService()
    
    private init() {}
    
    /// Fetches product details using the barcode
    func fetchProduct(barcode: String) async throws -> Product {
        

        let urlString = "https://world.openfoodfacts.org/api/v0/product/\(barcode).json"
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        

        let (data, response) = try await URLSession.shared.data(from: url)
        

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        

        do {
            let decodedResponse = try JSONDecoder().decode(OpenFoodFactsResponse.self, from: data)
            

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