//
//  QRGeneratorView.swift
//  QRCode
//
//  Created by Julian Springer on 11.01.25.
//


import SwiftUI
import CoreImage.CIFilterBuiltins
import AVFoundation


struct UserSheet: View {
    let user: Profile
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            /*
             var id: Int
             var userName: String
             var firstName: String
             var lastName: String?
             var phoneNumber: String?
             var instagram: String?
             var birthday: Date?
             var gender: Gender
             var pictureData: Data?
             var friends: [Profile]
             */
            Text(user.userName)
                .font(.title)
                .bold()
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Birthday:")
                        .fontWeight(.semibold)
                    Text("\(user.birthday)")
                }
                
                HStack {
                    Text("Email:")
                        .fontWeight(.semibold)
                    Text(user.instagram ?? "Not provided")
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .padding(.top, 40)
    }
}


struct QRGeneratorView: View {
    @Environment(Profile.self) var profile: Profile
    @State private var qrCode: UIImage?
    @State private var isShowingScanner = false
    @State private var isShowingMessage = false
    @State private var isShowingUserInfo = false
    @State private var isSuccess = false
    @State private var messageText = ""
    @State private var currentUser: Profile?
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        ZStack {
            // QR Code in center
            VStack {
                Spacer()
                if let qrCode {
                    Image(uiImage: qrCode)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300) // Increased size
                }
                Spacer()
            }
            
            // Button layout
            VStack {
                Spacer()
                Button(action: {
                    isShowingScanner = true
                }) {
                    HStack {
                        Image(systemName: "qrcode.viewfinder")
                            .font(.system(size: 20))
                        Text("Scan QR Code")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 30) // Safe area padding
            }
        }
        .onReceive(timer) { _ in
            let qr_content = "\(getCurrentTime());\(profile.id)"
            qrCode = generateQRCode(from: qr_content)
        }
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(
                codeTypes: [.qr],
                completion: handleScan
            )
        }
        .sheet(isPresented: $isShowingMessage) {
            MessageSheet(isSuccess: isSuccess, message: messageText)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $isShowingUserInfo) {
            if let user = currentUser {
                UserSheet(user: user)
                    .presentationDetents([.medium])
            }
        }
    }
    
    struct MessageSheet: View {
        let isSuccess: Bool
        let message: String
        
        var body: some View {
            VStack(spacing: 20) {
                Image(systemName: isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(isSuccess ? .green : .red)
                
                Text(isSuccess ? "Success!" : "Error")
                    .font(.title)
                    .bold()
                
                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .padding(.top, 40)
        }
    }
    
    private func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let result):
            let scannedData = result.string.components(separatedBy: ";")
            if scannedData.count == 2 {
                let timestamp = scannedData[0]
                let userId = scannedData[1]
                GetLastPartyEndpoint()
                    .sendRequest { result in
                        if case .success(let data) = result {
                            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                let partyId = jsonObject["id"] as! Int
                                CheckInEndpoint(userId: userId, partyId: partyId)
                                    .sendRequest { result in
                                        if case .success(let data) = result {
                                            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                                if let message = jsonObject["message"] as? String {
                                                    isSuccess = false
                                                    messageText = message
                                                    isShowingMessage = true
                                                } else if let error = jsonObject["error"] as? String {
                                                    isSuccess = false
                                                    messageText = error
                                                    isShowingMessage = true
                                                } else {
                                                    isSuccess = true
                                                    messageText = "Successfully checked in"
                                                    isShowingMessage = true
                                                }
                                            }
                                        }
                                    }
                            }
                            // show user information by first getting user infos by GetUserByIdEndpoint(userId).sendRequest { result in {...} }
                            GetUserByIdEndpoint(id: userId)
                                            .sendRequest { result in
                                                if case .success(let data) = result {
                                                    if let user = try? Profile.load(from: data) {
                                                        currentUser = user
                                                        isShowingUserInfo = true
                                                    }
                                                }
                                            }
                        } else {
                            isSuccess = false
                            messageText = "You are not in a party"
                            isShowingMessage = true
                        }
                    }
                
            }
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
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

/*
 struct QRGeneratorView: View {
 @Environment(Profile.self) var profile: Profile
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
 var qr_content = "\(getCurrentTime());\(profile.id)"
 qrCode = generateQRCode(from: qr_content)
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
 */
