import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query(sort: \SavedItem.dateScanned, order: .reverse) var history: [SavedItem]
    @State private var showScanner = false
    
    // Animation State
    @State private var ringProgress: CGFloat = 0.0
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM"
        return formatter.string(from: Date()).uppercased()
    }
    
    var totalCalories: Int {
        let today = history.filter { Calendar.current.isDateInToday($0.dateScanned) }
        return Int(today.reduce(0) { $0 + $1.calories })
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // 1. HEADER
                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(dateString)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.gray)
                                
                                Text("Summary")
                                    .font(.system(size: 34, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                            Spacer()
                            Menu {
                                Button(role: .destructive) {
                                    // LOG OUT LOGIC
                                    UserDefaults.standard.set("", forKey: "userId")
                                    // Force app restart (dirty but works for MVP) or use Binding to root
                                    exit(0) 
                                } label: {
                                    Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                                }
                            } label: {
                                Circle()
                                    .fill(Color(UIColor.systemGray5))
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .font(.caption)
                                            .foregroundStyle(.gray)
                                    )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        // 2. HERO CARD (FIXED WIDTH)
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Bio Score")
                                .font(.headline)
                                .foregroundStyle(.white)
                            
                            HStack(spacing: 20) {
                                // ANIMATED RING
                                ZStack {
                                    Circle()
                                        .stroke(Color.applePink.opacity(0.3), lineWidth: 20)
                                        .frame(width: 100, height: 100)
                                    
                                    Circle()
                                        .trim(from: 0, to: ringProgress) // Animated Value
                                        .stroke(
                                            AngularGradient(
                                                gradient: Gradient(colors: [Color.applePink, Color.purple]),
                                                center: .center,
                                                startAngle: .degrees(0),
                                                endAngle: .degrees(360)
                                            ),
                                            style: StrokeStyle(lineWidth: 20, lineCap: .round)
                                        )
                                        .rotationEffect(.degrees(-90))
                                        .frame(width: 100, height: 100)
                                        .shadow(color: .applePink.opacity(0.5), radius: 10)
                                }
                                
                                // DATA
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Move")
                                        .font(.subheadline)
                                        .foregroundStyle(.white)
                                    
                                    HStack(alignment: .lastTextBaseline, spacing: 2) {
                                        Text("\(totalCalories)")
                                            .fitnessFont(size: 30, weight: .bold)
                                            .foregroundStyle(Color.applePink)
                                        Text("/ 500")
                                            .fitnessFont(size: 20, weight: .bold)
                                            .foregroundStyle(.gray)
                                    }
                                    
                                    Text("KCAL")
                                        .fitnessFont(size: 14, weight: .bold)
                                        .foregroundStyle(Color.applePink)
                                }
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading) // Forces full width
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(16)
                        .padding(.horizontal) // Only outer padding
                        
                        // 3. STAT GRID
                        HStack(spacing: 15) {
                            SmallStatCard(
                                title: "Protein",
                                value: "\(history.count * 12)", // Mock logic
                                unit: "GRAMS",
                                color: Color.appleGreen
                            )
                            SmallStatCard(
                                title: "Scans",
                                value: "\(history.count)",
                                unit: "ITEMS",
                                color: Color.appleCyan
                            )
                        }
                        .padding(.horizontal)
                        
                        // 4. BIG ACTION BUTTON
                        Button(action: { showScanner = true }) {
                            Text("Scan New Item")
                                .font(.headline)
                                .foregroundStyle(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.appleGreen)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)

                        // 5. RECENT LIST
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Recent Intake")
                                    .font(.title3)
                                    .bold()
                                    .foregroundStyle(.white)
                                Spacer()
                                Text("Show More")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.appleGreen)
                            }
                            .padding(.horizontal)
                            
                            ForEach(history.prefix(3)) { item in
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(Color.appleGreen.opacity(0.2))
                                            .frame(width: 40, height: 40)
                                        Image(systemName: "fork.knife")
                                            .foregroundStyle(Color.appleGreen)
                                    }
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                            .lineLimit(1)
                                        Text("Score: \(item.score?.uppercased() ?? "-")")
                                            .font(.caption)
                                            .foregroundStyle(.gray)
                                    }
                                    Spacer()
                                    Text("\(Int(item.calories)) kcal")
                                        .fitnessFont(size: 16)
                                        .foregroundStyle(.white)
                                }
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(12)
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showScanner) {
                ScannerScreen()
            }
            .onAppear {
                // Animate the ring based on calories (max 500 for demo)
                let progress = min(CGFloat(totalCalories) / 500.0, 1.0)
                withAnimation(.easeOut(duration: 1.5)) {
                    ringProgress = progress
                }
            }
        }
    }
}

// MARK: - MISSING COMPONENT ADDED HERE
struct SmallStatCard: View {
    let title: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.gray.opacity(0.5))
            }
            
            Spacer()
            
            Text(value)
                .fitnessFont(size: 28, weight: .regular)
                .foregroundStyle(.white)
            
            Text(unit)
                .fitnessFont(size: 12, weight: .bold)
                .foregroundStyle(color)
            
            // The little graph lines at the bottom (Visual flourish)
            HStack(spacing: 2) {
                ForEach(0..<15) { _ in
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: CGFloat.random(in: 10...30))
                }
            }
            .frame(height: 30, alignment: .bottom)
        }
        .padding()
        .frame(height: 160)
        .frame(maxWidth: .infinity) // Ensure it takes equal width in grid
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
    }
}