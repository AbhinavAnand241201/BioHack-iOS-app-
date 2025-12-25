import SwiftUI

struct MacroRingView: View {
    var value: Double // The amount (e.g., 12g)
    var total: Double = 100 // Out of 100g usually
    var color: Color
    var label: String
    
    var body: some View {
        VStack {
            ZStack {
                // Background Circle (Gray)
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 10)
                
                // Foreground Circle (The Data)
                Circle()
                    .trim(from: 0, to: CGFloat(min(value / total, 1.0)))
                    .stroke(color, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90)) // Start from top
                    .animation(.easeOut(duration: 1.0), value: value)
                
                // The Number inside
                Text("\(Int(value))g")
                    .font(.system(.caption, design: .rounded))
                    .bold()
            }
            .frame(width: 60, height: 60)
            
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}