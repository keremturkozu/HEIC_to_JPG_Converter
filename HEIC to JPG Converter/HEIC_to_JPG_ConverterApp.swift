//
//  HEIC_to_JPG_ConverterApp.swift
//  HEIC to JPG Converter
//
//  Created by Kerem Türközü on 30.06.2025.
//

import SwiftUI
import SwiftData

@main
struct HEIC_to_JPG_ConverterApp: App {
    @StateObject private var storeManager = StoreKitManager.shared
    @State private var isLaunchScreenActive = true
    @State private var shouldShowPremium = false
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ConversionJob.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ZStack {
                if isLaunchScreenActive {
                    LaunchScreenView()
                        .transition(.opacity)
                } else {
                    if shouldShowPremium {
                        PremiumView()
                            .transition(.opacity)
                    } else {
                        ContentView()
                            .transition(.opacity)
                    }
                }
            }
            .animation(.easeInOut(duration: 0.5), value: isLaunchScreenActive)
            .animation(.easeInOut(duration: 0.5), value: shouldShowPremium)
            .modelContainer(sharedModelContainer)
            .onAppear {
                // Show launch screen for 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation {
                        isLaunchScreenActive = false
                        
                        // Check subscription status after launch screen
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if !storeManager.isSubscribed {
                                shouldShowPremium = true
                            }
                        }
                    }
                }
            }
            .onChange(of: storeManager.isSubscribed) { _, isSubscribed in
                if isSubscribed && shouldShowPremium {
                    withAnimation {
                        shouldShowPremium = false
                    }
                }
            }
        }
    }
}
