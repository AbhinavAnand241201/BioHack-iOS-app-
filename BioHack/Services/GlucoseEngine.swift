import Foundation

struct GlucosePoint: Identifiable {
    let id = UUID()
    let time: String
    let level: Double
}

struct GlucoseEngine {
    
    static func simulateResponse(product: Product) -> [GlucosePoint] {
        let sugar = product.nutriments?.sugars_100g ?? 0
        let fiber = product.nutriments?.fiber_100g ?? 0
        let protein = product.nutriments?.proteins_100g ?? 0
        

        
        let netSpike = max(0, sugar - (fiber * 2) - (protein * 0.5))
        

        
        let baseline: Double = 100
        

        let peakLevel = baseline + (netSpike * 2.5)
        

        let crashLevel = (peakLevel > 140) ? (90 - (netSpike * 0.2)) : 100
        
        return [
            GlucosePoint(time: "Now", level: 100),
            GlucosePoint(time: "+30m", level: peakLevel * 0.8),
            GlucosePoint(time: "+45m", level: peakLevel),
            GlucosePoint(time: "+1h", level: peakLevel * 0.7),
            GlucosePoint(time: "+2h", level: crashLevel),
            GlucosePoint(time: "+3h", level: 100)
        ]
    }
    

    static func getInsight(product: Product) -> String {
        let sugar = product.nutriments?.sugars_100g ?? 0
        if sugar > 20 {
            return "⚠️ High Probability of Brain Fog at +2h mark."
        } else if sugar > 10 {
            return "Moderate energy curve. Stable performance."
        } else {
            return "✅ Clean Fuel. No energy crash detected."
        }
    }
}
