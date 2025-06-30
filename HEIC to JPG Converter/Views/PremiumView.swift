import SwiftUI
import StoreKit

struct PremiumView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var storeManager = StoreKitManager.shared
    @State private var selectedProduct: Product?
    @State private var pulseAnimation: Bool = false
    @State private var starsAnimation: Bool = false
    @State private var isLoading: Bool = false
    
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
                
                // Floating particles background
                ZStack {
                    ForEach(0..<20, id: \.self) { _ in
                        Circle()
                            .fill(Color.purple.opacity(0.1))
                            .frame(width: 4, height: 4)
                            .position(
                                x: CGFloat.random(in: 0...geometry.size.width),
                                y: CGFloat.random(in: 0...geometry.size.height)
                            )
                            .blur(radius: 1)
                            .scaleEffect(pulseAnimation ? 1.2 : 0.8)
                    }
                }
                .animation(
                    Animation.easeInOut(duration: 3.0).repeatForever(autoreverses: true),
                    value: pulseAnimation
                )
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Header section
                        headerSection
                        
                        // Rating and social proof
                        socialProofSection
                        
                        // User reviews
                        reviewsSection
                        
                        // App features
                        featuresSection
                        
                        // Premium plans
                        plansSection
                        
                        // Action button
                        subscribeButton
                        
                        // Legal links
                        legalSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            pulseAnimation = true
            starsAnimation = true
            
            // Set default selected product (monthly if available)
            if selectedProduct == nil {
                selectedProduct = storeManager.subscriptions.first { $0.id.contains("monthly") } ?? storeManager.subscriptions.first
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                }
                
                Spacer()
            }
            
            VStack(spacing: 16) {
                // Premium icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.purple.opacity(0.3), Color.pink.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .blur(radius: 20)
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.purple, Color.pink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                        .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Image(systemName: "crown.fill")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(starsAnimation ? 1.1 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                            value: starsAnimation
                        )
                }
                
                VStack(spacing: 8) {
                    Text("HEIC Converter")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.white, Color.purple.opacity(0.9)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("Premium")
                        .font(.system(size: 32, weight: .black))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.purple, Color.pink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
            }
        }
    }
    
    private var socialProofSection: some View {
        VStack(spacing: 16) {
            // Rating display
            HStack(spacing: 12) {
                HStack(spacing: 2) {
                    ForEach(0..<5, id: \.self) { index in
                        Image(systemName: "star.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.yellow)
                            .scaleEffect(starsAnimation ? 1.1 : 1.0)
                            .animation(
                                Animation.easeInOut(duration: 1.5)
                                    .delay(Double(index) * 0.1)
                                    .repeatForever(autoreverses: true),
                                value: starsAnimation
                            )
                    }
                }
                
                Text("4.9")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Text("(12,847 reviews)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            
            // User count
            Text("Over 50,000+ Happy Users")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.purple.opacity(0.9))
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 30)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.05),
                            Color.purple.opacity(0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.purple.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private var reviewsSection: some View {
        VStack(spacing: 16) {
            Text("What Our Users Say")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(reviews, id: \.id) { review in
                        ReviewCard(review: review)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private var featuresSection: some View {
        VStack(spacing: 20) {
            Text("Premium Features")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                ForEach(premiumFeatures, id: \.id) { feature in
                    FeatureRow(feature: feature)
                }
            }
        }
    }
    
    private var plansSection: some View {
        VStack(spacing: 20) {
            Text("Choose Your Plan")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                ForEach(storeManager.subscriptions, id: \.id) { product in
                    ProductCard(
                        product: product,
                        isSelected: selectedProduct?.id == product.id,
                        onSelect: { selectedProduct = product }
                    )
                }
            }
        }
    }
    
    private var subscribeButton: some View {
        Button(action: {
            guard let product = selectedProduct else { return }
            
                            Task {
                    isLoading = true
                    do {
                        if try await storeManager.purchase(product) != nil {
                            // Purchase successful
                            dismiss()
                        }
                    } catch {
                        print("Purchase failed: \(error)")
                    }
                    isLoading = false
                }
        }) {
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Text(selectedProduct?.id.contains("lifetime") == true ? "Purchase Lifetime" : "Start Free Trial")
                            .font(.system(size: 18, weight: .bold))
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .bold))
                    }
                }
                .foregroundColor(.white)
                
                if let product = selectedProduct, !isLoading {
                    Text(product.id.contains("lifetime") == true ? "One-time payment" : "Then \(product.displayPrice)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                LinearGradient(
                    colors: [
                        selectedProduct != nil ? Color.purple : Color.gray,
                        selectedProduct != nil ? Color.pink : Color.gray
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
            .scaleEffect(pulseAnimation ? 1.02 : 1.0)
            .animation(
                Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                value: pulseAnimation
            )
        }
        .disabled(selectedProduct == nil || isLoading)
    }
    
    private var legalSection: some View {
        VStack(spacing: 16) {
            Button("Restore Purchases") {
                Task {
                    await storeManager.restorePurchases()
                    if storeManager.isSubscribed {
                        dismiss()
                    }
                }
            }
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.purple)
            
            HStack(spacing: 20) {
                Button("Privacy Policy") {
                    // Handle privacy policy
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
                
                Button("Terms of Use") {
                    // Handle terms
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
            }
        }
        .padding(.top, 20)
    }
}

// MARK: - Supporting Views

struct ReviewCard: View {
    let review: UserReview
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.purple, Color.pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 36, height: 36)
                    .overlay(
                        Text(review.initials)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(review.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 2) {
                        ForEach(0..<5, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.yellow)
                        }
                    }
                }
                
                Spacer()
            }
            
            Text(review.comment)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
                .lineLimit(3)
        }
        .padding(16)
        .frame(width: 240)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.03),
                            Color.purple.opacity(0.06)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.purple.opacity(0.15), lineWidth: 1)
                )
        )
    }
}

