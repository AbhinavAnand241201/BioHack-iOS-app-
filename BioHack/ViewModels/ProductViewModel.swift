import Foundation
import SwiftUI

@MainActor
class ProductViewModel: ObservableObject {
    
    @Published var product: Product?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showProductSheet: Bool = false
    
    // When the scanner finds a code, this function runs
    func loadProduct(barcode: String) {
        self.isLoading = true
        self.errorMessage = nil
        self.product = nil // FIX: Clear stale data immediately
        self.showProductSheet = true // Open the sheet immediately (will show spinner)
        
        Task {
            do {
                // simulated delay to make it feel like "processing" (optional)
                try await Task.sleep(nanoseconds: 500_000_000) 
                
                let fetchedProduct = try await APIService.shared.fetchProduct(barcode: barcode)
                self.product = fetchedProduct
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.errorMessage = "Could not find product details."
                print("Error: \(error)")
            }
        }
    }
}