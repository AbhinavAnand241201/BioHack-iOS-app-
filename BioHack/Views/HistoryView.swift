import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \SavedItem.dateScanned, order: .reverse) var items: [SavedItem]
    @State private var selectedItem: SavedItem? // Control the history sheet
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Today").font(.headline)) {
                    ForEach(items) { item in
                        // Navigation Link wrapper for interactivity
                        Button(action: {
                            selectedItem = item
                        }) {
                            HStack(spacing: 15) {
                                // Ring Icon Badge
                                ZStack {
                                    Circle()
                                        .stroke(Color.applePink, lineWidth: 3)
                                        .frame(width: 30, height: 30)
                                    Text(item.score?.uppercased() ?? "-")
                                        .fitnessFont(size: 12, weight: .bold)
                                        .foregroundStyle(.white)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name)
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.white)
                                    
                                    Text("\(Int(item.calories)) KCAL • \(item.dateScanned.formatted(date: .omitted, time: .shortened))")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                            .padding(.vertical, 4)
                            .contentShape(Rectangle()) // Make full row tappable
                        }
                        .buttonStyle(.plain) // Remove default button flash
                        .listRowBackground(Color(UIColor.secondarySystemBackground))
                    }
                }
            }
            .listStyle(.insetGrouped) // The specific Apple Settings look
            .navigationTitle("History")
            .background(Color.black) // Force black background behind the list
            .scrollContentBackground(.hidden) // Hides default grey background
            .sheet(item: $selectedItem) { item in
                // We pass a dummy VM because the View expects it, but we provide static product
                ProductDetailView(viewModel: ProductViewModel(), staticProduct: item.decodedProduct)
                    .presentationDragIndicator(.visible)
            }
        }
    }
}