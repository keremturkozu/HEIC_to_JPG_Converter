import SwiftUI
import PhotosUI
import Foundation

struct PhotoPickerView: View {
    @ObservedObject var viewModel: ConversionViewModel
    @State private var isAnimating = false
    @State private var glowIntensity: Double = 0.5
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Dark gradient background
                LinearGradient(
                    colors: [
                        Color.black,
                        Color(red: 0.1, green: 0.0, blue: 0.2),
                        Color.black
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Subtle animated background pattern
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.purple.opacity(0.1),
                                Color.clear
                            ],
                            center: .topTrailing,
                            startRadius: 50,
                            endRadius: 300
                        )
                    )
                    .frame(width: 400, height: 400)
                    .offset(x: 150, y: -100)
                    .blur(radius: 30)
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 4.0).repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                
                VStack(spacing: 50) {
                    Spacer()
                    
                    // Hero section
                    VStack(spacing: 24) {
                        // Animated icon with glow
                        ZStack {
                            // Glow effect
                            Image(systemName: "photo.stack.fill")
                                .font(.system(size: 90, weight: .light))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color.purple.opacity(0.8),
                                            Color.pink.opacity(0.6)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .blur(radius: 20)
                                .scaleEffect(glowIntensity)
                            
                            // Main icon
                            Image(systemName: "photo.stack.fill")
                                .font(.system(size: 90, weight: .ultraLight))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color.white,
                                            Color.purple.opacity(0.9),
                                            Color.pink.opacity(0.7)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 5)
                        }
                        .scaleEffect(isAnimating ? 1.05 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 2.5).repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                        
                        VStack(spacing: 12) {
                            Text("HEIC Converter")
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.white, Color.purple.opacity(0.9)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: .purple.opacity(0.3), radius: 5, x: 0, y: 2)
                            
                            Text("Transform your HEIC photos into\nuniversal formats with style")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        }
                    }
                    
                    Spacer()
                    
                    // Photo picker section
                    VStack(spacing: 32) {
                        if let image = viewModel.originalImage {
                            // Selected image with glassmorphism
                            ZStack {
                                // Glass background
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.1),
                                                Color.purple.opacity(0.1)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .background(
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(
                                                LinearGradient(
                                                    colors: [
                                                        Color.purple.opacity(0.6),
                                                        Color.pink.opacity(0.3)
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1
                                            )
                                    )
                                    .shadow(color: .purple.opacity(0.3), radius: 20, x: 0, y: 10)
                                
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 220)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .padding(12)
                            }
                            .frame(height: 250)
                            
                        } else {
                            // Enhanced photo picker button
                            PhotosPicker(
                                selection: $viewModel.selectedPhoto,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                ZStack {
                                    // Glassmorphism background
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color.white.opacity(0.05),
                                                    Color.purple.opacity(0.1)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .background(
                                            RoundedRectangle(cornerRadius: 24)
                                                .stroke(
                                                    LinearGradient(
                                                        colors: [
                                                            Color.purple.opacity(0.4),
                                                            Color.pink.opacity(0.2)
                                                        ],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    style: StrokeStyle(lineWidth: 1.5, dash: [8, 4])
                                                )
                                        )
                                        .shadow(color: .purple.opacity(0.2), radius: 15, x: 0, y: 8)
                                    
                                    VStack(spacing: 20) {
                                        // Animated plus icon
                                        ZStack {
                                            Circle()
                                                .fill(
                                                    LinearGradient(
                                                        colors: [
                                                            Color.purple.opacity(0.3),
                                                            Color.pink.opacity(0.2)
                                                        ],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )
                                                .frame(width: 80, height: 80)
                                                .blur(radius: 10)
                                            
                                            Image(systemName: "plus.circle.fill")
                                                .font(.system(size: 50, weight: .ultraLight))
                                                .foregroundStyle(
                                                    LinearGradient(
                                                        colors: [Color.white, Color.purple.opacity(0.8)],
                                                        startPoint: .top,
                                                        endPoint: .bottom
                                                    )
                                                )
                                        }
                                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                                        .animation(
                                            Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                                            value: isAnimating
                                        )
                                        
                                        VStack(spacing: 8) {
                                            Text("Select HEIC Photo")
                                                .font(.system(size: 20, weight: .semibold))
                                                .foregroundColor(.white)
                                            
                                            Text("Tap to choose a photo from your gallery\nand start the transformation")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.gray)
                                                .multilineTextAlignment(.center)
                                                .lineSpacing(2)
                                        }
                                    }
                                }
                                .frame(height: 250)
                            }
                        }
                        
                        // Continue button - clean design
                        if viewModel.originalImage != nil {
                            Button(action: {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    viewModel.currentStep = 1
                                }
                            }) {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.purple.opacity(0.9),
                                                Color.pink.opacity(0.8)
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .overlay(
                                        HStack(spacing: 12) {
                                            Text("Continue")
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundColor(.white)
                                            
                                            Image(systemName: "arrow.right.circle.fill")
                                                .font(.system(size: 20))
                                                .foregroundColor(.white)
                                        }
                                    )
                                    .frame(height: 60)
                                    .shadow(color: .purple.opacity(0.2), radius: 8, x: 0, y: 4)
                            }
                            .transition(.opacity.combined(with: .scale))
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            withAnimation {
                isAnimating = true
            }
            
            // Glow animation
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 1.5)) {
                    glowIntensity = Double.random(in: 0.8...1.2)
                }
            }
        }
        .onChange(of: viewModel.selectedPhoto) { _, _ in
            Task {
                await viewModel.loadSelectedPhoto()
            }
        }
    }
} 