struct FeatureRow: View {
    let feature: PremiumFeature
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.purple.opacity(0.2), Color.pink.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                
                Image(systemName: feature.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.purple)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(feature.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(feature.description)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "checkmark")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.green)
        }
        .padding(.vertical, 8)
    }
}

struct ProductCard: View {
    let product: Product
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(productTitle)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        if isPopularProduct {
                            Text("POPULAR")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    LinearGradient(
                                        colors: [Color.orange, Color.red],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .clipShape(Capsule())
                        }
                    }
                    
                    Text(productDescription)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(product.displayPrice)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    if !product.id.contains("lifetime") {
                        Text("/ \(productPeriod)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    
                    if let savings = productSavings {
                        Text(savings)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.green)
                    }
                }
                
                ZStack {
                    Circle()
                        .stroke(Color.purple.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.purple, Color.pink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 12, height: 12)
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(isSelected ? 0.08 : 0.03),
                                Color.purple.opacity(isSelected ? 0.12 : 0.06)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                Color.purple.opacity(isSelected ? 0.4 : 0.15),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
        }
    }
    
    private var productTitle: String {
        if product.id.contains("weekly") {
            return "Weekly"
        } else if product.id.contains("monthly") {
            return "Monthly"
        } else if product.id.contains("lifetime") {
            return "Lifetime"
        }
        return "Premium"
    }
    
    private var productDescription: String {
        if product.id.contains("weekly") {
            return "Perfect for occasional use"
        } else if product.id.contains("monthly") {
            return "Most popular choice"
        } else if product.id.contains("lifetime") {
            return "One-time purchase"
        }
        return "Premium features"
    }
    
    private var productPeriod: String {
        if product.id.contains("weekly") {
            return "week"
        } else if product.id.contains("monthly") {
            return "month"
        }
        return ""
    }
    
    private var productSavings: String? {
        if product.id.contains("monthly") {
            return "Save 58%"
        } else if product.id.contains("lifetime") {
            return "Best Value"
        }
        return nil
    }
    
    private var isPopularProduct: Bool {
        product.id.contains("monthly")
    }
}

// MARK: - Data Models

struct UserReview: Identifiable {
    let id = UUID()
    let name: String
    let initials: String
    let comment: String
}

struct PremiumFeature: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}



// MARK: - Sample Data

private let reviews: [UserReview] = [
    UserReview(name: "Sarah Johnson", initials: "SJ", comment: "Amazing app! Converts HEIC files instantly. Perfect quality every time. Highly recommended!"),
    UserReview(name: "Mike Chen", initials: "MC", comment: "Super fast conversion and the interface is beautiful. Worth every penny of the premium."),
    UserReview(name: "Emma Wilson", initials: "EW", comment: "Finally found an app that actually works. No more compatibility issues with my photos!"),
    UserReview(name: "David Brown", initials: "DB", comment: "Clean, simple, and effective. The quality settings are perfect for my needs.")
]

private let premiumFeatures: [PremiumFeature] = [
    PremiumFeature(icon: "bolt.fill", title: "Unlimited Conversions", description: "Convert as many photos as you want"),
    PremiumFeature(icon: "photo.on.rectangle.angled", title: "Batch Processing", description: "Convert multiple photos at once"),
    PremiumFeature(icon: "slider.horizontal.3", title: "Quality Control", description: "Adjust compression and quality settings"),
    PremiumFeature(icon: "rectangle.stack.badge.plus", title: "All Formats", description: "JPEG, PNG, WebP support"),
    PremiumFeature(icon: "icloud.and.arrow.up", title: "Cloud Sync", description: "Access your conversions anywhere"),
    PremiumFeature(icon: "xmark.circle", title: "No Ads", description: "Enjoy distraction-free experience")
]

#Preview {
    PremiumView()
} 