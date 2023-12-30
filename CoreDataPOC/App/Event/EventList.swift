//
//  EventList.swift
//  CoreDataPOC
//
//  Created by MahmoudFares on 28/12/2023.
//

import SwiftUI

struct EventList: View {
    @ObservedObject var viewModel: EventsViewModel
    @State var isPresent: Bool = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.currentState.events, id: \.self) { data in
                    VStack(alignment: .leading) {
                        if let imageData = Data(base64Encoded: data.eventImage ?? .empty, options: .ignoreUnknownCharacters),
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .frame(minHeight: 100, maxHeight: 100)

                        } else {
                            Image(systemName: "fireplace")
                                .resizable()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .frame(minHeight: 100, maxHeight: 100)
                        }
                        Text(data.eventName)
                        Text(data.eventDate ?? .now, style: .date)
                        Text("lat: \(data.eventPlace.lat), lon: \(data.eventPlace.long)")
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            viewModel.trigger(.delete(id: 0))
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresent.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .refreshable {
                viewModel.trigger(.fetch)
            }
            .searchable(text: .constant(""))
            .navigationTitle("Events")
            .sheet(isPresented: $isPresent) {
                print("Dismiss")
            } content: {
                AddEventView(viewModel: .init(repositry: .live))
            }
            .task {
                viewModel.trigger(.fetch)
            }
        }
    }
}

#Preview {
    EventList(
        viewModel: .init(
            repositry: .preview,
            addEvenViewModel: .init(repositry: .preview)
        )
    )
}
