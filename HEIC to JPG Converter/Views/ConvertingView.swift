import SwiftUI
import Foundation

struct ConvertingView: View {
    @ObservedObject var viewModel: ConversionViewModel
    @State private var rotationAngle: Double = 0
    @State private var currentMessageIndex = 0
    @State private var pulseScale: CGFloat = 1.0
    
    private var messages: [String] {
        [
            "Analyzing your photo...",
            "Converting to \(viewModel.selectedFormat.rawValue)...",
            "Almost ready!"
        ]
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Consistent dark gradient background
                LinearGradient(
                    colors: [
                        Color.black,
                        Color(red: 0.02, green: 0.0, blue: 0.1),
                        Color.black
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Elegant ambient effects
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.purple.opacity(0.15),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 50,
                                endRadius: 200
                            )
                        )
                        .frame(width: 300, height: 300)
                        .blur(radius: 40)
                        .scaleEffect(pulseScale)
                        .animation(
                            Animation.easeInOut(duration: 2.5).repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.pink.opacity(0.08),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 30,
                                endRadius: 150
                            )
                        )
                        .frame(width: 200, height: 200)
                        .blur(radius: 30)
                        .offset(x: 100, y: -100)
                        .scaleEffect(1.2 - (pulseScale - 1.0))
                        .animation(
                            Animation.easeInOut(duration: 3.0).repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                }
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Clean loading section
                    VStack(spacing: 50) {
                        // Main loading ring - simplified design
                        ZStack {
                            // Background ring
                            Circle()
                                .stroke(
                                    Color.white.opacity(0.1),
                                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                                )
                                .frame(width: 100, height: 100)
                            
                            // Animated progress ring
                            Circle()
                                .trim(from: 0, to: 0.7)
                                .stroke(
                                    AngularGradient(
                                        colors: [
                                            .purple.opacity(0.9),
                                            .pink.opacity(0.8),
                                            .blue.opacity(0.7),
                                            .purple.opacity(0.9)
                                        ],
                                        center: .center
                                    ),
                                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                                )
                                .frame(width: 100, height: 100)
                                .rotationEffect(.degrees(rotationAngle))
                                .shadow(
                                    color: .purple.opacity(0.3),
                                    radius: 6,
                                    x: 0,
                                    y: 0
                                )
                            
                            // Center icon
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.purple.opacity(0.6),
                                                Color.pink.opacity(0.4)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 35, height: 35)
                                    .scaleEffect(pulseScale * 0.95)
                                    .shadow(color: .purple.opacity(0.4), radius: 4, x: 0, y: 2)
                                
                                Image(systemName: "photo.artframe")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        // Message section - clean and minimal
                        VStack(spacing: 16) {
                            Text("Converting...")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.white, Color.purple.opacity(0.9)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: .purple.opacity(0.2), radius: 4, x: 0, y: 2)
                            
                            Text(currentMessageIndex < messages.count ? messages[currentMessageIndex] : messages.last ?? "")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .animation(.easeInOut(duration: 0.4), value: currentMessageIndex)
                        }
                        .padding(.horizontal, 40)
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Pulse animation
        withAnimation {
            pulseScale = 1.1
        }
        
        // Rotation animation
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        // Message cycling every 1 second for 3 seconds total
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if currentMessageIndex < messages.count - 1 {
                withAnimation(.easeInOut(duration: 0.4)) {
                    currentMessageIndex += 1
                }
            } else {
                timer.invalidate()
            }
        }
    }
} 