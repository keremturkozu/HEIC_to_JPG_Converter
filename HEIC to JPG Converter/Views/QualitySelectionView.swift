import SwiftUI

struct QualitySelectionView: View {
    @ObservedObject var viewModel: ConversionViewModel
    @State private var qualityPercentage: Double = 70
    @State private var pulseAnimation: Bool = false
    
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
                
                // Subtle ambient effect
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.purple.opacity(0.08),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 80,
                            endRadius: 200
                        )
                    )
                    .frame(width: 300, height: 300)
                    .blur(radius: 40)
                    .scaleEffect(pulseAnimation ? 1.04 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 4.0).repeatForever(autoreverses: true),
                        value: pulseAnimation
                    )
                
                VStack(spacing: 0) {
                    // Minimal header
                    HStack {
                        Button(action: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                viewModel.currentStep = 1
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                        }
                        
                        Spacer()
                        
                        Text("Quality")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Color.clear
                            .frame(width: 44, height: 44)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    // Main content - centered
                    VStack(spacing: 50) {
                        // Format info - simple text
                        VStack(spacing: 8) {
                            Text("Converting to")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            
                            HStack(spacing: 6) {
                                Image(systemName: viewModel.selectedFormat.icon)
                                    .font(.system(size: 16))
                                    .foregroundColor(.purple.opacity(0.8))
                                
                                Text(viewModel.selectedFormat.rawValue)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        // Quality display - large and prominent
                        VStack(spacing: 20) {
                            ZStack {
                                // Background circle
                                Circle()
                                    .stroke(Color.white.opacity(0.08), lineWidth: 2)
                                    .frame(width: 160, height: 160)
                                
                                // Progress circle
                                Circle()
                                    .trim(from: 0, to: CGFloat(qualityPercentage / 100))
                                    .stroke(
                                        LinearGradient(
                                            colors: qualityGradient,
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                                    )
                                    .frame(width: 160, height: 160)
                                    .rotationEffect(.degrees(-90))
                                    .shadow(
                                        color: qualityGradient.first?.opacity(0.3) ?? .purple.opacity(0.3),
                                        radius: 8,
                                        x: 0,
                                        y: 0
                                    )
                                
                                // Center content
                                VStack(spacing: 4) {
                                    Text("\(Int(qualityPercentage))%")
                                        .font(.system(size: 48, weight: .bold, design: .rounded))
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: qualityGradient,
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                    
                                    Text(qualityLabel)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Text(qualityDescription)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        
                        // Clean slider
                        VStack(spacing: 20) {
                            // Slider with custom styling
                            VStack(spacing: 12) {
                                GeometryReader { sliderGeometry in
                                    ZStack {
                                        // Track
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(Color.white.opacity(0.1))
                                            .frame(height: 6)
                                        
                                        // Progress
                                        HStack {
                                            RoundedRectangle(cornerRadius: 3)
                                                .fill(
                                                    LinearGradient(
                                                        colors: qualityGradient,
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                                .frame(
                                                    width: sliderGeometry.size.width * CGFloat((qualityPercentage - 10) / 90),
                                                    height: 6
                                                )
                                                .shadow(
                                                    color: qualityGradient.first?.opacity(0.4) ?? .purple.opacity(0.4),
                                                    radius: 3,
                                                    x: 0,
                                                    y: 1
                                                )
                                            
                                            Spacer(minLength: 0)
                                        }
                                        
                                        Slider(value: $qualityPercentage, in: 10...100, step: 5)
                                            .accentColor(.clear)
                                            .onChange(of: qualityPercentage) { _, newValue in
                                                viewModel.setQuality(newValue / 100.0)
                                            }
                                    }
                                }
                                .frame(height: 6)
                                
                                // Range labels
                                HStack {
                                    Text("10%")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.gray)
                                    
                                    Spacer()
                                    
                                    Text("100%")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal, 30)
                        }
                    }
                    
                    Spacer()
                    Spacer()
                    
                    // Start conversion button - minimal design
                    Button(action: {
                        viewModel.proceedToConversion()
                    }) {
                        HStack(spacing: 8) {
                            Text("Start Conversion")
                                .font(.system(size: 17, weight: .semibold))
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [Color.purple.opacity(0.9), Color.pink.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .purple.opacity(0.2), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            qualityPercentage = viewModel.quality * 100
            pulseAnimation = true
        }
    }
    
    private var qualityGradient: [Color] {
        switch qualityPercentage {
        case 0...30:
            return [.red.opacity(0.9), .orange.opacity(0.8)]
        case 31...60:
            return [.orange.opacity(0.9), .yellow.opacity(0.8)]
        case 61...80:
            return [.yellow.opacity(0.9), .green.opacity(0.8)]
        default:
            return [.green.opacity(0.9), .blue.opacity(0.8)]
        }
    }
    
    private var qualityLabel: String {
        switch qualityPercentage {
        case 0...30:
            return "Basic"
        case 31...60:
            return "Standard"
        case 61...80:
            return "High"
        default:
            return "Premium"
        }
    }
    
    private var qualityDescription: String {
        switch qualityPercentage {
        case 0...30:
            return "Smaller file size • Good for sharing"
        case 31...60:
            return "Balanced quality and size"
        case 61...80:
            return "High quality • Clear details"
        default:
            return "Maximum quality • Best for important photos"
        }
    }
} 