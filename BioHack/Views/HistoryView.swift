import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \SavedItem.dateScanned, order: .reverse) var items: [SavedItem]
    @State private var selectedItem: SavedItem?
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Today").font(.headline)) {
                    ForEach(items) { item in

                        Button(action: {
                            selectedItem = item
                        }) {
                            HStack(spacing: 15) {

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
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(Color(UIColor.secondarySystemBackground))
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("History")
            .background(Color.black)
            .scrollContentBackground(.hidden)
            .sheet(item: $selectedItem) { item in

                ProductDetailView(viewModel: ProductViewModel(), staticProduct: item.decodedProduct)
                    .presentationDragIndicator(.visible)
            }
        }
    }
}