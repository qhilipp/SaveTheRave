//
//  QRGeneratorView.swift
//  QRCode
//
//  Created by Julian Springer on 11.01.25.
//


import SwiftUI
import CoreImage.CIFilterBuiltins
import AVFoundation

struct QRGeneratorView: View {
    @State private var qrCode: UIImage?
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        VStack {
            if let qrCode {
                Image(uiImage: qrCode)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .onReceive(timer) { _ in
            // TODO data is getCurrentTime(), must be change to something meaningful
            qrCode = generateQRCode(from: getCurrentTime())
        }
    }
    
    private func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }
    
    private func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}
