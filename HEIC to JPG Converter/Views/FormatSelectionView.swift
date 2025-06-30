import SwiftUI

struct FormatSelectionView: View {
    @ObservedObject var viewModel: ConversionViewModel
    @State private var selectedFormat: ConversionFormat?
    @State private var cardAnimationOffset: CGFloat = 100
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Dark gradient background
                LinearGradient(
                    colors: [
                        Color.black,
                        Color(red: 0.05, green: 0.0, blue: 0.15),
                        Color.black
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Ambient lighting effects
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
                    .offset(x: -100, y: -200)
                    .blur(radius: 40)
                
                VStack(spacing: 40) {
                    // Header with back button
                    VStack(spacing: 20) {
                        HStack {
                            Button(action: {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    viewModel.currentStep = 0
                                }
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color.white.opacity(0.1),
                                                    Color.purple.opacity(0.2)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 44, height: 44)
                                        .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 4)
                                    
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 4) {
                                Text("Choose Format")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Color.white, Color.purple.opacity(0.9)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                
                                Text("Select your preferred output format")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            // Placeholder for symmetry
                            Color.clear
                                .frame(width: 44, height: 44)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    // Format cards
                    VStack(spacing: 24) {
                        ForEach(Array(ConversionFormat.allCases.enumerated()), id: \.element) { index, format in
                            EnhancedFormatCard(
                                format: format,
                                isSelected: selectedFormat == format,
                                animationDelay: Double(index) * 0.1
                            ) {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                    selectedFormat = format
                                }
                            }
                            .offset(x: cardAnimationOffset)
                            .opacity(cardAnimationOffset == 0 ? 1 : 0)
                            .animation(
                                .spring(response: 0.8, dampingFraction: 0.8)
                                .delay(Double(index) * 0.1),
                                value: cardAnimationOffset
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    // Continue button with enhanced design
                    Button(action: {
                        if let format = selectedFormat {
                            viewModel.selectFormat(format)
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                viewModel.currentStep = 2
                            }
                        }
                    }) {
                        ZStack {
                            // Subtle glow effect
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: selectedFormat != nil ? 
                                        [Color.purple.opacity(0.3), Color.pink.opacity(0.2)] : 
                                        [Color.gray.opacity(0.1), Color.gray.opacity(0.1)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .blur(radius: selectedFormat != nil ? 8 : 0)
                                .scaleEffect(selectedFormat != nil ? 1.02 : 1.0)
                            
                            // Main button
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: selectedFormat != nil ? 
                                        [Color.purple.opacity(0.9), Color.pink.opacity(0.8)] : 
                                        [Color.gray.opacity(0.4), Color.gray.opacity(0.3)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .overlay(
                                    HStack(spacing: 12) {
                                        Text("Continue")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(selectedFormat != nil ? .white : .gray)
                                        
                                        Image(systemName: "arrow.right.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(selectedFormat != nil ? .white : .gray)
                                    }
                                )
                        }
                        .frame(height: 60)
                        .shadow(
                            color: selectedFormat != nil ? .purple.opacity(0.4) : .clear, 
                            radius: 15, 
                            x: 0, 
                            y: 8
                        )
                    }
                    .disabled(selectedFormat == nil)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            withAnimation {
                cardAnimationOffset = 0
            }
        }
    }
}

struct EnhancedFormatCard: View {
    let format: ConversionFormat
    let isSelected: Bool
    let animationDelay: Double
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Card background with glassmorphism
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: isSelected ? 
                            [
                                Color.purple.opacity(0.3),
                                Color.pink.opacity(0.2)
                            ] : 
                            [
                                Color.white.opacity(0.05),
                                Color.gray.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: isSelected ? 
                                    [Color.purple.opacity(0.8), Color.pink.opacity(0.6)] : 
                                    [Color.white.opacity(0.2), Color.gray.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
                    .shadow(
                        color: isSelected ? .purple.opacity(0.4) : .black.opacity(0.2),
                        radius: isSelected ? 20 : 8,
                        x: 0,
                        y: isSelected ? 8 : 4
                    )
                
                HStack(spacing: 16) {
                    // Compact icon
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: isSelected ? 
                                    [Color.purple.opacity(0.8), Color.pink.opacity(0.6)] : 
                                    [Color.white.opacity(0.1), Color.gray.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 44, height: 44)
                            .shadow(
                                color: isSelected ? .purple.opacity(0.4) : .clear,
                                radius: isSelected ? 8 : 0,
                                x: 0,
                                y: 3
                            )
                        
                        Image(systemName: format.icon)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(isSelected ? .white : .gray)
                    }
                    
                    // Content - compact
                    VStack(alignment: .leading, spacing: 4) {
                        Text(format.rawValue)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(format.description)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer()
                    
                    // Clean selection indicator
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.white, Color.purple.opacity(0.9)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    } else {
                        Circle()
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1.5)
                            .frame(width: 20, height: 20)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
} 