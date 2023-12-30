//
//  ContentView.swift
//  CoreDataPOC
//
//  Created by MahmoudFares on 28/12/2023.
//

import PhotosUI
import SwiftUI
import UIKit

struct AddEventView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @ObservedObject var viewModel: AddEventViewModel
    var body: some View {
        Form {
            Section {
                VStack {
                    imageSelectionView
                    HStack {
                        Text("Event Name")
                        TextField(
                            "Event Name",
                            text: $viewModel.currentState.eventName
                        )
                        .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Event Place")
                        HStack {
                            TextField("lat", value: $viewModel.currentState.lat, format: .number)
                            TextField("long", value: $viewModel.currentState.long, format: .number)
                        }
                        .multilineTextAlignment(.trailing)
                    }
                    DatePicker(
                        "Event Date",
                        selection: $viewModel.currentState.eventDate,
                        displayedComponents: [.date]
                    )
                    Stepper(
                        "Number of Participants: \(viewModel.currentState.numberOfParticipants)",
                        value: $viewModel.currentState.numberOfParticipants, in: 0 ... 100
                    )
                }
                .buttonStyle(.plain)
            } header: {
                Text("Event Details")
            }

            Section {
                Button("Submit") {
                    viewModel.trigger(.submitButtonTapped)
                }
                .foregroundColor(.blue)
                .buttonStyle(.plain)
            }
            .navigationTitle("Event Form")
        }
    }
}

extension AddEventView {
    var imageSelectionView: some View {
        HStack {
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    HStack {
                        Text("Select a photo")
                        Spacer()
                        
                        if let imageData = Data(base64Encoded: viewModel.currentState.eventImage , options: .ignoreUnknownCharacters),
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                        } else {
                            Image(systemName: "photo.artframe")
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                        }
                    }
                    .foregroundStyle(.black)
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            if let imageData = UIImage(data: data)?.jpegData(compressionQuality: 0.8) {
                                viewModel.trigger(.selectedImage(imageBase65: imageData.base64EncodedString()))
                            }

                        }
                    }
                }
        }
    }
}

#Preview {
    AddEventView(viewModel: .init(repositry: .preview))
}
