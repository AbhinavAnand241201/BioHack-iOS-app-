import SwiftUI
import SwiftData

struct ProductDetailView: View {
    @ObservedObject var viewModel: ProductViewModel
    
    // Support for history items (static display)
    var staticProduct: Product?
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            // Prefer static product (History) -> then ViewModel product (Live Scan)
            if let product = staticProduct ?? viewModel.product {
                SuccessView(product: product)
            } else if viewModel.isLoading {
                ProgressView().tint(Color.appleGreen)
            } else if let error = viewModel.errorMessage {
                 // FIX 4: Basic Error Handling UI
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(.red)
                    Text(error)
                        .foregroundStyle(.white)
                        .padding()
                }
            }
        }
    }
}

// THE NEW SUCCESS VIEW
struct SuccessView: View {
    let product: Product
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    // Generate the journey once
    var journey: BioBrain.HealthJourney {
        BioBrain.generateJourney(for: product)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // 1. HERO SECTION (Same as before)
                HStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 15)
                            .frame(width: 100, height: 100)
                        Circle()
                            .trim(from: 0, to: 1.0)
                            .stroke(Color(product.scoreColor == "Red" ? .red : .appleGreen), style: StrokeStyle(lineWidth: 15, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .frame(width: 100, height: 100)
                        Text(product.nutriscore_grade?.uppercased() ?? "?")
                            .fitnessFont(size: 40, weight: .bold)
                            .foregroundStyle(.white)
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Nutrition Grade")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        Text(product.cleanName)
                            .font(.title3).bold().foregroundStyle(.white).lineLimit(2)
                        Text("\(Int(product.nutriments?.energy_kcal_100g ?? 0)) KCAL")
                            .fitnessFont(size: 16, weight: .bold).foregroundStyle(Color.applePink)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
                Divider().background(Color.gray.opacity(0.3))
                
                // --- NEW FEATURE: GLUCOSE PREDICTION ---
                GlucoseChart(product: product)
                    .padding(.horizontal)
                
                // 2. THE NEW "DETOX PROTOCOL" (If bad score)
                if let score = product.nutriscore_grade?.lowercased(), ["d", "e"].contains(score) {
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("⚠️ \(journey.warningTitle)")
                            .font(.headline)
                            .foregroundStyle(.red)
                            .padding(.horizontal)
                        
                        // STEP 1: EDUCATE
                        ProtocolCard(
                            icon: "play.circle.fill",
                            color: .red,
                            title: "Learn The Truth",
                            subtitle: "Watch: \(journey.educationQuery)",
                            action: {
                                if let url = BioBrain.getYouTubeLink(query: journey.educationQuery) {
                                    UIApplication.shared.open(url)
                                }
                            }
                        )
                        
                        // STEP 2: SWAP
                        ProtocolCard(
                            icon: "cart.fill",
                            color: .appleGreen,
                            title: "Smart Swap",
                            subtitle: "Order: \(journey.swapQuery)",
                            action: {
                                if let url = BioBrain.getAmazonLink(query: journey.swapQuery) {
                                    UIApplication.shared.open(url)
                                }
                            }
                        )
                        
                        // STEP 3: BURN
                        ProtocolCard(
                            icon: "flame.fill",
                            color: .appleCyan,
                            title: "Damage Control",
                            subtitle: "Start 5 min \(journey.workoutType) session",
                            action: {
                                let time = BioBrain.calculateBurnTime(calories: product.nutriments?.energy_kcal_100g ?? 0, activity: journey.workoutType)
                                if let url = BioBrain.getYouTubeWorkoutLink(minutes: time, type: journey.workoutType) {
                                    UIApplication.shared.open(url)
                                }
                            }
                        )
                    }
                } else {
                    // Safe Food - Show normal Macros
                    VStack(alignment: .leading) {
                        Text("Macros").font(.headline).foregroundStyle(.white)
                        // FIXED: MacroBar is now defined below
                        VStack(spacing: 12) {
                            MacroBar(label: "Protein", value: product.nutriments?.proteins_100g ?? 0, color: Color.applePink)
                            MacroBar(label: "Carbs", value: product.nutriments?.carbohydrates_100g ?? 0, color: Color.appleGreen)
                            MacroBar(label: "Fat", value: product.nutriments?.fat_100g ?? 0, color: Color.appleCyan)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                
                // SAVE BUTTON
                Button(action: saveToHistory) {
                    Text("Add to Summary")
                        .bold()
                        .foregroundStyle(Color.appleGreen)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
    }
    
    func saveToHistory() {
        let newItem = SavedItem(product: product)
        context.insert(newItem)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        dismiss()
    }
}

// Helper Card for the Protocol
struct ProtocolCard: View {
    let icon: String
    let color: Color
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                ZStack {
                    Circle().fill(color.opacity(0.15)).frame(width: 44, height: 44)
                    Image(systemName: icon).foregroundStyle(color).font(.title3)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.headline).foregroundStyle(.white)
                    Text(subtitle).font(.caption).foregroundStyle(.gray).lineLimit(1)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(.gray)
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}

// FIXED: Added MacroBar struct
struct MacroBar: View {
    let label: String
    let value: Double
    let color: Color
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.gray)
                .frame(width: 60, alignment: .leading)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.gray.opacity(0.2))
                    Capsule().fill(color).frame(width: min(CGFloat(value) * 3, geometry.size.width))
                }
            }
            .frame(height: 8)
            
            Text("\(Int(value))g")
                .fitnessFont(size: 14, weight: .bold)
                .foregroundStyle(.white)
                .frame(width: 40, alignment: .trailing)
        }
    }
}