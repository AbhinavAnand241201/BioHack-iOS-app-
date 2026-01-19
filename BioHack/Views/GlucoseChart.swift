import SwiftUI
import Charts

struct GlucoseChart: View {
    let product: Product
    
    var dataPoints: [GlucosePoint] {
        GlucoseEngine.simulateResponse(product: product)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("PREDICTED GLUCOSE RESPONSE")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.gray)
            
            Chart {
                ForEach(dataPoints) { point in

                    LineMark(
                        x: .value("Time", point.time),
                        y: .value("Level", point.level)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.applePink, Color.appleCyan],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .lineStyle(StrokeStyle(lineWidth: 3))
                    

                    AreaMark(
                        x: .value("Time", point.time),
                        y: .value("Level", point.level)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.applePink.opacity(0.3), Color.clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                

                RuleMark(y: .value("Baseline", 100))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundStyle(.gray.opacity(0.5))
            }
            .frame(height: 150)
            .chartYAxis(.hidden)
            

            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundStyle(Color.appleCyan)
                Text(GlucoseEngine.getInsight(product: product))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
            .padding(.top, 5)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
    }
}
