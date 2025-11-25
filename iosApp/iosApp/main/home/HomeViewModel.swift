//
//  HomeViewModel.swift
//  iosApp
//
//  Created by Monokouma on 16/11/2025.
//

import Foundation
import SwiftUI
import Shared

@MainActor
class HomeViewModel: ObservableObject {
    private let sendConvertRequestUseCase: SendConvertRequestUseCase
    
    @Published var selectedImages: [UIImage] = []
    @Published var imagesData: [Data] = []
    @Published var selectedPlatform: MusicPlatform?
    @Published var isLoading = false
    
    init() {
        let koin = KoinHelper()
        self.sendConvertRequestUseCase = koin.sendConvertRequestUseCase()
    }
    
    var canConvert: Bool {
        !selectedImages.isEmpty && selectedPlatform != nil && !isLoading
    }
    
    func convertPlaylist() async -> Bool {
        guard !imagesData.isEmpty,
              let platform = selectedPlatform else { return false }
        
        isLoading = true
        
        let kotlinByteArrays = imagesData.map { data -> KotlinByteArray in
            print("Image size: \(data.count) bytes") // ← Debug
            print("First bytes: \(Array(data.prefix(8)))")
            let nsData = data as NSData
            return KotlinByteArray(size: Int32(nsData.length)) { index in
                var byte: UInt8 = 0
                nsData.getBytes(&byte, range: NSRange(location: Int(truncating: index), length: 1))
                return KotlinByte(value: Int8(bitPattern: byte))
            }
        }
        
        let request = ConvertRequestEntity(
            toPlatform: platform.apiValue,
            region: Locale.current.region?.identifier ?? "FR",
            images: kotlinByteArrays
        )
        
        do {
            let result = try await sendConvertRequestUseCase.invoke(convertRequestEntity: request)
            print(result?.enumerated())
            
            await MainActor.run {
                isLoading = false
            }
            return true
           
        } catch {
            await MainActor.run {
                isLoading = false
            }
            return false
        }
    }
}
