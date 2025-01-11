//
//  PhotoPicker.swift
//  iRemember
//
//  Created by Privat on 29.07.23.
//

import SwiftUI
import PhotosUI

struct PhotoPicker<Content: View>: View {
	
	@Binding var imageData: Data?
	@State private var selectedPhotos: [PhotosPickerItem] = []
	@State private var showPicker = false
	private let content: (Image?) -> Content
	
	init(_ imageData: Binding<Data?>, @ViewBuilder content: @escaping (Image?) -> Content) {
		self._imageData = imageData
		self.content = content
	}
	
	var body: some View {
		Group {
			if let imageData {
				content(imageData.image)
					.contextMenu {
						Button("Change", systemImage: "checkmark.circle") {
							showPicker.toggle()
						}
						Button("Remove", systemImage: "trash") {
							self.imageData = nil
						}
					}
			} else {
				content(nil)
					.onTapGesture {
						showPicker.toggle()
					}
			}
		}
		.photosPicker(isPresented: $showPicker, selection: $selectedPhotos, maxSelectionCount: 1, matching: .images)
		.dropDestination(for: Data.self) { items, location in
			guard let item = items.first else { return false }
			guard let _ = UIImage(data: item) else { return false }
			imageData = item
			return true
		}
		.onChange(of: selectedPhotos) { oldValue, newValue in
			loadImage()
		}
	}
	
	func loadImage() {
		selectedPhotos[0].loadTransferable(type: Data.self) { result in
			switch result {
			case .success(let data):
				self.imageData = data
			case .failure:
				assertionFailure("Image could not be loaded")
			}
		}
	}
	
}
