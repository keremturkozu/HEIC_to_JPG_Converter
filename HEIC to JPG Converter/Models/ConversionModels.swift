import Foundation
import UIKit
import SwiftData

// MARK: - Conversion Format
enum ConversionFormat: String, CaseIterable {
    case jpg = "JPG"
    case jpeg = "JPEG"
    case png = "PNG"
    case webp = "WebP"
    
    var fileExtension: String {
        switch self {
        case .jpg: return "jpg"
        case .jpeg: return "jpeg"
        case .png: return "png"
        case .webp: return "webp"
        }
    }
    
    var icon: String {
        switch self {
        case .jpg: return "photo"
        case .jpeg: return "photo.fill"
        case .png: return "photo.fill.on.rectangle.fill"
        case .webp: return "photo.stack.fill"
        }
    }
    
    var description: String {
        switch self {
        case .jpg: return "Most common format, small file size"
        case .jpeg: return "High quality, widely supported"
        case .png: return "Transparency support, lossless"
        case .webp: return "Modern format, by Google"
        }
    }
}

// MARK: - Conversion State
enum ConversionState: Equatable {
    case idle
    case selecting
    case converting
    case completed
    case failed(Error)
    
    static func == (lhs: ConversionState, rhs: ConversionState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.selecting, .selecting), (.converting, .converting), (.completed, .completed):
            return true
        case (.failed(let lhsError), .failed(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

// MARK: - Conversion Job
@Model
final class ConversionJob {
    var originalImage: Data?
    var convertedImage: Data?
    var format: String
    var quality: Double
    var createdAt: Date
    var isCompleted: Bool
    
    init(originalImage: Data? = nil, convertedImage: Data? = nil, format: ConversionFormat, quality: Double = 0.7) {
        self.originalImage = originalImage
        self.convertedImage = convertedImage
        self.format = format.rawValue
        self.quality = quality
        self.createdAt = Date()
        self.isCompleted = false
    }
    
    var conversionFormat: ConversionFormat {
        ConversionFormat(rawValue: format) ?? .jpeg
    }
} 