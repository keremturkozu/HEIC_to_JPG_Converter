import SwiftUI

struct LaunchScreenView: View {
    @State private var logoScale: Double = 0.7
    @State private var logoRotation: Double = 0
    @State private var backgroundOpacity: Double = 0
    @State private var textOpacity: Double = 0
    @State private var particleAnimation: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color.black,
                        Color(red: 0.02, green: 0.0, blue: 0.1),
                        Color.black
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .opacity(backgroundOpacity)
                .ignoresSafeArea()
                
                // Floating particles
                ZStack {
                    ForEach(0..<15, id: \.self) { _ in
                        Circle()
                            .fill(Color.purple.opacity(0.2))
                            .frame(width: 6, height: 6)
                            .position(
                                x: CGFloat.random(in: 0...geometry.size.width),
                                y: CGFloat.random(in: 0...geometry.size.height)
                            )
                            .blur(radius: 2)
                            .scaleEffect(particleAnimation ? 1.5 : 0.5)
                    }
                }
                .animation(
                    Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                    value: particleAnimation
                )
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // App logo/icon
                    ZStack {
                        // Glow effect
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color.purple.opacity(0.4),
                                        Color.pink.opacity(0.3),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 20,
                                    endRadius: 80
                                )
                            )
                            .frame(width: 160, height: 160)
                            .blur(radius: 20)
                            .scaleEffect(logoScale)
                        
                        // Main logo circle
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.purple, Color.pink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                            .shadow(color: .purple.opacity(0.5), radius: 20, x: 0, y: 10)
                            .scaleEffect(logoScale)
                            .rotationEffect(.degrees(logoRotation))
                        
                        // App icon
                        VStack(spacing: 8) {
                            Image(systemName: "photo.badge.arrow.down")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("HEIC")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .scaleEffect(logoScale)
                    }
                    
                    // App name and tagline
                    VStack(spacing: 12) {
                        Text("HEIC Converter")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.white, Color.purple.opacity(0.9)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .opacity(textOpacity)
                        
                        Text("Convert your photos effortlessly")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                            .opacity(textOpacity)
                    }
                    
                    Spacer()
                    
                    // Loading indicator
                    VStack(spacing: 16) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                            .scaleEffect(1.2)
                            .opacity(textOpacity)
                        
                        Text("Loading...")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                            .opacity(textOpacity)
                    }
                    .padding(.bottom, 60)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                backgroundOpacity = 1.0
            }
            
            withAnimation(.spring(response: 1.2, dampingFraction: 0.6).delay(0.3)) {
                logoScale = 1.0
            }
            
            withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false).delay(0.5)) {
                logoRotation = 360
            }
            
            withAnimation(.easeInOut(duration: 0.8).delay(0.8)) {
                textOpacity = 1.0
            }
            
            particleAnimation = true
        }
    }
}

#Preview {
    LaunchScreenView()
} 