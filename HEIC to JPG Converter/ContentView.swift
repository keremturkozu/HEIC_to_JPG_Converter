//
//  ContentView.swift
//  HEIC to JPG Converter
//
//  Created by Kerem Türközü on 30.06.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = ConversionViewModel()
    @StateObject private var storeManager = StoreKitManager.shared
    
    var body: some View {
        ZStack {
            // Background
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
            
            // Main content based on current step
            Group {
                switch viewModel.currentStep {
                case 0:
                    PhotoPickerView(viewModel: viewModel)
                case 1:
                    FormatSelectionView(viewModel: viewModel)
                case 2:
                    QualitySelectionView(viewModel: viewModel)
                case 3:
                    ConvertingView(viewModel: viewModel)
                case 4:
                    ResultView(viewModel: viewModel)
                default:
                    PhotoPickerView(viewModel: viewModel)
                }
            }
            .animation(.easeInOut(duration: 0.5), value: viewModel.currentStep)
        }
        .onAppear {
            viewModel.setModelContext(modelContext)
        }
        .onChange(of: viewModel.conversionState) { _, newState in
            switch newState {
            case .completed:
                withAnimation(.spring().delay(0.5)) {
                    viewModel.currentStep = 4
                }
            case .failed(let error):
                print("Conversion failed: \(error.localizedDescription)")
                // Handle error state if needed
            default:
                break
            }
        }

    }
}

#Preview {
    ContentView()
        .modelContainer(for: ConversionJob.self, inMemory: true)
}
