import SwiftUI

struct LoginView: View {
    @Binding var isAuthenticated: Bool
    @State private var isLoggingIn: Bool = false
    

    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ZStack {
                Circle()
                    .fill(Color.appleGreen.opacity(0.15))
                    .frame(width: 300, height: 300)
                    .blur(radius: 80)
                    .offset(x: -100, y: -200)
                
                Circle()
                    .fill(Color.applePink.opacity(0.1))
                    .frame(width: 250, height: 250)
                    .blur(radius: 80)
                    .offset(x: 120, y: 150)
            }
            
            VStack(spacing: 35) {
                Spacer()
                

                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(Color.appleGreen.opacity(0.1))
                            .frame(width: 140, height: 140)
                            .blur(radius: 20)
                        
                        Image(systemName: "bolt.heart.fill")
                            .font(.system(size: 70))
                            .foregroundStyle(Color.appleGreen) // Brand Color
                            .shadow(color: Color.appleGreen.opacity(0.6), radius: 30)
                    }
                    
                    Text("BioHack")
                        .font(.system(size: 48, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .tracking(1)
                    
                    Text("Optimize Your Biology")
                        .font(.headline)
                        .foregroundStyle(.gray)
                        .padding(.top, -10)
                }
                
                Spacer()
                

                Button(action: performGoogleLogin) {
                    HStack(spacing: 15) {
                        if isLoggingIn {
                            ProgressView()
                                .tint(.black)
                        } else {
                            Text("G")
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    AngularGradient(
                                        colors: [
                                            Color(red: 234/255, green: 67/255, blue: 53/255),  // Red
                                            Color(red: 251/255, green: 188/255, blue: 5/255),  // Yellow
                                            Color(red: 52/255, green: 168/255, blue: 83/255),  // Green
                                            Color(red: 66/255, green: 133/255, blue: 244/255), // Blue
                                            Color(red: 234/255, green: 67/255, blue: 53/255)   // Back to Red
                                        ],
                                        center: .center,
                                        startAngle: .degrees(-20),
                                        endAngle: .degrees(340)
                                    )
                                )
                                .padding(8)
                                .background(.white)
                                .clipShape(Circle())
                            
                            Text("Continue with Google")
                                .font(.headline)
                                .foregroundStyle(.black)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.appleGreen.opacity(0.15), radius: 15, x: 0, y: 5)
                }
                .disabled(isLoggingIn)
                .padding(.horizontal, 30)
                
                // Footer
                Text("By continuing, you agree to our Terms & Privacy Policy.")
                    .font(.caption2)
                    .foregroundStyle(.gray.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 50)
                    .padding(.bottom, 40)
            }
        }
    }
    

    func performGoogleLogin() {

        withAnimation { isLoggingIn = true }
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            

            UserDefaults.standard.set("mock_google_id_12345", forKey: "userId")
            UserDefaults.standard.set("founder@google.com", forKey: "userEmail")
            UserDefaults.standard.set("Founder", forKey: "userName")
            

            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            

            withAnimation(.spring()) {
                isAuthenticated = true
                isLoggingIn = false
            }
        }
    }
}
