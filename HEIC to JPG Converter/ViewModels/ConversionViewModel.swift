import Foundation
import SwiftUI
import SwiftData
import PhotosUI
import UniformTypeIdentifiers

@MainActor
class ConversionViewModel: ObservableObject {
    @Published var selectedPhoto: PhotosPickerItem?
    @Published var originalImage: UIImage?
    @Published var convertedImageData: Data?
    @Published var selectedFormat: ConversionFormat = .jpeg
    @Published var quality: Double = 0.7
    @Published var conversionState: ConversionState = .idle
    @Published var currentStep: Int = 0
    
    private var modelContext: ModelContext?
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    // MARK: - Photo Selection
    func loadSelectedPhoto() async {
        guard let selectedPhoto = selectedPhoto else { return }
        
        do {
            if let data = try await selectedPhoto.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    self.originalImage = uiImage
                    self.conversionState = .selecting
                    self.currentStep = 1
                }
            }
        } catch {
            self.conversionState = .failed(error)
        }
    }
    
    // MARK: - Format Selection
    func selectFormat(_ format: ConversionFormat) {
        selectedFormat = format
        currentStep = 2
    }
    
    // MARK: - Quality Selection
    func setQuality(_ quality: Double) {
        self.quality = quality
    }
    
    func proceedToConversion() {
        currentStep = 3
        convertImage()
    }
    
    // MARK: - Image Conversion
    private func convertImage() {
        guard let originalImage = originalImage else { return }
        
        conversionState = .converting
        
        // Simulate conversion delay for better UX with smooth transition
        Task {
            try await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds
            
            // Prepare conversion data first
            let convertedData: Data?
            switch selectedFormat {
            case .jpg, .jpeg:
                convertedData = originalImage.jpegData(compressionQuality: quality)
            case .png:
                convertedData = originalImage.pngData()
            case .webp:
                // For WebP, we'll use JPEG as fallback since iOS doesn't natively support WebP encoding
                convertedData = originalImage.jpegData(compressionQuality: quality)
            }
            
            // Smooth transition to result
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                
                withAnimation(.easeInOut(duration: 0.5)) {
                    if let data = convertedData {
                        self.convertedImageData = data
                        self.saveConversionJob()
                        self.conversionState = .completed
                        
                        // Add slight delay before step transition for smoother UX
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                self.currentStep = 4
                            }
                        }
                    } else {
                        self.conversionState = .failed(ConversionError.conversionFailed)
                    }
                }
            }
        }
    }
    
    // MARK: - Data Persistence
    private func saveConversionJob() {
        guard let modelContext = modelContext,
              let originalImageData = originalImage?.jpegData(compressionQuality: 1.0) else { return }
        
        let job = ConversionJob(
            originalImage: originalImageData,
            convertedImage: convertedImageData,
            format: selectedFormat,
            quality: quality
        )
        job.isCompleted = true
        
        modelContext.insert(job)
        try? modelContext.save()
    }
    
    // MARK: - Actions
    func shareImage() {
        guard let imageData = convertedImageData,
              let image = UIImage(data: imageData) else { return }
        
        let activityController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityController, animated: true)
        }
    }
    
    func saveToPhotos() {
        guard let imageData = convertedImageData,
              let image = UIImage(data: imageData) else { return }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    func downloadImage() -> URL? {
        guard let imageData = convertedImageData else { return nil }
        
        let fileName = "converted_image.\(selectedFormat.fileExtension)"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsPath.appendingPathComponent(fileName)
        
        do {
            try imageData.write(to: fileURL)
            return fileURL
        } catch {
            return nil
        }
    }
    
    // MARK: - Reset
    func reset() {
        selectedPhoto = nil
        originalImage = nil
        convertedImageData = nil
        selectedFormat = .jpeg
        quality = 0.7
        conversionState = .idle
        currentStep = 0
    }
}

// MARK: - Conversion Error
enum ConversionError: LocalizedError, Equatable {
    case conversionFailed
    case fileNotFound
    
    var errorDescription: String? {
        switch self {
        case .conversionFailed:
            return "Dönüştürme işlemi başarısız oldu"
        case .fileNotFound:
            return "Dosya bulunamadı"
        }
    }
} 