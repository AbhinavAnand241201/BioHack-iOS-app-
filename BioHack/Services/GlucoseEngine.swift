import Foundation

struct GlucosePoint: Identifiable {
    let id = UUID()
    let time: String // e.g., "+30m", "+1h"
    let level: Double // 100 is baseline, 160 is high, 70 is crash
}

struct GlucoseEngine {
    
    static func simulateResponse(product: Product) -> [GlucosePoint] {
        let sugar = product.nutriments?.sugars_100g ?? 0
        let fiber = product.nutriments?.fiber_100g ?? 0
        let protein = product.nutriments?.proteins_100g ?? 0
        
        // BASELINE ALGORITHM:
        // 1. Sugar spikes the curve up.
        // 2. Fiber and Protein flatten the curve (slow down absorption).
        
        let netSpike = max(0, sugar - (fiber * 2) - (protein * 0.5))
        
        // Define the curve points (Baseline is 100)
        // Time points: 0m, 30m, 60m, 90m, 120m, 180m
        
        let baseline: Double = 100
        
        // Peak happens at 45 mins.
        // If netSpike is high (e.g., Soda), peak is 160+.
        // If netSpike is low (e.g., Chicken), peak is 110.
        let peakLevel = baseline + (netSpike * 2.5)
        
        // The Crash: If spike was high, we dip BELOW baseline (Reactive Hypoglycemia)
        let crashLevel = (peakLevel > 140) ? (90 - (netSpike * 0.2)) : 100
        
        return [
            GlucosePoint(time: "Now", level: 100),
            GlucosePoint(time: "+30m", level: peakLevel * 0.8), // Rising
            GlucosePoint(time: "+45m", level: peakLevel),       // Peak
            GlucosePoint(time: "+1h", level: peakLevel * 0.7), // Dropping
            GlucosePoint(time: "+2h", level: crashLevel),       // The Crash?
            GlucosePoint(time: "+3h", level: 100)               // Recovery
        ]
    }
    
    // Helper to get text description
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
