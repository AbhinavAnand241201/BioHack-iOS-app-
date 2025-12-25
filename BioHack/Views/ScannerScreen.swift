import SwiftUI
import SwiftData
import AVFoundation

struct ScannerScreen: View {
    @StateObject private var scannerViewModel = ScannerViewModel()
    @StateObject private var productViewModel = ProductViewModel()
    
    var body: some View {
        ZStack {
            // 1. Camera Feed
            ScannerView(viewModel: scannerViewModel)
                .edgesIgnoringSafeArea(.all)
            
            // 2. The Dark Fitness Overlay
            VStack {
                // Top Control Bar
                HStack {
                    Text("Scan Item")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                    
                    Spacer()
                    
                    // Flashlight Toggle
                    Button(action: { scannerViewModel.toggleTorch() }) {
                        Image(systemName: scannerViewModel.isTorchOn ? "flashlight.on.fill" : "flashlight.off.fill")
                            .font(.title3)
                            .foregroundStyle(scannerViewModel.isTorchOn ? Color.appleGreen : .white)
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
                .padding(.top, 60) // Safe Area
                .padding(.horizontal)
                
                Spacer()
                
                // 3. The Focus Frame (Apple Green)
                ZStack {
                    // Darken outside
                    Color.black.opacity(0.6)
                        .mask(
                            Rectangle()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .frame(width: 280, height: 180)
                                        .blendMode(.destinationOut)
                                )
                        )
                        .edgesIgnoringSafeArea(.all)
                    
                    // Green Border
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.appleGreen, lineWidth: 4)
                        .frame(width: 280, height: 180)
                        .shadow(color: Color.appleGreen.opacity(0.5), radius: 20)
                }
                .allowsHitTesting(false)
                
                Spacer()
                
                Text("Align barcode within frame")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(.bottom, 50)
            }
        }
        // FIXED: New iOS 17 onChange Syntax
        .onChange(of: scannerViewModel.scannedCode) { oldValue, newValue in
            if let code = newValue {
                productViewModel.loadProduct(barcode: code)
            }
        }
        .sheet(isPresented: $productViewModel.showProductSheet, onDismiss: {
            scannerViewModel.scannedCode = nil
        }) {
            ProductDetailView(viewModel: productViewModel)
                .presentationDragIndicator(.visible)
        }
    }
}