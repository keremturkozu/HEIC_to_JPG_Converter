import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: ConversionViewModel
    @State private var showingShareSheet = false
    @State private var showingSaveAlert = false
    @State private var savedSuccessfully = false
    @State private var celebrationScale: CGFloat = 0.8
    @State private var sparkleOpacity: Double = 0
    
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
                
                // Subtle success ambient effect
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.purple.opacity(0.12),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 50,
                            endRadius: 180
                        )
                    )
                    .frame(width: 280, height: 280)
                    .blur(radius: 35)
                    .scaleEffect(celebrationScale)
                    .animation(
                        Animation.easeOut(duration: 1.2),
                        value: celebrationScale
                    )
                
                // Elegant sparkles
                ForEach(0..<5, id: \.self) { index in
                    Image(systemName: "sparkle")
                        .font(.system(size: CGFloat.random(in: 6...10)))
                        .foregroundColor(Color.random([.purple, .pink, .blue]).opacity(0.4))
                        .offset(
                            x: CGFloat.random(in: -80...80),
                            y: CGFloat.random(in: -120...120)
                        )
                        .opacity(sparkleOpacity)
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 1.5...2.0))
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.15),
                            value: sparkleOpacity
                        )
                }
                
                ScrollView {
                    VStack(spacing: 28) {
                        // Clean success header
                        VStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.purple.opacity(0.8),
                                                Color.pink.opacity(0.6)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 52, height: 52)
                                    .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
                                
                                Image(systemName: "checkmark")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .scaleEffect(celebrationScale)
                            .animation(
                                Animation.spring(response: 0.6, dampingFraction: 0.7).delay(0.2),
                                value: celebrationScale
                            )
                            
                            VStack(spacing: 6) {
                                Text("Conversion Complete!")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Color.white, Color.purple.opacity(0.9)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: .purple.opacity(0.2), radius: 5, x: 0, y: 2)
                                
                                Text("Successfully converted to \(viewModel.selectedFormat.rawValue)")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(.top, 32)
                        
                        // Image preview with consistent theme
                        if let imageData = viewModel.convertedImageData,
                           let image = UIImage(data: imageData) {
                            VStack(spacing: 10) {
                                Text("Result")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color.white.opacity(0.06),
                                                    Color.purple.opacity(0.1)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .background(
                                            RoundedRectangle(cornerRadius: 18)
                                                .stroke(
                                                    Color.purple.opacity(0.25),
                                                    lineWidth: 1
                                                )
                                        )
                                        .shadow(color: .purple.opacity(0.15), radius: 12, x: 0, y: 6)
                                    
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxHeight: 170)
                                        .clipShape(RoundedRectangle(cornerRadius: 14))
                                        .padding(8)
                                }
                                .frame(height: 190)
                            }
                        }
                        
                        // File info with consistent theme
                        ZStack {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.06),
                                            Color.purple.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(
                                            Color.purple.opacity(0.25),
                                            lineWidth: 1
                                        )
                                )
                                .shadow(color: .purple.opacity(0.12), radius: 10, x: 0, y: 5)
                            
                            HStack(spacing: 20) {
                                // Format
                                VStack(spacing: 5) {
                                    Text("Format")
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundColor(.gray)
                                    
                                    HStack(spacing: 5) {
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
                                                .frame(width: 22, height: 22)
                                                .shadow(color: .purple.opacity(0.3), radius: 3, x: 0, y: 1)
                                            
                                            Image(systemName: viewModel.selectedFormat.icon)
                                                .font(.system(size: 10, weight: .medium))
                                                .foregroundColor(.white)
                                        }
                                        
                                        Text(viewModel.selectedFormat.rawValue)
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }
                                
                                // Quality
                                VStack(spacing: 5) {
                                    Text("Quality")
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundColor(.gray)
                                    
                                    Text("\(Int(viewModel.quality * 100))%")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                
                                // File size
                                VStack(spacing: 5) {
                                    Text("Size")
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundColor(.gray)
                                    
                                    Text(fileSize)
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal, 18)
                            .padding(.vertical, 14)
                        }
                        .padding(.horizontal, 20)
                        
                        // Action buttons with consistent purple theme
                        VStack(spacing: 14) {
                            // Primary share button
                            Button(action: {
                                viewModel.shareImage()
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.purple.opacity(0.9), Color.pink.opacity(0.7)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
                                    
                                    HStack(spacing: 8) {
                                        Image(systemName: "square.and.arrow.up.fill")
                                            .font(.system(size: 16))
                                        
                                        Text("Share")
                                            .font(.system(size: 15, weight: .semibold))
                                    }
                                    .foregroundColor(.white)
                                }
                                .frame(height: 48)
                            }
                            
                            // Secondary action buttons
                            HStack(spacing: 10) {
                                // Save to photos
                                Button(action: {
                                    viewModel.saveToPhotos()
                                    savedSuccessfully = true
                                    showingSaveAlert = true
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.5)],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .shadow(color: .purple.opacity(0.2), radius: 6, x: 0, y: 3)
                                        
                                        VStack(spacing: 5) {
                                            Image(systemName: "photo.fill.on.rectangle.fill")
                                                .font(.system(size: 18))
                                                .foregroundColor(.white)
                                            
                                            Text("Save to Photos")
                                                .font(.system(size: 11, weight: .semibold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 64)
                                }
                                
                                // Download
                                Button(action: {
                                    if let _ = viewModel.downloadImage() {
                                        savedSuccessfully = true
                                        showingSaveAlert = true
                                    }
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color.pink.opacity(0.6), Color.purple.opacity(0.5)],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .shadow(color: .pink.opacity(0.2), radius: 6, x: 0, y: 3)
                                        
                                        VStack(spacing: 5) {
                                            Image(systemName: "arrow.down.circle.fill")
                                                .font(.system(size: 18))
                                                .foregroundColor(.white)
                                            
                                            Text("Download")
                                                .font(.system(size: 11, weight: .semibold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 64)
                                }
                            }
                            
                            // New conversion button
                            Button(action: {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    viewModel.reset()
                                }
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color.white.opacity(0.04),
                                                    Color.purple.opacity(0.08)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .background(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(
                                                    Color.purple.opacity(0.35),
                                                    lineWidth: 1.5
                                                )
                                        )
                                    
                                    HStack(spacing: 8) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 16))
                                        
                                        Text("New Conversion")
                                            .font(.system(size: 15, weight: .semibold))
                                    }
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Color.white, Color.purple.opacity(0.9)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                }
                                .frame(height: 48)
                                .shadow(color: .purple.opacity(0.12), radius: 6, x: 0, y: 3)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 32)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                celebrationScale = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                withAnimation {
                    sparkleOpacity = 1.0
                }
            }
        }
        .alert("Success!", isPresented: $showingSaveAlert) {
            Button("Great!", role: .cancel) { }
        } message: {
            Text("Photo saved successfully!")
        }
    }
    
    private var fileSize: String {
        guard let data = viewModel.convertedImageData else { return "Unknown" }
        
        let bytes = data.count
        let kb = Double(bytes) / 1024.0
        let mb = kb / 1024.0
        
        if mb >= 1.0 {
            return String(format: "%.1f MB", mb)
        } else {
            return String(format: "%.0f KB", kb)
        }
    }
}

// Color extension for random sparkle colors
extension Color {
    static func random(_ colors: [Color]) -> Color {
        return colors.randomElement() ?? .white
    }
} 